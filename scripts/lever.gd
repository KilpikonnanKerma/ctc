extends Area2D

@export var lever: Sprite2D
@export var lever_pulled_sprt: Sprite2D

@export var lever_text: NinePatchRect

@export var areaa: Area2D

var is_on_area = false

signal lever_pulled

func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("consume") && is_on_area):
		lever.hide()
		lever_pulled_sprt.show()

		emit_signal("lever_pulled", areaa)

func _on_lever_area_entered(area: Area2D) -> void:
	if (!area.is_in_group("Enemy")):
		is_on_area = true
		lever_text.show()

func _on_lever_area_exited(area: Area2D) -> void:
	if (!area.is_in_group("Enemy")):
		lever_text.hide()
		is_on_area = false
