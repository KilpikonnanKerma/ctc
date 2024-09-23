extends Control

@onready var main = $"../../.."

func _on_StartButton_pressed():
	main.pauseMenu()

func _on_SettingsButton_pressed():
	pass

func _on_Exit_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
