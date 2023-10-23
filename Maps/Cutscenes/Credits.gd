extends Control

signal level_changed

signal next_cutscene

@export var zoom = 2.0

@onready var spacePrompt = $SpacePrompt

@onready var Text = $TextEdit

@onready var outro1 = $Outro1
@onready var outro2 = $Outro2
@onready var outro3 = $Outro3

# Called when the node enters the scene tree for the first time.
func _ready():
	play_intro() # Replace with function body.
	
func play_intro():
	
	spacePrompt.set_visible(false)
	
	await get_tree().create_timer(0.5).timeout
	
	var tween = get_tree().create_tween()
	tween.tween_property(outro1, "modulate:a", 1, 1.0)
	
	await tween.finished
	
	spacePrompt.set_visible(true)
	
	await next_cutscene
	
	spacePrompt.set_visible(false)
	
	#print("next")
	
	tween = get_tree().create_tween()
	tween.tween_property(outro1, "modulate:a", 0, 1.0)
	await tween.finished
	#print("next_again")
	tween = get_tree().create_tween()
	tween.tween_property(outro2, "modulate:a", 1, 1.0)
	
	await tween.finished
	
	spacePrompt.set_visible(true)
	
	await next_cutscene
	
	spacePrompt.set_visible(false)
	
	#print("next")
	
	tween = get_tree().create_tween()
	tween.tween_property(outro2, "modulate:a", 0, 1.0)
	await tween.finished
	
	tween = get_tree().create_tween()
	tween.tween_property(outro3, "modulate:a", 1, 1.0)
	
	await get_tree().create_timer(0.5).timeout
	tween = get_tree().create_tween()
	tween.tween_property(Text, "modulate:a", 1, 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("next_cutscene"):
		#print("next cutscene")
		next_cutscene.emit()

func cleanup(): #called instead of queue_free()
	queue_free()
