class_name IceBlock
extends Area2D

var direction = "still"


@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer.play("Stop")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
