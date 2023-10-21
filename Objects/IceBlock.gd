class_name IceBlock
extends Area2D

signal checked_push_direction (body: Object, direction: Vector2, can_be_pushed: bool)
signal melt()

@export var stored_direction : Vector2 = Vector2.ZERO

@onready var rayCast2D = $RayCast2D
@onready var fireDetector = $FireDetector

var directions = {
	Vector2.ZERO : "still",
	Vector2.RIGHT * Flags.tile_size : "right", 
	Vector2.LEFT * Flags.tile_size : "left",
	Vector2.UP * Flags.tile_size : "up",
	Vector2.DOWN * Flags.tile_size : "down"
}
var just_pushed = false
var already_processed = 1
# 0 if processed, 1 if hasn't attempted yet, 2 if failed first attempt

var pusher : Object

@onready var animationPlayer = $AnimationPlayer
@onready var collisionShape2D = $CollisionShape2D
@onready var sprite2D = $Sprite2D
@export var id = "IceBlock"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Pushable")
	add_to_group("Ice")
	animationPlayer.play("still")
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func process_interactions(body):
	if self == body and already_processed != 0:
		print(str(stored_direction))
		print(id + " iceblock processing")
		print(id + " iceblock_stored_direction: " + str(stored_direction))
		if just_pushed:
			just_pushed = false
			print(id + " not sliding, just pushed")
			pass
		else:
			# just_pushed = false
			if check_movement(stored_direction):
				print(id + " sliding in " + str(stored_direction))
				move(stored_direction)
				#already_processed = 0
			elif already_processed == 1:
				print(id + " first pass failed")
				print(id + " stored dir is: " + str(stored_direction))
				already_processed = 2
			else:
				print(id + " stopped sliding")
				stored_direction = Vector2.ZERO
	
	animationPlayer.play(directions[stored_direction])
	


				

func on_check_push(pusher, body, direction):
	if self == body:
		self.pusher = pusher
		print("checking push direction: " + str(check_movement(direction)))
		emit_signal("checked_push_direction", pusher, body, direction, check_movement(direction))

func on_push_confirmed(body, direction):
	if self == body:
		print("push confirmed, " + str(direction))
		move(direction)
		stored_direction = direction
		#just_pushed = true
		

func move(dir):
	already_processed = 0
	#just_pushed = false
	print (id + " iceblock moving in " + str(dir))
	#var tween = get_tree().create_tween()
	#var tweenCollision = get_tree().create_tween()
	#tween.tween_property(self, "position", position + dir, Flags.anim_speed).set_trans(Tween.TRANS_LINEAR)
	#tweenCollision.tween_property(collisionShape2D, "global_position", global_position+dir+Vector2(8,8), Flags.anim_speed).from(global_position+dir+Vector2(8,8))
	position += dir
	var tween = get_tree().create_tween()
	tween.tween_property(sprite2D, "position", Vector2(8,8), Flags.anim_speed).from(Vector2(8,8) + dir * -1)
	
	await tween.finished
	#await tweenCollision.finished
	collisionShape2D.position = Vector2(8, 8)
	
	
func check_movement(direction: Vector2) -> bool:
	rayCast2D.target_position = direction
	rayCast2D.force_raycast_update()
	return !rayCast2D.is_colliding()

func on_done_processing():
	fireDetector.force_raycast_update()
	if fireDetector.is_colliding():
		var fire = fireDetector.get_collider()
		self.connect("melt", fire.despawn)
		emit_signal("melt")
		despawn()
	already_processed = 1

func despawn():
	collisionShape2D.disabled = true
	rayCast2D.enabled = false
	var tween = get_tree().create_tween()
	tween.tween_property(sprite2D, "modulate:a", 0, 0.2).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.2).timeout
	queue_free()
