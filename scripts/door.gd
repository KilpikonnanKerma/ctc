extends Node2D

@onready var block = $Block/CollisionShape2D
@onready var text = $Block/key_text

func _ready() -> void:
	text.hide()

func _on_door_opened(area: Area2D):
	if !area.is_in_group("Enemy"):
		block.disabled = true
		text.hide()

func _on_door_entered(area: Area2D):
	if !area.is_in_group("Enemy"):
		text.show()

func _on_door_exited(area: Area2D):
	if !area.is_in_group("Enemy"):
		text.hide()
