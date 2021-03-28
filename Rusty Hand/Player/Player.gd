extends KinematicBody2D

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
			$Cursor2.global_position = collision.position
			$Cursor2.visible = true
			$Cursor3.global_position = position - collision.normal * 60
			$Cursor3.visible = true
			#$Cursor4.global_position = collision.position - collision.collider.position
			#$Cursor4.visible = true
			
			var grid_position = tilemap.world_to_map(collision.position - collision.collider.position)
			grid_position += Vector2(-0.001, 0.001)
			# project it a teensy bit away from the player to make sure its in the tile
			grid_position /= tilemap.scale.x
			#grid_position += (grid_position - position) * 0.02
			print(grid_position)
			$Cursor.global_position = tilemap.map_to_world(grid_position) * tilemap.scale.x + tilemap.position
			$Cursor.visible = true
			print(tilemap.get_cellv(grid_position))
	
func set_animation(anim):
	if $RobotGirl.animation != anim:
		$RobotGirl.play(anim)


func _on_RobotGirl_animation_finished():
	if $RobotGirl.animation == "Falling_Start":
		$RobotGirl.play("Falling")

func handle_direction(isleft, isright):
	if isleft != isright:
		flipH = isleft
