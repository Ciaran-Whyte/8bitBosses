extends KinematicBody2D

var state = IDLE
var velocity = Vector2.ZERO
export var MAX_SPEED = 40
export var ACCELERATION = 500
export var ATTACK_RANGE = 35
export var SPELL_RANGE = 120
export var FRICTION = 500
export var MAX_THIA_FIVES = 1
var CURRENT_THIA_FIVES = 0

enum {
	MOVE,
	SPELL,
	ATTACK,
	IDLE
}

const ThaiFive = preload("res://Enemies/thaiFive.tscn")
const DTrainerHurtSound = preload("res://Player/DTrainerHurtSound.tscn")

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $HurtBox
onready var spellCoolDown = $SpellCoolDown

var thai_five_cool_down = true

func _ready():
	animationTree.active = true 

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		SPELL:
			spell_state(delta)
		ATTACK:
			attack_state(delta)
		IDLE:
			idle_state()
	
	velocity = move_and_slide(velocity)

func move_state(delta):
	animationTree.set("parameters/Run/blend_position", velocity)
	animationTree.set("parameters/Spell/blend_position", velocity)
	animationTree.set("parameters/Attack/blend_position", velocity)
	animationTree.set("parameters/Idle/blend_position", velocity)
	animationState.travel("Run")
	var player = playerDetectionZone.player
	if player != null:
		accelerate_towards_point(player.global_position, delta)
		
func accelerate_towards_point(point,delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta )
	if(global_position.distance_to(point) <= SPELL_RANGE and thai_five_cool_down):
		state = SPELL
	elif(global_position.distance_to(point) <= ATTACK_RANGE):
		state = ATTACK
	else:
		state = MOVE
		
func spell_state(delta):
	if time_to_thai_five():
		velocity = velocity.move_toward(Vector2.ZERO * FRICTION, ACCELERATION * delta )
		animationState.travel("Spell")
	else:
		state = MOVE

func time_to_thai_five():
	var in_spell_range = global_position.distance_to(playerDetectionZone.player.global_position) < SPELL_RANGE
	var max_active_thai_fives = Global.level_1_globals['CURRENT_THAI_FIVES'] < Global.level_1_globals['MAX_THAI_FIVES']
	return in_spell_range and max_active_thai_fives and thai_five_cool_down
	
func thai_five():
	var thaiFive = ThaiFive.instance()
	get_parent().add_child(thaiFive)
	thaiFive.global_position = global_position
	thaiFive.launch()
	spellCoolDown.start(3)
	thai_five_cool_down = false
	Global.level_1_globals['CURRENT_THAI_FIVES'] += 1
	
func attack_state(delta):
	if(global_position.distance_to(playerDetectionZone.player.global_position) > ATTACK_RANGE + 10):
		state = MOVE
	else:
		velocity = velocity.move_toward(Vector2.ZERO * FRICTION, ACCELERATION * delta )
		animationState.travel("Attack")
		
	
func idle_state():
	animationState.travel("Idle")
	
func _on_PlayerDetectionZone_body_entered(_body):
	state = MOVE

func _on_HurtBox_area_entered(area):
	BossStats.boss_health-= area.damage
	hurtbox.start_invincibility(0.6)
	hurtbox.create_hit_effect()
	var dTrainerHurtSound = DTrainerHurtSound.instance()
	if get_tree().current_scene != null:
		get_tree().current_scene.add_child(dTrainerHurtSound)

func _on_SpellCoolDown_timeout():
	thai_five_cool_down = true
	
