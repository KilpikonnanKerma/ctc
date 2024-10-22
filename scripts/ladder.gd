extends Area2D

@onready var player = %Player

func _ready():
	pass

func _process(_delta: float):
	pass

func _on_ladder_entered(area: Area2D):
	if area.is_in_group("Player"):
		player.is_on_ladder = true

func _on_ladder_exited(area: Area2D):
	if area.is_in_group("Player"):
		player.is_on_ladder = false
