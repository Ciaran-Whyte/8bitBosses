extends KinematicBody2D

const MAX_SPEED = 60
const ACCELERATION = 4

var velocity  = Vector2.ZERO
var player = null
var target = null


func _ready():
	set_physics_process(false)

func launch():
	set_physics_process(true)

func _physics_process(delta):
	if player != null:
		if target == null:
			target = ( player.global_position  - self.global_position ).normalized()
		velocity = velocity.move_toward(target * MAX_SPEED, ACCELERATION * delta )
		var hit = move_and_collide(velocity)
		if hit != null:
			remove_thai_five()
		
func _on_PlayerDectionZone_body_entered(body):
	player = body

func _on_Timer_timeout():
	remove_thai_five()

func remove_thai_five():
	call_deferred("queue_free")
	Global.level_1_globals['CURRENT_THAI_FIVES'] -= 1
