extends Node2D

@onready var block = $Block/CollisionShape2D
@onready var text = $Block/key_text

@export var lock: AnimatedSprite2D

enum KeyColors { yellow, green, red, blue }
@export var key_color: KeyColors = KeyColors.yellow

var entered: bool = false

func _ready() -> void:
	text.hide()
	var color_name = KeyColors.keys()[key_color]
	lock.animation = color_name + "_anim"
	lock.stop()

func _on_door_opened(area: Area2D):
	if !area.is_in_group("Enemy"): #&& area.is_in_group("Player"):
		block.disabled = true
		text.hide()

		if entered == false:
			lock.play()

		entered = true

		# lock.hide()

func _on_door_entered(area: Area2D):
	if not area.is_in_group("Enemy") && block.disabled == false: #&& area.is_in_group("Player"):
		text.show()

func _on_door_exited(area: Area2D):
	if not area.is_in_group("Enemy"): #&& area.is_in_group("Player"):
		text.hide()
