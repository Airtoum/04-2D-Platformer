extends Label

onready var Global = get_node("/root/Global")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.score == 1:
		text = "1 LITRE"
	else:
		text = String(Global.score) + " LITRES"
