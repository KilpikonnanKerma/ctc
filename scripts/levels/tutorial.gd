extends Node2D

@onready var anim_player = $"AnimationPlayer"
@onready var animation_PLAYER = $"anim_player" #literal animation player character
@onready var player = $Player

@onready var cutscene_timer = Timer.new()


func _ready() -> void:
	cutscene_timer.one_shot = true
	cutscene_timer.connect("timeout", Callable(self, "_on_cutscene_ended"))

	anim_player.play("opening_cutscene")
	player.hide()
	cutscene_timer.start(20)


func _process(_delta: float) -> void:
	pass


func _on_cutscene_ended():
	animation_PLAYER.queue_free()
	player.show()
