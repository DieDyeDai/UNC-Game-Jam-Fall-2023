extends Node

signal level_changed

signal pushed(body: Object, direction: Vector2)

signal process_interactions_signal(body: Object)

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
		
		player.connect("input_made", self.process_interactions)
		
		if spawn_positions.has(Flags.target_exit_id):
			#player.global_position = entrances.get(Flags.exit_id)
			player.global_position = spawn_positions.get(Flags.target_exit_id)
			print(spawn_positions)
			print(spawn_positions.get(Flags.target_exit_id))
		elif spawn_positions.has("default"):
			player.global_position = spawn_positions.get("default")
		else:
			print("using zero spawn pos")
			player.global_position = Vector2.ZERO
			
		if has_node("Objects"):
			for i in get_node("Objects").get_children():
				self.connect("process_interactions_signal", i.process_interactions)
				if self.is_connected("process_interactions_signal", i.process_interactions):
					print("process_interactions_signal connected")
				else:
					print("process_interactions_signal not connected")
				
				if i.is_in_group("Pushable"):
				
					player.connect("check_push", i.on_check_push)
					if player.is_connected("check_push", i.on_check_push):
						print("check_push connected")
					else:
						print("check_push not connected")
						
					i.connect("checked_push_direction", player.on_checked_push_direction)
					if i.is_connected("checked_push_direction", player.on_checked_push_direction):
						print("push connected")
					else:
						print("push not connected")
					
					player.connect("push_confirmed", i.on_push_confirmed)
					if player.is_connected("push_confirmed", i.on_push_confirmed):
						print("push_confirmed connected")
					else:
						print("push_confirmed not connected")
			
	else:
		scene_has_player = false
	"""
	if has_node("Objects") && get_node("Objects").has_node("Pushables"):
		for i in get_node("Objects").get_node("Pushables").get_children():
			self.connect("pushed", i.when_pushed)
			#player.connect("pushed", i.when_pushed)
			#i.connect("checked_push_direction", player.on_push_check)
			if self.is_connected("pushed", i.when_pushed):
				print("pushed connected")
	"""
func push_object(pushed_body, direction: Vector2):
	print("push")
	if self.is_connected("pushed", pushed_body.when_pushed):
		print("should be connected")
	emit_signal("pushed", pushed_body, direction)

func process_interactions():
	for i in get_node("Objects").get_children():
		emit_signal("process_interactions_signal", i)

func cleanup(): #called instead of queue_free()
	queue_free()

func emit_level_changed_signal(orig_area, orig_scene, target_area, target_scene, exit_id, target_exit_id):
	print("level changed emitted")
	emit_signal("level_changed", orig_area, orig_scene, target_area, target_scene, exit_id, target_exit_id)

func _unhandled_input(event):
	if event.is_action_pressed("reset"):
		get_node("Exits").get_node("RESET").global_position = player.global_position
