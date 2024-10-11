extends Node2D

@onready var pause_menu = $"Player/Camera/CanvasLayer/PauseMenu"
@onready var eat_text = $"Eat_text"
@onready var player = $"Player"
@onready var DebugDisplay = $DebugInfo
@onready var hp = $"Player/Camera/CanvasLayer/HUD/HP"

@onready var gen_timer = Timer.new()

var paused = false
var etex = false
var cur_victim

var hp_regen = 0

var aggro = false
var searching = false

func _ready() -> void:
	gen_timer.one_shot = true
	paused = false
	Engine.time_scale = 1

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

	if player.health == 0:
		#game over
		pass

	if hp_regen == 2000:
		player.health += 1
		hp_regen = 0

	if player.health != 3:
		hp_regen += 1

	if player.health == 3:
		hp.play("hp_full")
	elif player.health == 2:
		hp.play("hp_half")
	elif player.health == 1:
		hp.play("hp_empty")

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
