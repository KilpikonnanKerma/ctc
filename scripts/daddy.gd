extends CharacterBody2D

@onready var main = $"../.."
@onready var player = $"../../Player"
@onready var htmrk = $"Huutomerkki"
@onready var qstn = $"kymysys"

var speed = -1500
var max_move = 500


# random counters
var movement = 0
var searchi = 0
var is_close = false
var close_counter = 0

var facing_right = false

var direction

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	#if not is_on_floor(): daddy ain't getting gravity
	#	velocity += get_gravity() * delta

	if is_close:
		close_counter += 1
		if close_counter == 500:
			main.aggro = true
			close_counter = 0

	if not main.aggro && not main.searching: # normal roaming
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
		htmrk.hide()
		qstn.show()

		search(delta)

	move_and_slide()

func search(delta: float):
	searchi += 1

	if searchi == 1000:
		main.searching = false

	if movement < 100 + randi() % 500:
		velocity.x = speed * delta
		movement += 1
	else:
		flip()
		movement = 0

func flip():
	facing_right = !facing_right

	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1

func close_to_player(area: Area2D) -> void:
	if area.is_in_group("Player"):
		is_close = true
