extends "res://StateMachine/StateMachineState.gd"



func weightedSum(a1, w1, a2, w2):
	return a1 * w1 + a2 * w2

func start():
	myEnt.acceleration.y = myEnt.normal_gravity
	myEnt.jump_released = true
	if myEnt.velocity.y < -350:
		myEnt.velocity.y = -350
	#myEnt.set_animation("Falling_Start")

func physics_process(_delta):
	if myEnt.is_on_floor():
		if myEnt.velocity.y >= 0:
			myEnt.velocity.y = 0
		if abs(myEnt.velocity.x) <= 10:
			SM.set_state("Idle")
		else:
			SM.set_state("Moving")
	if myEnt.is_on_ceiling() and myEnt.velocity.y <= 0:
		myEnt.velocity.y = 0
	#air movement, no automatic decelleration 
	if Input.is_action_pressed("left"):
		myEnt.velocity.x = weightedSum(myEnt.velocity.x, 0.8, -myEnt.move_speed, 0.2)
	if Input.is_action_pressed("right"):
		myEnt.velocity.x = weightedSum(myEnt.velocity.x, 0.8, myEnt.move_speed, 0.2)
	if myEnt.is_on_floor() and myEnt.jump_released and Input.is_action_pressed("up"):
		SM.set_state("Jumping")
	if myEnt.coyote_time > 0 and myEnt.jump_released and Input.is_action_pressed("up"):
		SM.set_state("Jumping")
		print("coyote jump!")
