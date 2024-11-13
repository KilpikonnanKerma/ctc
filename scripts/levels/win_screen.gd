extends Control

@export var globals: Node
@export var baby_text: RichTextLabel

func _ready() -> void:
	baby_text.text = str(globals.babies_ate)

func _process(_delta: float) -> void:
	pass

func _on_continue_button_pressed() -> void:
	pass

func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
