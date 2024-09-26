extends CharacterBody2D


func _ready() -> void:
	pass 


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	
