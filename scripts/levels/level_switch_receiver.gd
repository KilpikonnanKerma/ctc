extends Area2D

@export var animPlayer: AnimationPlayer

var has_been_called = false

func _on_area_entered(area: Area2D) -> void:
	if (not has_been_called && not area.is_in_group("Enemy")):
		animPlayer.play("camera_zoom_out")
		has_been_called = true
