extends Node2D

@onready var baby = $AnimatedSprite2D

func _ready() -> void:
	pass

func _process(delta: float):
	baby.play("baby_idle")
