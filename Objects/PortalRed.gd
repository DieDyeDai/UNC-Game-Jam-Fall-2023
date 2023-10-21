extends Node2D

@onready var animationPlayer = $AnimationPlayer
#@export var connected_object_path : String
#var connected_object

signal create_ghost(location: Vector2, direction: Vector2)

# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer.play("CrystalRed")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_send_to_portalred(body, direction):
	if self == body:
		# send signal to level to instantiate a ghost moving in direction 
		emit_signal("create_ghost", position, direction)
		print("create_ghost")
		pass
