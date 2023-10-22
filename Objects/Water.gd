class_name Water
extends Area2D

@onready var animationPlayer = $AnimationPlayer
var rng = RandomNumberGenerator.new()
var played_this_second : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (SignalManager.seconds_decimal < 0.25) or (0.75 > SignalManager.seconds_decimal and SignalManager.seconds_decimal > 0.5):
		if !played_this_second:
			animationPlayer.play(str(rng.randi_range(0, 3)))
			played_this_second = true
	else:
		played_this_second = false
