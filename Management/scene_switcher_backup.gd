extends Node

var starting_scene = load(Flags.saved_level).instantiate()

var current_scene
var next_scene

signal enable_input
signal enable_camera
signal disable_input
signal disable_camera

signal testsignal

var current_player : Player
var next_player : Player
#var next_scene_has_player
#var next_scene_has_orb
var orig_area : String
var orig_scene : String
var target_area : String
var target_scene : String
var exit_direction : String
var exit_id : String

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(starting_scene)
	current_scene = starting_scene
	
	current_scene.connect("level_changed", self.handle_level_changed)
	# start.level_changed.connect(self, handle_level_changed)
	if current_scene.has_node("Player"):
		current_player = current_scene.get_node("Player")
		connect_player_to_enable_disable_signals(current_player)
		current_player.enable_input.emit()
		current_player.enable_camera.emit()
		print("sending enable input and camera")
	
	animation_player.play("fade_in")

func handle_level_changed(orig_area, orig_scene, target_area, target_scene, exit_direction, exit_id):
	print("original:" + orig_area + "/" + orig_scene)
	print("target:" + target_area + "/" + target_scene)
	print("exit_id:" + exit_id)
	# var current_scene = get_child(0)
	self.orig_area = orig_area
	self.orig_scene = orig_scene
	self.target_area = target_area
	self.target_scene = target_scene
	self.exit_direction = exit_direction
	self.exit_id = exit_id
	next_scene = load("res://Maps/" + target_area + "/" + target_scene + ".tscn").instantiate()
	
	Flags.exit_id = exit_id
	Flags.exit_direction = exit_direction

	#if current_scene.has_node("Player"):
	#	current_player = current_scene.get_node("Player")
	current_player.disable_input.emit(exit_direction)
	print("sending disable input")

	next_scene.set_visible(false)
#	add_child(next_scene) moved to after fadeout
	
	animation_player.play("fade_out")
	
	next_scene.connect("level_changed", self.handle_level_changed)

	Flags.loading_zones_enabled = false


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"fade_out":
			
			add_child(next_scene)
			
			current_scene.cleanup()
			
			next_scene.set_visible(true)
			# next_scene = null
			current_scene = next_scene
			
			current_player.disable_camera.emit()
			print("sending disable camera")

			if current_scene.has_node("Player"):
				print("player detected")
				current_player = current_scene.get_node("Player")
				connect_player_to_enable_disable_signals(current_player)
				current_player.disable_input.emit(Flags.exit_direction)
				current_player.enable_camera.emit()
				print("sending disable input and enable camera")
			
			animation_player.play("fade_in")
		
		"delay": #black screen while loading new scene
			pass
			
		"fade_in": #first 0.4/0.5 seconds of fade in
			Flags.loading_zones_enabled = true
			animation_player.play("fade_in2")
			
			if current_scene.has_node("Player"):
				current_player.enable_input.emit()
			print("sending enable input")
		
	pass # Replace with function body.

func connect_player_to_enable_disable_signals(current_player : Player):
	current_player.connect("disable_input", current_player.on_disable_input)
	current_player.connect("disable_camera", current_player.on_disable_camera)
	current_player.connect("enable_input", current_player.on_enable_input)
	current_player.connect("enable_camera", current_player.on_enable_camera)
	if current_player.is_connected("disable_input", current_player.on_disable_input):
		print("connected disable input")
	if current_player.is_connected("disable_camera", current_player.on_disable_camera):
		print("connected disable camera")
	if current_player.is_connected("enable_input", current_player.on_enable_input):
		print("connected enable input")
	if current_player.is_connected("enable_camera", current_player.on_enable_camera):
		print("connected enable camera")

#func _physics_process(_delta):
#	if Input.is_action_just_pressed("jump"):
#		print("sent test signal")
#		current_player.connect("testsignal", current_player.on_test_signal)
#		if current_player.is_connected("testsignal", current_player.on_test_signal):
#			print("test signal is connected")
#		current_player.testsignal.emit()
		
		
