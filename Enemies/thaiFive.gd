extends KinematicBody2D

const MAX_SPEED = 100
const ACCELERATION = 5

var velocity  = Vector2.ZERO
var player = null


func _ready():
	set_physics_process(false)

func launch():
	set_physics_process(true)

func _physics_process(delta):
	if player != null:
		var target = ( player.global_position - self.global_position ).normalized()
		velocity = velocity.move_toward(target * MAX_SPEED, ACCELERATION * delta )
		move_and_collide(velocity)
		
func _on_PlayerDectionZone_body_entered(body):
	player = body

func _on_Timer_timeout():
	call_deferred("queue_free")
