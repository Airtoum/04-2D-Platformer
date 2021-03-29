extends "res://StateMachine/StateMachineState.gd"





func start():
	myEnt.velocity.x = 0
	myEnt.set_animation("Charging")
	myEnt.play_animation()

func physics_process(_delta):
	var vert_diff = myEnt.player.position.y - myEnt.position.y
	var horiz_diff = myEnt.player.position.x - myEnt.position.x
	var est_airtime = ( -myEnt.jump_speed + sqrt(myEnt.jump_speed * myEnt.jump_speed - 4 * (myEnt.gravity) * (-vert_diff)) ) / (2 * myEnt.gravity)
	#print(est_airtime)
	if (not est_airtime >= 0) and (not est_airtime < 0) or myEnt.distance_to_player() > myEnt.follow_range:
		# sqrt of negative, no solutions. hop in place.
		myEnt.move_speed = 0
	else:
		myEnt.move_speed = horiz_diff * 0.5 / est_airtime
