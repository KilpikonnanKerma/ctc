extends Node2D

@onready var anim_player = $AnimatableBody2D/AnimationPlayer
@export var area: Area2D

signal door_opened
signal door_entered
signal door_exited

var key_taken = false
var in_door_zone = false

func _ready() -> void:
	anim_player.play("key")

func _process(_delta: float) -> void:
	if key_taken && in_door_zone:
		emit_signal("door_opened", area)
	elif !key_taken && in_door_zone:
		emit_signal("door_entered", area)

	if !in_door_zone:
		emit_signal("door_exited", area)

func _on_door_zone_entered(_area: Area2D):
	in_door_zone = true

func _on_door_zone_exited(_area: Area2D):
	in_door_zone = false

func _on_key_area_entered(_area: Area2D):
	if !key_taken:
		key_taken = true
		$AnimatableBody2D/Sprite2D.queue_free()
