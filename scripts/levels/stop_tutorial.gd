extends Area2D

@export var main: Node2D

@export var tutorial_text_pc: NinePatchRect
@export var tutorial_text_console: NinePatchRect

func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	pass


func _on_tutorial_ended(area: Area2D) -> void:
	if (area.is_in_group("Player")):
		tutorial_text_console.queue_free()
		tutorial_text_pc.queue_free()

		main.tutorial_ended = true
