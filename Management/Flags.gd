
extends Node

"""
	Screen size 720x540, zoom 2: Screen fits 24x18 tiles (centered)

Collision Layers:
	Tiles: 1, 2
	Doors: 1, 2
	Player: 1, 2, 8
		RayCast detects 2, RayCastLong detects 2
	Loading Zones: 7, 8
	ExitDetector on 7
	PushBlock, IceBlock: 1, 2
		RayCast detects 2
	so Button should be on layer 1
	
	PortalGreen on layer 3
	PortalDetector (raycast on player) detects 3
	
	PortalRed on layer 2 (should be solid)
	
	---
	
	Ghost shouldn't interact with player
	so
	Tiles: 1, 2, 9, 10
	Doors: 1, 2, 9, 10
	PushBlock, IceBlock: 1, 2, 9, 10
		RayCast detects 2, 10
	Button: 1, 9
	Ghost: 9, 10
		RayCast detects 10, RayCastLong detects 10
	PortalRed: 10

	---
	
	Fires:
		Stops PushBlock, Player, Ghost
		Allows (and then destroys) IceBlock
	so
	Body: 4
	PushBlock, Player, Ghost raycast detect 4
	IceBlock has fire detector that detects 4, and despawns at end of beat if detecting
	
"""

var tile_size = 16
var anim_speed = 0.08

var saved_level = "res://Maps/Levels/Level1.tscn"
#var saved_level = "res://Maps/Levels/Level2.tscn"
#var saved_level = "res://Maps/Levels/Level3.tscn"
#var saved_level = "res://Maps/Levels/Level4.tscn"
#var saved_level = "res://Maps/Test/TestMap1.tscn"
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
	#saved_level = "res://Maps/Test/TestMap1.tscn"
	saved_level = "res://Maps/Levels/Level1.tscn"
	#saved_level = "res://Maps/Levels/Level3.tscn"
	#saved_level = "res://Maps/Levels/Level4.tscn"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
