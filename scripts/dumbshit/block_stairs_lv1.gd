extends Area2D

@onready var og_txtr = $Stairs
@onready var block_txtr = $Stair_block

func _on_area_exited(area: Area2D) -> void:
	if (area.is_in_group("Player")):
		og_txtr.hide()
		block_txtr.show()
		#play audio
