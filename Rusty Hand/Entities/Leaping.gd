extends "res://StateMachine/StateMachineState.gd"





func start():
	myEnt.velocity = Vector2(myEnt.move_speed, myEnt.jump_speed)
	myEnt.set_animation("Leaping")
	print("Leap! With " + String(myEnt.velocity))

func physics_process(_delta):
	if myEnt.is_on_floor() and myEnt.velocity.y >= 0:
		SM.set_state("Charging")
