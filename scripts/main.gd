extends Node2D

@onready var pause_menu = $"Player/Camera/CanvasLayer/PauseMenu"

@onready var eat_text_pc = $"Player/Eat_text/pc"
@onready var eat_text_ctrl = $"Player/Eat_text/controller"

@onready var player = %"Player"
@onready var player_anim = %"Player/AnimatedSprite2D"

@onready var hp = $"Player/Camera/CanvasLayer/HUD/HealthBar/Health"
@onready var hungerbar = $"Player/Camera/CanvasLayer/HUD/Hunger"

@onready var hide_regen_anim = $"Player/Camera/CanvasLayer/HUD/HIDE_REGEN"
@onready var hide = $"Player/Camera/CanvasLayer/HUD/HIDE"

@onready var settings = $"Player/Camera/CanvasLayer/Settings"

@onready var gen_timer = Timer.new()

var paused = false
var etex = false
var cur_victim

var hp_regen = 0

var hide_available = true
var hide_regen = 0

var aggro = false
var searching = false

var is_using_controller: bool = false
var is_on_hide_area: bool = false

var tutorial_ended = false

func _ready() -> void:
	gen_timer.one_shot = true
	paused = false
	Engine.time_scale = 1

	#hide_available = true

	player.cameraAnim.play("camera_zoom_out")

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

	update_hunger_status()
	update_health_status()

	if !paused:
		hide_regeneration()

	if !hide_available:
		hide.play("unavailable")
	else:
		hide.play("available")

func _input(event: InputEvent):
	if (event is InputEventKey):
		is_using_controller = false
	elif (event is InputEventJoypadButton or event is InputEventJoypadMotion):
		is_using_controller = true

func update_health_status():
	if player.hp.value == 0:
			hp.hide()

	if hp_regen == 2000 && !paused:
		player.hp.value += 1
		hp_regen = 0

	if player.hp.value != 3 && !paused:
		hp_regen += 1

func update_hunger_status():
	if paused:
		return
	
	player.last_ate += 1
	hungerbar.value = player.last_ate

	match player.hunger_state:
		player.HungerState.FULL:
			if player.last_ate >= 9000:
				player.hunger_state = player.HungerState.HUNGRY
				player.heartbeat.show()
				player.heartbeat_animPlayer.play("heartbeat_on")
		
		player.HungerState.HUNGRY:
			if player.last_ate >= 10000:
				player.cameraAnim.play("camera_zoom_in_slow")
				player.hunger_state = player.HungerState.STARVING
				player.is_hungry = true
				player.heartbeat_animPlayer.play("heartbeat")

		player.HungerState.STARVING:
			if player.last_ate >= 11500:
				player.heartbeat_animPlayer.play("heartbeat_fast")
			if player.last_ate >= 12000 and !player.death_has_been_called:
				player.die()
				player.death_has_been_called = true



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
		eat_text_pc.hide()
		eat_text_ctrl.hide()
	else:
		if is_using_controller:
			eat_text_ctrl.show()
		else:
			eat_text_pc.show()

	etex = ison
	cur_victim = victim


func hide_regeneration():
	if hide_regen == 3900:
		hide_available = true
		hide_regen = 0
		hide_regen_anim.hide()

	if (!hide_available):
		hide_regen_anim.show()
		hide_regen_anim.play("HP_REGEN")
		hide_regen += 1
