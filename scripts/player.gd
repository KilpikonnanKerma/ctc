extends CharacterBody2D

@export_range(0,1) var acceleration = 0.1
@export_range(0,1) var deceleration = 0.5

@onready var main = $".."
@onready var vignette = $Camera/CanvasLayer/Vignette
@onready var player = $AnimatedSprite2D
@onready var hide_timer = Timer.new()

var run_speed = 200.0

const WALK_SPEED = 80.0
const JUMP_VELOCITY = -300.0

enum PlayerState {
	NORMAL, TRS_TO_HIDE,
	HIDING, TRS_FROM_HIDE,
	DINNER_TIME, EATING,
	TRS_TO_FALL, FALL
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

			if Input.is_action_just_pressed("consume") and is_on_floor() and main.etex == true:
				eat(main.cur_victim)

			var direction := Input.get_axis("mv_left", "mv_right")
			if direction:
				if Input.is_action_pressed("run"): #voi ns. dashata ilmassa, jos painaa shiftiä (it's not a bug it's a feature)
					velocity.x = move_toward(velocity.x, direction * run_speed, run_speed * acceleration)
				else:
					velocity.x = move_toward(velocity.x, direction * WALK_SPEED, WALK_SPEED * acceleration)

				if velocity.x > 0:
					player.animation = "walk_r"
					if not is_on_floor():
						player.play("walk_fall_r")
				elif velocity.x < 0:
					player.animation = "walk_l"
					if not is_on_floor():
						player.play("walk_fall_l")
			else:
				velocity.x = move_toward(velocity.x, 0, WALK_SPEED * deceleration)
				if is_on_floor():
					player.play("idle")
				if not is_on_floor():
					player.play("fall")

		PlayerState.TRS_TO_HIDE:
			velocity.x = 0

		PlayerState.HIDING:
			# movement is no
			vignette.show()
			velocity.x = 0
			if Input.is_action_just_pressed("unhide"):
				state = PlayerState.TRS_FROM_HIDE
				player.play_backwards("hide_transition")
				hide_timer.start(1.4)
				return

		PlayerState.TRS_FROM_HIDE:
			velocity.x = 0
			vignette.hide()
			
		PlayerState.DINNER_TIME:
			velocity.x = 0
			state = PlayerState.EATING
			player.play("eat01")
			hide_timer.start(2.7)
			return
		
		PlayerState.EATING:
			velocity.x = 0

	move_and_slide()
	# for index in get_slide_collision_count():
	# 	var collision := get_slide_collision(index)
	# 	var body := collision.get_collider()
	# 	print("Collided with: ", body.name)

func _input(event: InputEvent):
	if(event.is_action_pressed("mv_down") and state == PlayerState.NORMAL):
		position.y += 1

func eat(body):
	body.queue_free()
	player.position.x += 16
	state = PlayerState.DINNER_TIME

func _on_hide_transition_finished():
	if state == PlayerState.TRS_TO_HIDE:
		state = PlayerState.HIDING
		player.play("hide")
	if state == PlayerState.TRS_FROM_HIDE:
		state = PlayerState.NORMAL
		player.play("idle")
	if state == PlayerState.EATING:
		state = PlayerState.NORMAL
		player.play("idle")
		player.position.x -= 16
	if state == PlayerState.TRS_TO_FALL:
		state = PlayerState.FALL

func _on_animation_finished(anim_name):
	#if state == PlayerState.TRS_TO_HIDE and anim_name == "hide_transition":
	#	state = PlayerState.HIDING
	#	player.play("hide")
	if state == PlayerState.TRS_FROM_HIDE:
		state = PlayerState.NORMAL
		player.play("idle")

func _on_kill_range_entered(body):
	if body.is_in_group("Eatable"):
		main.eatConfirm(true, body)
	
func _on_kille_range_exited(body):
	if body.is_in_group("Eatable"):
		main.eatConfirm(false, body)
