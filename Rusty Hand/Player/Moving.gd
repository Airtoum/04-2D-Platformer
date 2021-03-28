extends "res://StateMachine/StateMachineState.gd"



func weightedSum(a1, w1, a2, w2):
	return a1 * w1 + a2 * w2

func start():
	myEnt.set_animation("Running")

func physics_process(_delta):
	if not myEnt.is_on_floor():
		SM.set_state("Falling")
	else:
		myEnt.velocity.y = 0
	#ground movement, automatic decelleration 
	if Input.is_action_pressed("left"):
		myEnt.velocity.x = weightedSum(myEnt.velocity.x, 0.8, -myEnt.move_speed, 0.2)
	if Input.is_action_pressed("right"):
		myEnt.velocity.x = weightedSum(myEnt.velocity.x, 0.8, myEnt.move_speed, 0.2)
	if not(Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		myEnt.velocity.x = weightedSum(myEnt.velocity.x, 0.8, 0, 0.2)
		if abs(myEnt.velocity.x) <= 10:
			SM.set_state("Idle")
	if myEnt.is_on_floor() and myEnt.jump_released and Input.is_action_pressed("up"):
		SM.set_state("Jumping")

func end():
	myEnt.coyote_time = myEnt.default_coyote_time # seconds
