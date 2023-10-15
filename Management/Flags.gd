extends Node

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
