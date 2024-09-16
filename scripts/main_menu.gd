extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_StartButton_pressed():
	get_tree().change_scene_to_file("res://scenes/scene_1.tscn")

func _on_SettingsButton_pressed():
	pass

func _on_Exit_pressed():
	get_tree().quit()
