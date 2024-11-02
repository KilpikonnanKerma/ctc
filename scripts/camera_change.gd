extends Area2D

@export var player: CharacterBody2D
@export var camera: Camera2D


@export var start_left: int
@export var start_right: int
@export var start_top: int
@export var start_bottom: int

@export var end_left: int
@export var end_right: int
@export var end_top: int
@export var end_bottom: int

func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass

func _on_change_cam(area: Area2D):
	if (area.is_in_group("Player") && !area.is_in_group("Enemy")):
		if (player.last_input == "left"):
			_change_limits(end_left, end_right, end_top, end_bottom)
		if (player.last_input == "right"):
			_change_limits(start_left, start_right, start_top, start_bottom)

func _change_limits(left:int, right: int, top: int, bottom: int):
	var tween = get_tree().create_tween()

	if (left != 0):
		tween.tween_property(camera, "limit_left", left, 2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	if (bottom != 0):
		tween.tween_property(camera, "limit_bottom", bottom, 2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	if (right != 0):
		tween.tween_property(camera, "limit_right", right, 2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	if (top != 0):
		tween.tween_property(camera, "limit_top", top, 2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
