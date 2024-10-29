extends Area2D

@export var level_path: String

@onready var animPlayer = %Player/AnimationPlayer

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass

func switch_level(_anim: StringName):
	get_tree().change_scene_to_file(level_path)

# fuck you xd
func _you(area: Area2D):
	if (not area.is_in_group("Enemy")):
		animPlayer.animation_finished.connect(Callable(self, "switch_level"))
		animPlayer.play("camera_zoom_in")
