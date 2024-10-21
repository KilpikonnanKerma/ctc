extends Control

@onready var main = $"../../../.."
@onready var settings = $"."

@onready var fullscreen_button = $MarginContainer/VBoxContainer/HBoxContainer2/fullscreen

func _ready() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		fullscreen_button.button_pressed = true
	else:
		fullscreen_button.button_pressed = false

func _process(_delta: float) -> void:
	pass


func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	elif !toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_resolutions_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(960, 540))
		1:
			DisplayServer.window_set_size(Vector2i(1280, 720))
		2:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		3:
			DisplayServer.window_set_size(Vector2i(1920, 1080))

func _on_back_pressed():
	settings.hide()
