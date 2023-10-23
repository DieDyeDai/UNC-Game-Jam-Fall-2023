extends Node

signal level_changed

signal pushed(body: Object, direction: Vector2)

signal process_interactions_signal(body: Object)
signal done_processing

@onready var exits = $Exits.get_children()
@onready var player = $Player
#@export var entrances : Dictionary = {"0" = Vector2(0,0)}

@export var spawn_positions : Dictionary = {}

@export var zoom = 2.0

var scene_has_player : bool = false

var ghost_stored_location : Vector2 = Vector2.ZERO
var ghost_stored_direction : Vector2 = Vector2.ZERO

func _ready():
	for i in exits:
		i.connect("loading_zone_entered", self.emit_level_changed_signal)
		print("connected a loading zone")
		spawn_positions.merge({i.get_name() : i.spawn_position})
	
	#await player.ready
	if has_node("Player"):
		scene_has_player = true
		
		player.connect("input_made", self.process_interactions)
		self.connect("done_processing", player.on_done_processing)
		
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
				self.connect("done_processing", i.on_done_processing)
#				if self.is_connected("process_interactions_signal", i.process_interactions):
#					print("process_interactions_signal connected")
#				else:
#					print("process_interactions_signal not connected")
				
				if i.is_in_group("Pushable"):
				
					player.connect("check_push", i.on_check_push)
#					if player.is_connected("check_push", i.on_check_push):
#						print("check_push connected")
#					else:
#						print("check_push not connected")
						
					i.connect("checked_push_direction", player.on_checked_push_direction)
#					if i.is_connected("checked_push_direction", player.on_checked_push_direction):
#						print("push connected")
#					else:
#						print("push not connected")
					
					player.connect("push_confirmed", i.on_push_confirmed)
#					if player.is_connected("push_confirmed", i.on_push_confirmed):
#						print("push_confirmed connected")
#					else:
#						print("push_confirmed not connected")
		
		if has_node("PortalGreens") and has_node("PortalReds"):
			for i in get_node("PortalGreens").get_children():
				player.connect("entered_portalgreen", i.on_entered_portalgreen)
#				if player.is_connected("entered_portalgreen", i.on_entered_portalgreen):
#					print("entered_portalgreen connected")
#				else:
#					print("entered_portalgreen not connected")
			for i in get_node("PortalReds").get_children():
				i.connect("create_ghost", self.create_ghost)
#				if i.is_connected("create_ghost", self.create_ghost):
#					print("create_ghost connected")
#				else:
#					print("create_ghost not connected")
		
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
#	print("push")
#	if self.is_connected("pushed", pushed_body.when_pushed):
#		print("should be connected")
	emit_signal("pushed", pushed_body, direction)

func create_ghost(location: Vector2, direction: Vector2):
	
	ghost_stored_location = location
	ghost_stored_direction = direction
		
	#print("create ghost at " + str(location) + " with direction " + str(direction))
	var ghost = load("res://Ghost.tscn").instantiate()
	get_node("Ghosts").add_child(ghost)
	ghost_stored_direction = direction

func on_ghost_ready(body: Object):
	move_child(body, 0)
	body.stored_direction = ghost_stored_direction
	body.position = ghost_stored_location
	body.animationPlayer.play(body.directions[ghost_stored_direction])
	self.connect("process_interactions_signal", body.process_interactions)
	self.connect("done_processing", body.on_done_processing)
#	if self.is_connected("process_interactions_signal", body.process_interactions):
#		print("process_interactions_signal connected")
#	else:
#		print("process_interactions_signal not connected")
	
	if has_node("Objects"):
		for i in get_node("Objects").get_children():
			if i.is_in_group("Pushable"):
				body.connect("check_push", i.on_check_push)
#				if body.is_connected("check_push", i.on_check_push):
#					print("check_push connected")
#				else:
#					print("check_push not connected")
					
				i.connect("checked_push_direction", body.on_checked_push_direction)
#				if i.is_connected("checked_push_direction", body.on_checked_push_direction):
#					print("push connected")
#				else:
#					print("push not connected")
				
				body.connect("push_confirmed", i.on_push_confirmed)
#				if body.is_connected("push_confirmed", i.on_push_confirmed):
#					print("push_confirmed connected")
#				else:
#					print("push_confirmed not connected")
	
	player.enabled = true

func process_interactions():
	await get_tree().create_timer(0.001).timeout
	#for i in get_node("Ghosts").get_children():
	#	emit_signal("process_interactions_signal", i)
	#	await get_tree().create_timer(0.001).timeout
	var ghost_parent = get_node("Ghosts")
	for i in range(len(ghost_parent.get_children()), -1, -1):
		emit_signal("process_interactions_signal", ghost_parent.get_child(i))
		await get_tree().create_timer(0.001).timeout
	
	await get_tree().create_timer(0.001).timeout
	for i in get_node("Objects").get_children():
		emit_signal("process_interactions_signal", i)
		#await get_tree().create_timer(0.001).timeout
	await get_tree().create_timer(0.001).timeout
	for i in get_node("Objects").get_children():
		#await get_tree().create_timer(0.01).timeout
		emit_signal("process_interactions_signal", i)
	#await get_tree().create_timer(0.03).timeout
	await get_tree().create_timer(0.001).timeout
	emit_signal("done_processing")


func cleanup(): #called instead of queue_free()
	queue_free()

func emit_level_changed_signal(orig_area, orig_scene, target_area, target_scene, exit_id, target_exit_id):
	#print("level changed emitted")
	emit_signal("level_changed", orig_area, orig_scene, target_area, target_scene, exit_id, target_exit_id)

func _unhandled_input(event):
	if event.is_action_pressed("reset"):
		get_node("Exits").get_node("RESET").global_position = player.global_position
#	elif Input.is_action_just_pressed("wait"):
#		print("---pass---")
#		process_interactions()
