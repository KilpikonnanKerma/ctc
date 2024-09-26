extends Node2D

@onready var pause_menu = $"Player/Camera/CanvasLayer/PauseMenu"
@onready var eat_text = $"Eat_text"
@onready var player = $"Player"
var paused = false
var etex = false
var cur_victim

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
		#pause_menu.position.x = player.position.x

	paused = !paused

func eatConfirm(ison, victim):
	if ison == false:
		eat_text.hide()
	else:
		eat_text.show()
		eat_text.position.x = player.position.x
		eat_text.position.y = player.position.y - 40

	etex = ison
	cur_victim = victim
