extends Node2D

@onready var block = $Block/CollisionShape2D

func _ready() -> void:
	pass 

func _on_door_opened(area: Area2D):
	if !area.is_in_group("Enemy"):
		block.disabled = true
