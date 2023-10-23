extends Control

signal level_changed

signal next_cutscene

@export var zoom = 2.0

@onready var spacePrompt = $SpacePrompt

@onready var intro1 = $Intro1
@onready var intro2 = $Intro2
@onready var intro3 = $Intro3
@onready var intro4 = $Intro4
@onready var intro5 = $Intro5
@onready var intro5_2 = $Intro5_2
@onready var intro5_3 = $Intro5_3

var next : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	play_intro()

func play_intro():
	
	spacePrompt.set_visible(false)
	
	var tween = get_tree().create_tween()
	tween.tween_property(intro1, "modulate:a", 1, 0.5)
	
	await tween.finished
	
	spacePrompt.set_visible(true)
	
	await next_cutscene
	
	spacePrompt.set_visible(false)
	
	#print("next")
	
	tween = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	tween.tween_property(intro1, "modulate:a", 0, 0.2)
	#print("next_again")
	tween2.tween_property(intro2, "modulate:a", 1, 0.2)
	
	await tween2.finished
	
	spacePrompt.set_visible(true)
	
	await next_cutscene
	
	spacePrompt.set_visible(false)
	#print("next")
	
	tween = get_tree().create_tween()
	tween.tween_property(intro2, "modulate:a", 0, 0.2)
	await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property(intro3, "modulate:a", 1, 0.2)
	
	await tween.finished
	
	spacePrompt.set_visible(true)
	
	await next_cutscene
	
	spacePrompt.set_visible(false)
	
	tween = get_tree().create_tween()
	tween.tween_property(intro3, "modulate:a", 0, 0.2)
	await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property(intro4, "modulate:a", 1, 0.2)
	await tween.finished
	
	spacePrompt.set_visible(true)
	
	await next_cutscene
	
	spacePrompt.set_visible(false)
	
	tween = get_tree().create_tween()
	tween.tween_property(intro4, "modulate:a", 0, 1.0)
	await tween.finished
	await get_tree().create_timer(1.0).timeout
	
	tween = get_tree().create_tween()
	tween.tween_property(intro5, "modulate:a", 1, 0.4)
	await tween.finished
	
	await get_tree().create_timer(0.8).timeout
	
	tween = get_tree().create_tween()
	tween2 = get_tree().create_tween()
	tween.tween_property(intro5, "modulate:a", 0, 0.4)
	tween2.tween_property(intro5_2, "modulate:a", 1, 0.4)
	await tween.finished
	
	await get_tree().create_timer(0.8).timeout
	
	tween = get_tree().create_tween()
	tween2 = get_tree().create_tween()
	tween.tween_property(intro5_2, "modulate:a", 0, 0.4)
	tween2.tween_property(intro5_3, "modulate:a", 1, 1.0)
	await tween.finished
	
	await get_tree().create_timer(0.8).timeout
	
	tween = get_tree().create_tween()
	tween.tween_property(intro5_3, "modulate:a", 0, 0.4)
	
	await tween.finished
	
	await get_tree().create_timer(0.4).timeout
	
	spacePrompt.set_visible(true)
	
	await next_cutscene
	
	spacePrompt.set_visible(false)
	
	emit_signal("level_changed", "Cutscenes", "Intro", "Levels", "Level1", "default", "default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("next_cutscene"):
		#print("next cutscene")
		next_cutscene.emit()

func cleanup(): #called instead of queue_free()
	queue_free()
