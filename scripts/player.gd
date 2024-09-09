extends CharacterBody2D

@export_range(0,1) var acceleration = 0.1
@export_range(0,1) var deceleration = 0.25

@onready var camMan

var run_speed = 250.0

const WALK_SPEED = 80.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("mv_left", "mv_right")
	if direction:
		if Input.is_action_pressed("run"): #voi ns. dashata ilmassa, jos painaa shiftiä (it's not a bug it's a feature)
			velocity.x = move_toward(velocity.x, direction * run_speed, run_speed * acceleration)
		else:
			velocity.x = move_toward(velocity.x, direction * WALK_SPEED, WALK_SPEED * acceleration)

		if velocity.x > 0:
			$AnimatedSprite2D.animation = "walk_r"
		elif velocity.x < 0:
			$AnimatedSprite2D.animation = "walk_l"
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED * deceleration)
		if is_on_floor():
			$AnimatedSprite2D.play("idle")

	move_and_slide()
	# for index in get_slide_collision_count():
	# 	var collision := get_slide_collision(index)
	# 	var body := collision.get_collider()
	# 	print("Collided with: ", body.name)
			
