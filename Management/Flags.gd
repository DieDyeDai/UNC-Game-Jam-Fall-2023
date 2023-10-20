
extends Node

"""
Collision Layers:
	Tiles: 1, 2
	Player: 1, 2, 8
		RayCast detects 2, RayCastLong detects 1, 2
	Loading Zones: 7, 8
	PushBlock, IceBlock: 1, 2
		RayCast detects 2
	so Button should be on layer 1
	
	and Portal and Player should be on layer 3?

"""

var tile_size = 16
var anim_speed = 0.08

var saved_level = "res://Maps/Test/TestMap1.tscn"
var exit_id
var target_exit_id
var during_scene_transition : bool = false
#disables loading zones
var loading_zones_enabled : bool = true

var during_scene_fadeout : bool = false
#for switching player camera
var during_scene_fadein : bool = false
# detects first 0.75s/1s of fadein
# for disabling player input

#for

# Called when the node enters the scene tree for the first time.
func _ready():
	saved_level = "res://Maps/Test/TestMap.tscn"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
