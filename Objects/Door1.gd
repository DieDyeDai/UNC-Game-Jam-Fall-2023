class_name Door1
extends Area2D

@export var orientation : String = "up"

@export var open_state = "closed"

@onready var animationPlayer = $AnimationPlayer
@onready var collisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if (open_state == "closed"):
		collisionShape2D.disabled = false
	
	animationPlayer.play(orientation + "_" + open_state)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animationPlayer.play(orientation + "_" + open_state)
	pass

func on_set_state(state): # state is true if button is turning on, off if button is turning off
	if state:
		open_state = "open"
		collisionShape2D.disabled = true
	else:
		open_state = "closed"
		collisionShape2D.disabled = false
	
	animationPlayer.play(orientation + "_" + open_state)
