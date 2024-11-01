extends Area2D

@export var level_path: String
@export var pc_text: RichTextLabel
@export var controller_text: RichTextLabel

@export var player: CharacterBody2D
@export var main: Node2D


@onready var animPlayer = %Player/AnimationPlayer

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if (player.is_on_level_switch_area):
		if (main.is_using_controller):
			pc_text.hide()
			controller_text.show()
		elif(!main.is_using_controller):
			pc_text.show()
			controller_text.hide()

	if(player.is_on_level_switch_area && Input.is_action_just_pressed("hide")):
		animPlayer.animation_finished.connect(Callable(self, "switch_level"))
		animPlayer.play("camera_zoom_in")

func switch_level(_anim: StringName):
	get_tree().change_scene_to_file(level_path)

func _you(area: Area2D):
	if (not area.is_in_group("Enemy")):
		player.is_on_level_switch_area = true

func _exit(area: Area2D):
	if (not area.is_in_group("Enemy")):
		player.is_on_level_switch_area = false
		pc_text.hide()
		controller_text.hide()
