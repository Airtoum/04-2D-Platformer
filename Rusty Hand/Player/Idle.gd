extends "res://StateMachine/StateMachineState.gd"





func start():
	myEnt.velocity.x = 0
	myEnt.set_animation("Idle")

func physics_process(_delta):
	if not myEnt.is_on_floor():
		SM.set_state("Falling")
	else:
		myEnt.velocity.y = 0
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		SM.set_state("Moving")
	if myEnt.is_on_floor() and myEnt.jump_released and Input.is_action_pressed("up"):
		SM.set_state("Jumping")

func end():
	myEnt.coyote_time = myEnt.default_coyote_time # seconds
