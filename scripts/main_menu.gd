extends Control

@onready var settings = $Settings

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu_play"):
		_on_StartButton_pressed()
	if Input.is_action_just_pressed("menu_stngs"):
		_on_SettingsButton_pressed()
	if Input.is_action_just_pressed("menu_exit"):
		_on_Exit_pressed()

func _on_StartButton_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/opening_cutscene.tscn")

func _on_SettingsButton_pressed():
	settings.show()

func _on_Exit_pressed():
	get_tree().quit()

func _on_exit_to_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
