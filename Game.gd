extends Node2D

const LEVEL_PATH = "res://Levels/Level%d.tscn"

var level_number:int = 1
var defeated_bosess = [0,0,0,0,0,0,0,0]

var level_1_globals = {
	"MAX_THAI_FIVES" : 1,
	"CURRENT_THAI_FIVES": 0
}

func _ready():
	call_deferred("init")

func reset():
	print("reload_current_scene")
	PlayerStats.set_health(PlayerStats.max_health)
	level_1_globals['CURRENT_THAI_FIVES'] = 0
	load_level(1)

func init():
	PlayerStats.connect("no_health", self, "reset")
	load_level(level_number)

func load_level(num:int):
	call_deferred("_deferred_goto_level", num)
	
func _deferred_goto_level(num:int):
	level_number = num
	var root = get_tree().root
	var level = root.get_child(root.get_child_count() - 1)
	level.free()
	level = ResourceLoader.load(LEVEL_PATH % num).instance()
	get_tree().get_root().add_child(level)
	return true

func get_level_number():
	return level_number

func is_level_bossed_defeated():
	return defeated_bosess[level_number] == 1








