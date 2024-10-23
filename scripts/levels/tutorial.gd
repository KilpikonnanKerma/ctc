extends Node2D

@onready var pause_menu = $"Player/Camera/CanvasLayer/PauseMenu"
@onready var player = %Player

@onready var settings = $"Player/Camera/CanvasLayer/Settings"

@onready var txt1 = $Tutorial_text/PC_MOVEMENT
@onready var txt2 = $Tutorial_text/PC_MOVEMENT2
@onready var txt3 = $Tutorial_text/PC_MOVEMENT3

var paused = false

func _ready() -> void:
	player.animPlayer.play("camera_zoom_out")
	paused = false
	Engine.time_scale = 1

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
		#pause_menu.position.x = player.position.x

	paused = !paused
