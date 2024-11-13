extends Node2D

@onready var block = $Block/CollisionShape2D
@onready var text = $Block/key_text
@onready var lock = $lock

func _ready() -> void:
	text.hide()

func _on_door_opened(area: Area2D):
	if !area.is_in_group("Enemy"): #&& area.is_in_group("Player"):
		block.disabled = true
		text.hide()
		lock.hide()

func _on_door_entered(area: Area2D):
	if !area.is_in_group("Enemy") && block.disabled == false: #&& area.is_in_group("Player"):
		text.show()

func _on_door_exited(area: Area2D):
	if !area.is_in_group("Enemy"): #&& area.is_in_group("Player"):
		text.hide()
