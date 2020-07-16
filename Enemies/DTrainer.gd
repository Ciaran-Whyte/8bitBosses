extends KinematicBody2D

var state = MOVE
var velocity = Vector2.ZERO
export var MAX_SPEED = 40
export var ACCELERATION = 500
export var ATTACK_RANGE = 35
export var FRICTION = 500
enum {
	MOVE,
	SPELL,
	ATTACK,
	IDLE
}

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var playerDetectionZone = $PlayerDetectionZone


func _ready():
	animationTree.active = true 

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		SPELL:
			spell_state()
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
	if(global_position.distance_to(point) <= ATTACK_RANGE):
		state = ATTACK
	
func spell_state():
	animationState.travel("Spell")
	
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
