extends Control

onready var Global = get_node("/root/Global")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var save_game = File.new()
	if not save_game.file_exists(Global.SAVE_PATH):
		$Continue.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_New_Game_pressed():
	Global.load_next_level()

func _on_Continue_pressed():
	Global.load_game()

func _on_Quit_pressed():
	get_tree().quit()

func _on_Menu_pressed():
	get_tree().change_scene("res://Menu-UI/Menu.tscn")
