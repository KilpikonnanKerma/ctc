extends Node2D

@onready var player = %Player
@onready var anim_player = %Player/AnimationPlayer
@onready var camera = %Player/Camera

@onready var ballsack = $"../Tutorial_text"
@onready var pp = $"../Tutorial_text_console"

var paused = false

var tutorial_completed = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if !tutorial_completed:
		if (event is InputEventKey):
			ballsack.show()
			pp.hide()
		elif (event is InputEventJoypadButton or event is InputEventJoypadMotion):
			ballsack.hide()
			pp.show()
