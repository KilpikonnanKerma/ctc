extends Node2D

@onready var player = %Player
@onready var anim_player = %Player/AnimationPlayer
@onready var camera = %Player/Camera

@onready var ballsack = $"../Tutorial_text"
@onready var pp = $"../Tutorial_text_console"

var paused = false

var tutorial_completed = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if !tutorial_completed:
		if (event == InputEventKey):
			ballsack.show()
			pp.hide()
		elif (event == InputEventJoypadButton || event == InputEventJoypadMotion):
			ballsack.hide()
			pp.show()
		else:
			ballsack.show()
			pp.hide()


func _on_camera_change_entered(area: Area2D):
	if (area.is_in_group("Player") && !area.is_in_group("Enemy")):
		if (player.last_input == "left"):
			_change_limits(-525)
		elif (player.last_input == "right"):
			_change_limits(425)

func _change_limits(bottom: int):
	var tween = get_tree().create_tween()

	tween.tween_property(camera, "limit_bottom", bottom, 2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
