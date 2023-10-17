class_name IceBlock
extends Area2D

signal checked_push_direction (body: Object, direction: Vector2, can_be_pushed: bool)

var stored_direction : Vector2 = Vector2.ZERO

@onready var rayCast2D = $RayCast2D

var inputs = {
	"still": Vector2.ZERO,
	"right": Vector2.RIGHT * Flags.tile_size,
	"left": Vector2.LEFT * Flags.tile_size,
	"up": Vector2.UP * Flags.tile_size,
	"down": Vector2.DOWN * Flags.tile_size
}
var just_pushed = false

@onready var animationPlayer = $AnimationPlayer
@onready var collisionShape2D = $CollisionShape2D
@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Pushable")
	animationPlayer.play("Stop")
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func process_interactions(body):
	if self != body:
		pass
	print(str(stored_direction))
	print("iceblock processing")
	print("iceblock_stored_direction: " + str(stored_direction))
	if just_pushed:
		just_pushed = false
		print("not sliding, just pushed")
		pass
	else:
		just_pushed = false
		if check_movement(stored_direction):
			print("sliding in " + str(stored_direction))
			move(stored_direction)
		else:
			print("stopped sliding")
			stored_direction = Vector2.ZERO

func on_check_push(body, direction):
	if self == body:
		print("checking push direction: " + str(check_movement(direction)))
		emit_signal("checked_push_direction", body, direction, check_movement(direction))

func on_push_confirmed(body, direction):
	if self == body:
		print("push confirmed, " + str(direction))
		move(direction)
		stored_direction = direction
		just_pushed = true
		

func move(dir):
	var tween = get_tree().create_tween()
	var tweenCollision = get_tree().create_tween()
	tween.tween_property(self, "position", position + dir, Flags.anim_speed).set_trans(Tween.TRANS_LINEAR)
	tweenCollision.tween_property(collisionShape2D, "global_position", global_position+dir, Flags.anim_speed).from(global_position+dir)
	
	await tween.finished
	await tweenCollision.finished
	collisionShape2D.position = Vector2(8, 8)
	
	
func check_movement(direction: Vector2) -> bool:
	rayCast2D.target_position = direction
	rayCast2D.force_raycast_update()
	return !rayCast2D.is_colliding()



