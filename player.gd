class_name Player
extends Area2D

signal enable_input
signal disable_input

var animation_speed = 10
var moving = false
var tile_size = 16
var inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}
var direction = "still"

var enabled = false

var is_dead : bool = false

@onready var ray = $RayCast2d
@onready var movingDisplay = $MovingDisplay
func _ready():
	add_to_group("Player")
	is_dead = false
	return

func _process(_delta):
	movingDisplay.set_text(str(moving) + " " + str(enabled))

func _unhandled_input(event):
	if moving or !enabled:
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			print("h")
			move(dir)
			
func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		#position += inputs[dir] * tile_size
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
		moving = true
		$AnimationPlayer.play(dir)
		await tween.finished
		moving = false

func on_enable_input():
	enabled = true
	print("enabling input")

func on_disable_input():
	enabled = false
	print("disabling input")
