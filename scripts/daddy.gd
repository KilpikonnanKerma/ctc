extends CharacterBody2D

@onready var main = $"../.."
@onready var player = $"../../Player"
@onready var htmrk = $"Huutomerkki"
@onready var qstn = $"kymysys"

var speed = -1500
var movement = 0
var max_move = 500

var facing_right = false

var direction

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	#if not is_on_floor():
	#	velocity += get_gravity() * delta

	if not main.aggro: # normal roaming
		htmrk.hide()
		qstn.hide()
		if movement < max_move:
			velocity.x = speed * delta
			movement += 1
		else:
			flip()
			movement = 0
	elif main.aggro:		# aggro
		htmrk.show()
		if !facing_right:
			direction = (player.position - position).normalized()
			velocity.x = (direction.x * -speed*2) * delta
		else:
			flip()
	elif main.searching: #searching
		qstn.show()

		if movement < randi() % 400:
			velocity.x = speed * delta
			movement += 1
		else:
			flip()
			movement = 0


	move_and_slide()

func flip():
	facing_right = !facing_right

	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1

	
