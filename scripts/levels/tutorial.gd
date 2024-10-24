extends Node2D

@onready var pause_menu = $"Player/Camera/CanvasLayer/PauseMenu"
@onready var player = %Player

@onready var settings = $"Player/Camera/CanvasLayer/Settings"

@onready var pc_tutorial = $Tutorial_text
@onready var console_tutorial = $Tutorial_text_console

var paused = false

func _ready() -> void:
	player.animPlayer.play("camera_zoom_out")
	pause_menu.hide()
	paused = false
	Engine.time_scale = 1

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("pause")):
		pauseMenu()

func pauseMenu():
	if (paused):
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
		#pause_menu.position.x = player.position.x

	paused = !paused

func _input(event: InputEvent) -> void:
	if (event == InputEventKey):
		pc_tutorial.hide()
		console_tutorial.show()
	elif (event == InputEventJoypadButton || event == InputEventJoypadMotion):
		pc_tutorial.show()
		console_tutorial.hide()
	else:
		pc_tutorial.show()
		console_tutorial.hide()
