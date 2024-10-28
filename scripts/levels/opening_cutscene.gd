extends Node2D

@onready var anim_player = $"AnimationPlayer"
@onready var animation_PLAYER = $"anim_player" #literal animation player character
@onready var animation_camera = $"anim_player/Camera2"

var player = preload("res://scenes/player.tscn")

func _ready() -> void:
	anim_player.animation_finished.connect(Callable(self, "_on_cutscene_ended"))
	anim_player.play("opening_cutscene")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().change_scene_to_file("res://scenes/levels/tutorial.tscn")


func _on_cutscene_ended(_anim: StringName):
	get_tree().change_scene_to_file("res://scenes/levels/tutorial.tscn")
	
func instantiate_player(pos): # ei tarvita mutta voi olla hyödyllinen joskus muulloin
	var instance = player.instantiate()
	instance.position = pos
	add_child(instance)
