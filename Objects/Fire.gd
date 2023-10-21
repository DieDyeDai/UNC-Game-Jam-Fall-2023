class_name Fire
extends Area2D

@onready var animationPlayer = $AnimationPlayer
@onready var sprite2D = $Sprite2D
@onready var collisionShape2D = $CollisionShape2D
# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer.play("Fire")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func process_interactions(body):
	pass

func on_done_processing():
	pass

func despawn():
	collisionShape2D.disabled = true
	var tween = get_tree().create_tween()
	tween.tween_property(sprite2D, "modulate:a", 0, 0.2).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.2).timeout
	queue_free()
