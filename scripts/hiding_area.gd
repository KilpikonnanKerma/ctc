extends Area2D

@export var main: Node2D
@export var player: CharacterBody2D

#@export var pc_text: NinePatchRect
#@export var controller_text: NinePatchRect

@onready var pc_text = $"pc_text"
@onready var controller_text = $"controller_text"

@export var normal_sprite: Sprite2D
@export var hiding_sprite: AnimatedSprite2D

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if (main.is_on_hide_area && !player.hiding && Input.is_action_just_pressed("hide")):
		normal_sprite.hide()
		player.player.hide()
		player.hiding = true

		hiding_sprite.show()
		hiding_sprite.play("hiding")

	if(player.hiding && Input.is_action_just_pressed("unhide")):
		normal_sprite.show()
		player.player.show()

		player.hiding = false

		hiding_sprite.hide()

func _on_hide_area_entered(area: Area2D):
	if (!area.is_in_group("Enemy")):
		if (main.is_using_controller):
			controller_text.show()
			pc_text.hide()
		elif (!main.is_using_controller):
			controller_text.hide()
			pc_text.show()
		main.is_on_hide_area = true
	
func _on_hide_area_exited(area: Area2D):
	if(!area.is_in_group("Enemy")):
		controller_text.hide()
		pc_text.hide()
		main.is_on_hide_area = false
		
