class_name Player
extends Area2D

signal enable_input
signal disable_input

signal input_made

signal check_push(body: Object, direction: Vector2)
signal push_confirmed(body: Object, direction: Vector2)

var animation_speed = 10
var moving = false
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
@onready var rayLong = $RayCast2DLong

@onready var testCollision = $rayLongSprite2
@onready var movingDisplay = $MovingDisplay
#@onready var rayLongDisplay = $rayLongSprite

func _ready():
	add_to_group("Player")
	is_dead = false
	
	#for i in get_parent().get_node("Pushables").get_children():
	#	pass
	
	return

func _process(_delta):
	for dir in inputs.keys():
		if Input.is_action_pressed(dir):
			direction = dir
	movingDisplay.set_text(str(moving) + " " + str(enabled) + " " + direction)

func _unhandled_input(event):
	if moving or !enabled:
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			print(str(dir))
			test_input(dir)
			
func test_input(dir):
	print("---")
	print("0"+str(dir))
	var stored_dir = dir
	$AnimationPlayer.play(dir)
	ray.target_position = inputs[dir] * Flags.tile_size
	rayLong.global_position = self.global_position + (inputs[dir] * Flags.tile_size * 2) + Vector2(8, 8)
	rayLong.target_position = Vector2(0, 1)
	#rayLongDisplay.position = self.position + (inputs[dir] * Flags.tile_size * 2) + Vector2(8, 8)
	ray.force_raycast_update()
	if ray.is_colliding():
		var collision = ray.get_collider()
		print("ray colliding with " + collision.get_class())
		if collision.is_in_group("Pushable"):
			print("with pushable")
			rayLong.force_raycast_update()
			print("1" + str(dir))
			
			if rayLong.is_colliding():
				print("rayLong colliding")
			else:
				print("rayLong not colliding")
				emit_signal("check_push", collision, inputs[dir] * Flags.tile_size)
				# once the return signal is received, it runs on_checked_push_direction
				# that method will move it and the object
	else:
		move(dir)

func on_checked_push_direction(body, direction, can_be_pushed):
	if can_be_pushed:
		emit_signal("push_confirmed", body, direction)
		move_direct(direction)

func move(dir : String):
	emit_signal("input_made")
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + inputs[dir] * Flags.tile_size, Flags.anim_speed).set_trans(Tween.TRANS_LINEAR)
	var tweenCollision = get_tree().create_tween()
	tweenCollision.tween_property(testCollision, "global_position", self.global_position+inputs[dir]*Flags.tile_size, Flags.anim_speed).from(self.global_position+inputs[dir]*Flags.tile_size)
	moving = true
	await tween.finished
	moving = false
	

func move_direct(dir : Vector2):
	emit_signal("input_made")
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + dir, Flags.anim_speed).set_trans(Tween.TRANS_SINE)
	var tweenCollision = get_tree().create_tween()
	tweenCollision.tween_property(testCollision, "global_position", self.global_position+dir, Flags.anim_speed).from(self.global_position+dir)
	moving = true
	await tween.finished
	moving = false
	

func on_enable_input():
	enabled = true
	print("enabling input")

func on_disable_input():
	enabled = false
	print("disabling input")
