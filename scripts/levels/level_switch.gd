extends Area2D

@export var level_path: String
@export var pc_text: RichTextLabel
@export var controller_text: RichTextLabel

@export var player: CharacterBody2D
@export var camera: Camera2D
@export var main: Node2D

@export var player_end_position_y: int

@export var also_change_camera: bool

@export var cam_left: int
@export var cam_bottom: int

@onready var animPlayer = %Player/AnimationPlayer

func _ready() -> void:
	player.is_on_level_switch_area = false


func _process(_delta: float) -> void:
	if (player.is_on_level_switch_area):
		if (main.is_using_controller):
			pc_text.hide()
			controller_text.show()
		elif(!main.is_using_controller):
			pc_text.show()
			controller_text.hide()

	if(player.is_on_level_switch_area && Input.is_action_just_pressed("hide")):
		#animPlayer.animation_finished.connect(Callable(self, "switch_level"))
		#animPlayer.play("camera_zoom_in")
		switch_level()

func switch_level():
	#get_tree().change_scene_to_file(level_path)
	player.position.y = player_end_position_y
	if (also_change_camera):
		_change_limits(cam_left, cam_bottom)
	main.aggro = false

func _you(area: Area2D):
	if (not area.is_in_group("Enemy") && area.is_in_group("Player")):
		player.is_on_level_switch_area = true

func _exit(area: Area2D):
	if (not area.is_in_group("Enemy") && area.is_in_group("Player")):
		player.is_on_level_switch_area = false
		pc_text.hide()
		controller_text.hide()

func _change_limits(left: int, bottom: int):
	var tween_left = get_tree().create_tween()
	var tween_bottom = get_tree().create_tween()

	tween_left.tween_property(camera, "limit_left", left, 2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween_bottom.tween_property(camera, "limit_bottom", bottom, 2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
