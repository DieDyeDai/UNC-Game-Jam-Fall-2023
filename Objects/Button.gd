extends Area2D

@onready var wire = $Wire
@onready var animationPlayer = $AnimationPlayer

@export var connected_object_path: String
var connected_object

@export var TurnOnWhenPressed : bool = true

var button_pressed = false

signal set_state (on : bool) # tell connected object if button is on or off

# Called when the node enters the scene tree for the first time.
func _ready():
	
	connected_object = get_parent().get_parent().get_node(connected_object_path)
	
	self.connect("set_state", connected_object.on_set_state)
	
	if TurnOnWhenPressed:
		animationPlayer.play("OFF")
	else:
		animationPlayer.play("ON")
	
	wire.show()
	
	pass # Replace with function body.

func process_interactions(body):
	pass

func on_done_processing():
	if get_overlapping_bodies() or get_overlapping_areas(): # button is pressed
		print("pressed")
		if TurnOnWhenPressed:
			button_pressed = true
			self.emit_signal("set_state", true)
			animationPlayer.play("ON")
		else:
			button_pressed = false
			self.emit_signal("set_state", false)
			animationPlayer.play("OFF")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if (button_pressed == TurnOnWhenPressed):
		if SignalManager.seconds_decimal < 0.5:
			wire.default_color = Color("0FFFFF")
		else:
			wire.default_color = Color("fbf236")
	else:
		wire.default_color = Color("668080")
