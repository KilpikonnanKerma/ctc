extends Area2D

@export var level_path: String

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass

func _you(area: Area2D):
	if (not area.is_in_group("Enemy")):
		get_tree().change_scene_to_file(level_path)
