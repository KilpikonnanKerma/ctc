extends StaticBody2D

@onready var animation_player = $AnimationPlayer2

func _ready() -> void:
	animation_player.play("move")
