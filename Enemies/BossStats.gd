extends Node

export(int) var boss_max_health = 10 setget boss_set_max_health
var boss_health = boss_max_health setget boss_set_health

signal boss_no_health
signal boss_health_changed(value)
signal boss_max_health_changed(value)

func boss_set_max_health(value):
	boss_max_health = value
	self.boss_health = min(boss_health, boss_max_health)
	emit_signal("boss_max_health_changed", boss_max_health)
	
func boss_set_health(value):
	boss_health = value
	emit_signal("boss_health_changed", boss_health)
	if boss_health <= 0:
		emit_signal("boss_no_health")

func _ready():
	self.boss_health = boss_max_health

func reset():
	self.boss_health = boss_max_health
