extends Node2D

@onready var animationPlayer = $AnimationPlayer
@export var connected_object_paths : Array[String]
var connected_objects : Array[Node]

signal send_to_portalred (direction: Vector2)

# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer.play("CrystalGreen")
	for i in connected_object_paths:
		connected_objects.append( get_parent().get_parent().get_node("PortalReds").get_node(i) )
	
	for i in connected_objects:
		self.connect("send_to_portalred", i.on_send_to_portalred)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_entered_portalgreen(body: Object, direction: Vector2):
	if self == body:
		emit_signal("send_to_portalred", direction)
		#print("send_to_portalred")
