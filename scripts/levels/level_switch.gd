extends Area2D

@export var level_path: String
@export var pc_text: RichTextLabel
@export var controller_text: RichTextLabel

@export var player: CharacterBody2D
@export var main: Node2D

@export var player_start_position_y: int
@export var player_end_position_y: int
@export var is_return: bool

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
	if (!is_return):
		player.position.y = player_end_position_y
	elif (is_return):
		player.position.y = player_start_position_y
	main.aggro = false

func _you(area: Area2D):
	if (not area.is_in_group("Enemy") && area.is_in_group("Player")):
		player.is_on_level_switch_area = true

func _exit(area: Area2D):
	if (not area.is_in_group("Enemy") && area.is_in_group("Player")):
		player.is_on_level_switch_area = false
		pc_text.hide()
		controller_text.hide()
