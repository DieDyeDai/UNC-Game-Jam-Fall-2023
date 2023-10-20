extends Node2D

@onready var animationPlayer = $AnimationPlayer
@export var connected_object_path : String
var connected_object
# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer.play("CrystalRed")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
