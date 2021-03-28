extends "res://StateMachine/StateMachineState.gd"

# Jumping is exactly like falling but with lower gravity. You start "falling" the instant you release the jump key.

func weightedSum(a1, w1, a2, w2):
	return a1 * w1 + a2 * w2

func start():
	if abs(myEnt.velocity.x) >= myEnt.move_speed * 0.5:
		myEnt.velocity.y = myEnt.run_and_jump_speed
	else:
		myEnt.velocity.y = myEnt.jump_speed
	myEnt.acceleration.y = myEnt.jump_gravity
	myEnt.jump_released = false
	myEnt.set_animation("Jumping")
	myEnt.coyote_time = 0.0

func physics_process(_delta):
	if myEnt.is_on_floor():
		if abs(myEnt.velocity.x) <= 10:
			SM.set_state("Idle")
		else:
			SM.set_state("Moving")
	if myEnt.velocity.y > 0 and myEnt.get_node("RobotGirl").animation == "Jumping":
		myEnt.set_animation("Falling_Start")
	#air movement, no automatic decelleration 
	if Input.is_action_pressed("left"):
		myEnt.velocity.x = weightedSum(myEnt.velocity.x, 0.8, -myEnt.move_speed, 0.2)
	if Input.is_action_pressed("right"):
		myEnt.velocity.x = weightedSum(myEnt.velocity.x, 0.8, myEnt.move_speed, 0.2)
	if not Input.is_action_pressed("up"):
		SM.set_state("Falling")
