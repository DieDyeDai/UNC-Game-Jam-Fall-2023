class_name LoadingZone
extends Area2D

signal loading_zone_entered

@export var orig_area : String
@export var orig_scene : String
@export var target_area : String
@export var target_scene : String
@export var exit_id : String
@export var target_exit_id : String

#@export var spawn_position : Vector2

@onready var spawn_position : Vector2 = $SpawnPosition.global_position

func _on_area_entered(area):
	if Flags.loading_zones_enabled:
		print("loading zone entered")
		emit_signal("loading_zone_entered",
			orig_area,
			orig_scene,
			target_area,
			target_scene,
			exit_id,
			target_exit_id)
