extends Control

onready var richTextLabel = $RichTextLabel

# Variables
var dialogs = {
	"0" : [ "Welcome to boss fights", "'X' - ATTACKS", "'Z' - EVADES", "Good luck, you're  going to need it"],
	"1" : [ "Beware D Trainer"]
}
var page = 0

var level = Global.get_level_number()
var dialog = dialogs[str(level)]
# Functions
func _ready():
	set_process_input(true)
	richTextLabel.set_bbcode(dialog[page])
	richTextLabel.set_visible_characters(0)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		if richTextLabel.get_visible_characters() > richTextLabel.get_total_character_count():
			if page < dialog.size() - 1:
				page += 1
				richTextLabel.set_bbcode(dialog[page])
				richTextLabel.set_visible_characters(0)
		else:
			richTextLabel.set_visible_characters(richTextLabel.get_total_character_count())
			
		if page  == dialog.size() - 1 and dialog[page].length() == richTextLabel.get_visible_characters() - 1:
			call_deferred("queue_free")

func _on_Timer_timeout():
	if dialog[page].length() >= richTextLabel.get_visible_characters():
		richTextLabel.set_visible_characters(richTextLabel.get_visible_characters()+1)
