extends Node2D

@onready var animationPlayer = $AnimationPlayer
@export var connected_object_path : String
var connected_object

signal send_to_portalred (body: Object, direction: Vector2)

# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer.play("CrystalGreen")
	connected_object = get_parent().get_parent().get_node("PortalReds").get_node(connected_object_path)
	
	self.connect("send_to_portalred", connected_object.on_send_to_portalred)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_entered_portalgreen(body: Object, direction: Vector2):
	if self == body:
		emit_signal("send_to_portalred", connected_object, direction)
		print("send_to_portalred")
