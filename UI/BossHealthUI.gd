extends Control

var boss_hearts = 10 setget boss_set_hearts
var boss_max_hearts = 10 setget boss_set_max_hearts

onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty

func boss_set_hearts(value):
	boss_hearts= clamp(value, 0, boss_max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = boss_hearts * 16

func boss_set_max_hearts(value):
	boss_max_hearts= max(value, 1)
	self.boss_hearts= min(boss_hearts, boss_max_hearts)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = boss_max_hearts * 16

func _ready():
	self.boss_max_hearts = BossStats.boss_max_health
	self.boss_hearts = BossStats.boss_health
# warning-ignore:return_value_discarded
	BossStats.connect("boss_health_changed", self, "boss_set_hearts")
# warning-ignore:return_value_discarded
	BossStats.connect("boss_max_health_changed", self, "boss_set_max_hearts")
