class_name Player
extends Area2D

signal enable_input
signal disable_input

signal input_made

signal check_push(pusher: Object, body: Object, direction: Vector2)
signal push_confirmed(pusher: Object, body: Object, direction: Vector2)

signal entered_portalgreen(body: Object, direction: Vector2)

var animation_speed = 10
var moving = false
var inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}
var direction = "still"

var stored_direction = Vector2.ZERO

var enabled = false

var is_dead : bool = false

@onready var ray = $RayCast2D
@onready var rayLong = $RayCast2DLong

@onready var sprite2D = $Sprite2D
@onready var testCollision = $rayLongSprite2
@onready var collisionShape2D = $CollisionShape2D
@onready var movingDisplay = $MovingDisplay

@onready var exitDetector = $ExitDetector
@onready var portalDetector = $PortalDetector
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
				emit_signal("check_push", self, collision, inputs[dir] * Flags.tile_size)
				# once the return signal is received, it runs on_checked_push_direction
				# that method will move it and the object
	else:
		move(dir)

func on_checked_push_direction(pusher, body, direction, can_be_pushed):
	if can_be_pushed and self == pusher:
		emit_signal("push_confirmed", body, direction)
		move_direct(direction)

func move(dir : String):
	enabled = false
	
	position += inputs[dir] * Flags.tile_size
	
	stored_direction = inputs[dir] * Flags.tile_size
	
	var entering_portal = 1.0 # false
	exitDetector.force_raycast_update()
	if exitDetector.is_colliding():
		entering_portal = 5.0
	print(entering_portal)
	var tween = get_tree().create_tween()
	tween.tween_property(sprite2D, "position", Vector2(8,8), Flags.anim_speed * entering_portal).from(Vector2(8,8) + inputs[dir] * Flags.tile_size * -1)
	#position += inputs[dir] * Flags.tile_size
	#var tweenCollision = get_tree().create_tween()
	#collisionShape2D.global_position = global_position + inputs[dir]*Flags.tile_size
	#tweenCollision.tween_property(collisionShape2D, "global_position", self.global_position+inputs[dir]*Flags.tile_size+Vector2(8,8), Flags.anim_speed).from(self.global_position+inputs[dir]*Flags.tile_size+Vector2(8,8))
	emit_signal("input_made")
	moving = true
	print(entering_portal)
	await tween.finished
	moving = false
	

func move_direct(dir : Vector2):
	enabled = false
	
	position += dir
	
	stored_direction = dir
	
	var entering_portal = 1.0 # false
	exitDetector.force_raycast_update()
	if exitDetector.is_colliding():
		entering_portal = 5.0
	print(entering_portal)
	var tween = get_tree().create_tween()
	tween.tween_property(sprite2D, "position", Vector2(8,8), Flags.anim_speed * entering_portal).from(Vector2(8,8) + dir * -1)
	
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "position", position + dir, Flags.anim_speed).set_trans(Tween.TRANS_SINE)
	#var tweenCollision = get_tree().create_tween()
	#collisionShape2D.global_position = global_position + dir
	#tweenCollision.tween_property(collisionShape2D, "global_position", self.global_position+dir+Vector2(8,8), Flags.anim_speed).from(self.global_position+dir+Vector2(8,8))
	emit_signal("input_made")
	moving = true
	await tween.finished
	moving = false
	

func on_enable_input():
	enabled = true
	print("enabling input")

func on_disable_input():
	enabled = false
	print("disabling input")
	
func on_done_processing():
	portalDetector.force_raycast_update()
	if portalDetector.is_colliding():
		# is colliding with a green crystal
		emit_signal("entered_portalgreen", portalDetector.get_collider(), stored_direction)
		print("entered_portalgreen")
	
	enabled = true
