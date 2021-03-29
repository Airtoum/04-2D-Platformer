extends KinematicBody2D

onready var Explosion = load("res://Entities/Explosion.tscn")
onready var Global = get_node("/root/Global")

onready var tilemap = get_node("/root/Game/TileMap")
onready var SM = $StateMachine
onready var player = get_node("/root/Game/Player")

var velocity = Vector2(0.0, 0.0)
var gravity = 1550.0
var acceleration = Vector2(0.0, gravity)
var jump_speeds = [-800, -1200, -1600]
var jump_speed = -1200
var move_speed = 40
var loaded = false
var activation_radius = 600
var follow_range = 1800

# Called when the node enters the scene tree for the first time.
func _ready():
	SM.enabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if $VisibilityNotifier2D.is_on_screen() and distance_to_player() <= activation_radius:
		loaded = true
		SM.enabled = true
		play_animation()
	if not loaded:
		return
	velocity += acceleration * delta
	var old_pos = position
	position = position + velocity * delta
	position = old_pos
	velocity = move_and_slide(velocity, Vector2.UP, false)
	if is_on_wall():
		velocity.x = 0
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
		4: # uppinators
			velocity.y += -Global.antigrav_tile_strength * delta
			velocity.x += sign(player.position.x - position.x)
	
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

func distance_to_player():
	return (position - player.position).length()

func set_animation(anim):
	if $AnimatedSprite.animation != anim:
		$AnimatedSprite.play(anim)
		
func play_animation():
	if loaded:
		$AnimatedSprite.play()

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Charging":
		SM.set_state("Leaping")
