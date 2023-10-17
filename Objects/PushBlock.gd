class_name PushBlock
extends Area2D

signal checked_push_direction (body: Object, direction: Vector2, can_be_pushed: bool)

#var direction = "still"

@onready var rayCast2D = $RayCast2D
@onready var collisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Pushable")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_check_push(body, direction):
	if self == body:
		print("checking push direction: " + str(check_movement(direction)))
		emit_signal("checked_push_direction", body, direction, check_movement(direction))

func on_push_confirmed(body, direction):
	if self == body:
		print("push confirmed, " + str(direction))
		move(direction)

func move(dir):
	var tween = get_tree().create_tween()
	var tweenCollision = get_tree().create_tween()
	tween.tween_property(self, "position", position + dir, Flags.anim_speed).set_trans(Tween.TRANS_LINEAR)
	tweenCollision.tween_property(collisionShape2D, "global_position", global_position+dir, Flags.anim_speed).from(global_position+dir)
	await tween.finished
	await tweenCollision.finished
	collisionShape2D.position = Vector2(8, 8)
	print("pushblock global position after move:" + str(collisionShape2D.global_position))
	
func check_movement(direction: Vector2) -> bool:
	rayCast2D.target_position = direction
	rayCast2D.force_raycast_update()
	return !rayCast2D.is_colliding()

func process_interactions(body):
	pass
