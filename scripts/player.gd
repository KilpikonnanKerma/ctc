extends CharacterBody2D

@export_range(0,1) var acceleration = 0.1
@export_range(0,1) var deceleration = 0.25

@onready var player = $AnimatedSprite2D
@onready var hide_timer = Timer.new()

var run_speed = 250.0

const WALK_SPEED = 80.0
const JUMP_VELOCITY = -400.0

enum PlayerState {
	NORMAL,
	TRS_TO_HIDE,
	HIDING,
	TRS_FROM_HIDE
}

var state = PlayerState.NORMAL

func _ready():
	add_child(hide_timer)
	hide_timer.one_shot = true
	hide_timer.connect("timeout", Callable(self, "_on_hide_transition_finished"))

	player.animation_finished.connect(Callable(self, "_on_animation_finished"))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	match state:
		PlayerState.NORMAL:
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY

			if Input.is_action_just_pressed("hide") and is_on_floor():
				state = PlayerState.TRS_TO_HIDE
				player.play("hide_transition")
				hide_timer.start(1.4) # 5fps ja 7 frames
				velocity.x = 0 # ei pysty liikkua
				return

			var direction := Input.get_axis("mv_left", "mv_right")
			if direction:
				if Input.is_action_pressed("run"): #voi ns. dashata ilmassa, jos painaa shiftiä (it's not a bug it's a feature)
					velocity.x = move_toward(velocity.x, direction * run_speed, run_speed * acceleration)
				else:
					velocity.x = move_toward(velocity.x, direction * WALK_SPEED, WALK_SPEED * acceleration)

				if velocity.x > 0:
					player.animation = "walk_r"
				elif velocity.x < 0:
					player.animation = "walk_l"
			else:
				velocity.x = move_toward(velocity.x, 0, WALK_SPEED * deceleration)
				if is_on_floor():
					player.play("idle")

		PlayerState.TRS_TO_HIDE:
			velocity.x = 0

		PlayerState.HIDING:
			# movement is no
			velocity.x = 0
			if Input.is_action_just_pressed("unhide"):
				state = PlayerState.TRS_FROM_HIDE
				player.play_backwards("hide_transition")
				hide_timer.start(1.4)
				return

		PlayerState.TRS_FROM_HIDE:
			velocity.x = 0

	move_and_slide()
	# for index in get_slide_collision_count():
	# 	var collision := get_slide_collision(index)
	# 	var body := collision.get_collider()
	# 	print("Collided with: ", body.name)

func _on_hide_transition_finished():
	if state == PlayerState.TRS_TO_HIDE:
		state = PlayerState.HIDING
		player.play("hide")
	if state == PlayerState.TRS_FROM_HIDE:
		state = PlayerState.NORMAL
		player.play("idle")

func _on_animation_finished(anim_name):
	#if state == PlayerState.TRS_TO_HIDE and anim_name == "hide_transition":
	#	state = PlayerState.HIDING
	#	player.play("hide")
	if state == PlayerState.TRS_FROM_HIDE:
		state = PlayerState.NORMAL
		player.play("idle")
