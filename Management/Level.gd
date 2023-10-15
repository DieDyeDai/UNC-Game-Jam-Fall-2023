extends Node

signal level_changed

@onready var exits = $Exits.get_children()
@onready var player = $Player
#@export var entrances : Dictionary = {"0" = Vector2(0,0)}

@export var spawn_positions : Dictionary = {}

@export var zoom = 2.5

var scene_has_player : bool = false

func _ready():
	for i in exits:
		i.connect("loading_zone_entered", self.emit_level_changed_signal)
		print("connected a loading zone")
		spawn_positions.merge({i.get_name() : i.spawn_position})
	
	#await player.ready
	if has_node("Player"):
		scene_has_player = true
		if spawn_positions.has(Flags.target_exit_id):
			#player.global_position = entrances.get(Flags.exit_id)
			player.global_position = spawn_positions.get(Flags.target_exit_id)
			print(spawn_positions)
			print(spawn_positions.get(Flags.target_exit_id))
		elif spawn_positions.has("default"):
			player.global_position = spawn_positions.get("default")
		else:
			player.global_position = Vector2.ZERO
	else:
		scene_has_player = false
	
	

func cleanup(): #called instead of queue_free()
	queue_free()

func emit_level_changed_signal(orig_area, orig_scene, target_area, target_scene, exit_id, target_exit_id):
	print("level changed emitted")
		
	emit_signal("level_changed", orig_area, orig_scene, target_area, target_scene, exit_id, target_exit_id)
