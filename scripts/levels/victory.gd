extends Area2D

@export var win_screen: Control
@export var player: CharacterBody2D

var has_won = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if has_won:
		player.stop_movement()
		Engine.time_scale = 0

func _on_win_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Player") && not area.is_in_group("Enemy")):
		win()
		has_won = true

func win():
	win_screen.show()
