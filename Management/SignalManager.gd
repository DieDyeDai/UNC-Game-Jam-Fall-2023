extends Node

# PLACE ALL SIGNALS HERE

#GAME CONTROL
signal game_started
signal goto_scene(scene)
signal restarted

signal next_scene_triggered
signal portal_entered

signal focus_entered

#MECHANICS

signal player_killed(body)
signal died

#OBSTACLES
signal laser_received(body)

signal barrier_open
signal barrier_close
signal barrier_toggle

signal exited_level_bounds

signal player_spring_redirect(displacement, direction, force, upboost, damp)
signal player_spring_constant(displacement, direction, force, upboost)

var seconds_decimal = 1.0

func _process(delta):
	seconds_decimal -= delta
	if seconds_decimal < 0:
		seconds_decimal = 1.0

