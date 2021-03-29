extends Node

const SAVE_PATH = "user://savegame.sav"
const ENCRYPT_KEY = "keel pluming wards bleeper"

var antigrav_tile_strength = 2400.0
var score = 0
var level = 0
var levels = ["res://Menu-UI/Menu.tscn", #index 0, so it should be menu or something
			  "res://Level1.tscn",
			  "res://Level2.tscn",
			  "res://Menu-UI/YouWin.tscn"]

var save_data = {
	"general": {
		"level":0,
		"score":0
	}
}

func _process(delta):
	if Input.is_action_pressed("quit"):
		get_tree().quit()

func load_next_level():
	level += 1
	print(level)
	print(levels.size())
	if level >= levels.size():
		print("you win!")
	else:
		save_game()
		get_tree().change_scene(levels[level])
		
func revert_score():
	score = save_data["general"]["score"]

func save_game():
	save_data["general"]["level"] = level
	save_data["general"]["score"] = score
	var save_game = File.new()
	save_game.open_encrypted_with_pass(SAVE_PATH, File.WRITE, ENCRYPT_KEY)
	save_game.store_string(to_json(save_data))
	save_game.close()
	print("Game saved with save data " + str(save_data))
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists(SAVE_PATH):
		return
	save_game.open_encrypted_with_pass(SAVE_PATH, File.READ, ENCRYPT_KEY)
	var contents = save_game.get_as_text()
	var result_json = JSON.parse(contents)
	if result_json.error == OK:
		save_data = result_json.result
	else:
		print("Error: ", result_json.error)
	save_game.close()
	
	level = save_data["general"]["level"] - 1
	score = save_data["general"]["score"]
	load_next_level()
