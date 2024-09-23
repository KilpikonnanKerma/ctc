extends Node2D

@onready var pause_menu = $"PauseMenu"
@onready var player = $"Player"
var paused = false

func _ready() -> void:
	paused = false
	Engine.time_scale = 1

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
		pause_menu.position.x = player.position.x

	paused = !paused
