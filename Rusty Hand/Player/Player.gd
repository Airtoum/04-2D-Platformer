extends KinematicBody2D

onready var Explosion = load("res://Entities/Explosion.tscn")

onready var SM = $StateMachine
onready var tilemap = get_node("/root/Game/TileMap")

var velocity = Vector2(0.0, 0.0)
var normal_gravity = 1550.0
var jump_gravity = 900.0
var acceleration = Vector2(0.0, normal_gravity)
var move_speed = 300
var jump_speed = -560
var run_and_jump_speed = -640
var jump_released = true
var flipH = false
var default_coyote_time = 4.0 / 60.0 # seconds
var coyote_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$State.text = SM.state_name
	$RobotGirl.flip_h = flipH
	$RobotGirl.offset.x = 1 if flipH else -1
	if velocity.y > 0 and $RobotGirl.animation == "Jumping":
		$RobotGirl.play("Falling_Start")

func _physics_process(delta):
	if SM.state_name == "Dead":
		return
	if Input.is_action_just_released("up"):
		jump_released = true
	velocity += acceleration * delta
	velocity = move_and_slide(velocity, Vector2.UP, false)
	handle_direction(Input.is_action_pressed("left"), Input.is_action_pressed("right"))
	if is_on_wall():
		velocity.x = 0
	coyote_time -= delta # delta because it's in seconds
	$Cursor.visible = false
	$Cursor2.visible = false
	$Cursor3.visible = false
	$Cursor4.visible = false
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider == tilemap:
			# I test each collision at 4 different points just in case if it's on a bad edge or corner
			for x in [-1, 1]:
				for y in [-1, 1]:
					var tile = get_tile_at_pos(collision.position + Vector2(x * 0.1, y * 0.1))
					#if tile == 2:
					#	die()
	var tile = get_tile_at_pos(position)
	match tile:
		2: # spikes
			die()
		4: # uppinators
			velocity.y += -1650.0
			SM.set_state("Falling")
			set_animation("Falling")
		6: # oil
			set_tile_at_pos(position, TileMap.INVALID_CELL)
	
func get_tile_at_pos(pos):
	var input_position = pos - tilemap.position
	input_position /= tilemap.scale.x
	var grid_position = tilemap.world_to_map(input_position)
	var tile = tilemap.get_cellv(grid_position)
	return tile
	
func set_tile_at_pos(pos, tile):
	var input_position = pos - tilemap.position
	input_position /= tilemap.scale.x
	var grid_position = tilemap.world_to_map(input_position)
	tilemap.set_cellv(grid_position, tile)

func die():
	var explosion = Explosion.instance()
	explosion.position = position
	get_parent().add_child(explosion)
	SM.set_state("Dead")
	print("Ouch! I should be dead right now.")
	
func set_animation(anim):
	if $RobotGirl.animation != anim:
		$RobotGirl.play(anim)


func _on_RobotGirl_animation_finished():
	if $RobotGirl.animation == "Falling_Start":
		$RobotGirl.play("Falling")

func handle_direction(isleft, isright):
	if isleft != isright:
		flipH = isleft
