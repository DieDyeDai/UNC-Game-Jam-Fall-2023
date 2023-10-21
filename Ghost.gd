class_name Ghost
extends Area2D

var stored_direction

signal check_push(pusher: Object, body: Object, direction: Vector2)
signal push_confirmed(pusher: Object, body: Object, direction: Vector2)

var inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

var directions = {
	Vector2.ZERO : "still",
	Vector2.RIGHT * Flags.tile_size : "right", 
	Vector2.LEFT * Flags.tile_size : "left",
	Vector2.UP * Flags.tile_size : "up",
	Vector2.DOWN * Flags.tile_size : "down"
}

signal _on_ready(body: Object)

@onready var sprite2D = $Sprite2D
@onready var ray = $RayCast2D
@onready var rayLong = $RayCast2DLong
@onready var collisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("_on_ready", get_parent().get_parent().on_ghost_ready) # Level.gd's on ghost ready method
	
	if self.is_connected("_on_ready", get_parent().get_parent().on_ghost_ready):
		print("_on_ready connected")
	else:
		print("_on_ready not connected")
	
	emit_signal("_on_ready", self)
	pass # Replace with function body.

func test_input(dir):
	#print("---")
	#print("0"+str(dir))
	#var stored_dir = dir
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
				despawn()
			else:
				print("rayLong not colliding")
				emit_signal("check_push", self, collision, inputs[dir] * Flags.tile_size)
				# once the return signal is received, it runs on_checked_push_direction
				# that method will move it and the object
		else:
			despawn()
	else:
		move_direct(inputs[dir] * Flags.tile_size)

func on_checked_push_direction(pusher, body, direction, can_be_pushed):
	if self == pusher:
		if can_be_pushed:
			emit_signal("push_confirmed", body, direction)
			move_direct(direction)
		else:
			despawn()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func move_direct(dir : Vector2):
	
	position += dir
	
	stored_direction = dir
	
	var tween = get_tree().create_tween()
	tween.tween_property(sprite2D, "position", Vector2(8,8), Flags.anim_speed).from(Vector2(8,8) + dir * -1)
	
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "position", position + dir, Flags.anim_speed).set_trans(Tween.TRANS_SINE)
	#var tweenCollision = get_tree().create_tween()
	#collisionShape2D.global_position = global_position + dir
	#tweenCollision.tween_property(collisionShape2D, "global_position", self.global_position+dir+Vector2(8,8), Flags.anim_speed).from(self.global_position+dir+Vector2(8,8))
#	emit_signal("input_made")
#	moving = true
#	await tween.finished
#	moving = false

func process_interactions(body):
	if self == body:
		print("ghost testing input in " + str(stored_direction))
		print(str(directions[stored_direction]))
		
		test_input(directions[stored_direction])

func on_done_processing():
	pass

func despawn():
	collisionShape2D.disabled = true
	ray.enabled = false
	rayLong.enabled = false
	var tween = get_tree().create_tween()
	tween.tween_property(sprite2D, "modulate:a", 0, 0.2).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.2).timeout
	queue_free()
