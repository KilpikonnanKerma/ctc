extends CharacterBody2D

@export_range(0,1) var acceleration = 0.1
@export_range(0,1) var deceleration = 0.5

@onready var main = $".."
@onready var vignette = $Camera/CanvasLayer/Vignette
@onready var player = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
@onready var hide_timer = Timer.new()

@onready var stamina_bar = $Camera/CanvasLayer/HUD/Stamina

var run_speed = 200.0
var health = 3

var cur_direction
var last_input = "right"

const WALK_SPEED = 80.0
const JUMP_VELOCITY = -300.0

var hiding: bool = false
var is_on_ladder: bool = false

var is_eating
var enemy_body

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

	hiding = false
	is_on_ladder = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() && !is_on_ladder:
		velocity += get_gravity() * delta

	if main.aggro && state == PlayerState.HIDING: # TODO: Vihollinen huomaa, jos meet piilon sen lähellä (käytä ehkä daddyn is_close boolia)
		main.searching = true
		main.aggro = false

	if stamina_bar.value <= 1000 && not Input.is_action_pressed("run"):
		if is_on_floor():
			stamina_bar.value += 1
		else:
			stamina_bar.value += 0.5

	match state:
		PlayerState.NORMAL:
			vignette.hide()
			is_eating = false
			hiding = false

			if Input.is_action_just_pressed("jump") and is_on_floor() && !is_on_ladder:
				velocity.y = JUMP_VELOCITY

			if Input.is_action_just_pressed("hide") and is_on_floor() && !is_on_ladder:
				state = PlayerState.TRS_TO_HIDE
				player.play("hide_transition")
				hide_timer.start(1.4) # 5fps ja 7 frames
				stop_movement() # ei pysty liikkua
				return

			if is_on_ladder:
				if Input.is_action_pressed("hide"):
					velocity.y -= WALK_SPEED * delta * 2
				if Input.is_action_pressed("mv_down"):
					velocity.y += WALK_SPEED * delta * 2

			if Input.is_action_just_pressed("consume") and is_on_floor() and main.etex == true:
				eat(main.cur_victim)

			var direction := Input.get_axis("mv_left", "mv_right")

			if direction:
				if Input.is_action_pressed("run") && stamina_bar.value > 0: #voi ns. dashata ilmassa, jos painaa shiftiä (it's not a bug it's a feature)
					velocity.x = move_toward(velocity.x, direction * run_speed, run_speed * acceleration)
					stamina_bar.value -= 4
				else:
					velocity.x = move_toward(velocity.x, direction * WALK_SPEED, WALK_SPEED * acceleration)

				if velocity.x > 0:
					player.animation = "walk_r"
					if not is_on_floor():
						player.play("walk_fall_r")
					last_input = "right"
				elif velocity.x < 0:
					player.animation = "walk_l"
					if not is_on_floor():
						player.play("walk_fall_l")
					last_input = "left"

			else:
				velocity.x = move_toward(velocity.x, 0, WALK_SPEED * deceleration)
				if is_on_floor():
					if last_input == "right":
						player.play("idle")
					elif last_input == "left":
						player.play("idle_left")
				if not is_on_floor():
					player.play("fall")

		PlayerState.TRS_TO_HIDE:
			stop_movement()
			vignette.show()
			animPlayer.play("vignette_anim")

		PlayerState.HIDING:
			# movement is no
			stop_movement()
			hiding = true
			if Input.is_action_just_pressed("unhide"):
				state = PlayerState.TRS_FROM_HIDE
				player.play_backwards("hide_transition")
				hide_timer.start(1.4)
				return

		PlayerState.TRS_FROM_HIDE:
			stop_movement()
			animPlayer.play("vignette_anim_off")
			
		PlayerState.DINNER_TIME:
			stop_movement()
			is_eating = true
			state = PlayerState.EATING
			player.play("eat01")
			hide_timer.start(2.85)
			return
		
		PlayerState.EATING:
			stop_movement()

	move_and_slide()
	# for index in get_slide_collision_count():
	# 	var collision := get_slide_collision(index)
	# 	var body := collision.get_collider()
	# 	print("Collided with: ", body.name)

func _input(event: InputEvent):
	if(event.is_action_pressed("mv_down") and state == PlayerState.NORMAL):
		position.y += 1

func stop_movement():
	velocity.x = 0

func take_damage():
	health -= 1
	var dir = Vector2(1, 0).rotated(player.global_rotation)
	var kick = 400
	var kickdirection = kick * (dir*1)
	velocity = velocity + kickdirection

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


func _on_ladder_entered(area: Area2D) -> void:
	if area.is_in_group("ladder"): # TODO: siirrä nää omaan scriptiin jolloin ehkä voisi toimia dumbass
		is_on_ladder = true


func _on_ladder_exited(area: Area2D) -> void:
	is_on_ladder = false
