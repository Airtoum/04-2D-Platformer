extends KinematicBody2D

onready var Explosion = load("res://Entities/Explosion.tscn")
onready var Global = get_node("/root/Global")

onready var tilemap = get_node("/root/Game/TileMap")

var velocity = Vector2(0.0, 0.0)
var gravity = 1550.0
var acceleration = Vector2(0.0, gravity)
var move_speed = 150
export var flipH = true
var loaded = false
export var box_collider = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if box_collider:
		$CollisionShape2D.disabled = true
		$CollisionShape2D3.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite.flip_h = flipH

func _physics_process(delta):
	if $VisibilityNotifier2D.is_on_screen():
		loaded = true
	if not loaded:
		return
	if flipH:
		velocity.x = move_speed
	else:
		velocity.x = -move_speed
	velocity += acceleration * delta
	velocity = move_and_slide(velocity, Vector2.UP, false)
	if is_on_wall():
		velocity.x = 0
		#flipH = !flipH
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Player":
			if collision.position.y > global_position.y:
				collision.collider.die()
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
			velocity.y += -Global.antigrav_tile_strength * delta
	
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
	print("Ouch! The enemy should be dead right now.")
	var explosion = Explosion.instance()
	explosion.position = position
	get_parent().add_child(explosion)
	queue_free()

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.die()
	else:
		flipH = !flipH
