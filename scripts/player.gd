extends CharacterBody2D

@export_range(0,1) var acceleration = 0.1
@export_range(0,1) var deceleration = 0.5

@export var main: Node2D

@export var globals: Node

@onready var vignette = $Camera/CanvasLayer/Vignette
@onready var heartbeat = $Camera/CanvasLayer/Heartbeat
@onready var player = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
@onready var cameraAnim = $CameraAnim
@onready var hide_timer = Timer.new()

@onready var stamina_bar = $Camera/CanvasLayer/HUD/Stamina

var blood_splatter01 = preload("res://scenes/props/blood_splatter01.tscn")

var run_speed = 200.0
var health = 3

var last_ate = 0

var cur_direction
var last_input = "right"

const WALK_SPEED = 80.0
const JUMP_VELOCITY = -300.0

var hiding: bool = false
var is_on_ladder: bool = false
var is_on_level_switch_area = false

var is_eating
var enemy_body
var is_hungry: bool = false

enum HungerState {FULL, HUNGRY, STARVING}
var hunger_state = HungerState.FULL

var death_has_been_called = false # <--- Ettei kuolemaa kutsuta kokoajan uudestaan

enum PlayerState {
	NORMAL, TRS_TO_HIDE,
	HIDING, TRS_FROM_HIDE,
	DINNER_TIME, EATING,
	TRS_TO_FALL, FALL,
	DYING
}

var state = PlayerState.NORMAL

func _ready():
	add_child(hide_timer)
	hide_timer.one_shot = true
	hide_timer.connect("timeout", Callable(self, "_on_hide_transition_finished"))
	player.animation_finished.connect(Callable(self, "_on_animation_finished"))

	hiding = false
	is_on_ladder = false
	is_hungry = false
	death_has_been_called = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() && !is_on_ladder:
		velocity += get_gravity() * delta

	var direction := Input.get_axis("mv_left", "mv_right")

	if stamina_bar.value <= 1000 && not Input.is_action_just_pressed("run"):
		if is_on_floor():
			stamina_bar.value += 1

	if health == 0 && !death_has_been_called:
		die()
		death_has_been_called = true

	if (hiding):
		stop_movement()

	match state:
		PlayerState.NORMAL:
			vignette.hide()
			is_eating = false

			if Input.is_action_just_pressed("jump") and is_on_floor() && !is_on_ladder:
				velocity.y = JUMP_VELOCITY

			if Input.is_action_just_pressed("hide") and is_on_floor() && !is_on_ladder && main.hide_available && !main.is_on_hide_area && !is_on_level_switch_area:
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

			if direction:
				if (Input.is_action_pressed("run") && stamina_bar.value >= 50 && !hiding): #voi ns. dashata ilmassa, jos painaa shiftiä (it's not a bug it's a feature)
					velocity.x = move_toward(velocity.x, direction * run_speed, run_speed * acceleration)
					if is_hungry:
						stamina_bar.value -= 8
					else:
						stamina_bar.value -= 4
				else:
					if is_hungry:
						velocity.x = move_toward(velocity.x, direction * WALK_SPEED/2, WALK_SPEED/2 * acceleration)
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
			if last_input == "right":
				player.play("eat01")
			elif last_input == "left":
				player.play("eat01_l")
			hide_timer.start(2.85)
			stamina_bar.value += 500
			return

		PlayerState.EATING:
			stop_movement()

		PlayerState.DYING:
			stop_movement()


	move_and_slide()
	# for index in get_slide_collision_count():
	# 	var collision := get_slide_collision(index)
	# 	var body := collision.get_collider()
	# 	print("Collided with: ", body.name)

func _input(event: InputEvent):
	if(event.is_action_pressed("mv_down") and state == PlayerState.NORMAL && !hiding):
		position.y += 1

func stop_movement():
	velocity.x = 0

func die():
	state = PlayerState.DYING
	player.play("explode02")
	hide_timer.start(1.15)

func eat(body):
	body.queue_free()

	if last_input == "right":
			player.position.x += 16
	elif last_input == "left":
		player.position.x -= 16

	state = PlayerState.DINNER_TIME

	globals.babies_ate += 1
	print(globals.babies_ate)

# func blood_splatter(pos): # maybe todo
# 	var instance = blood_splatter01.instantiate()
# 	instance.position = pos

func _on_hide_transition_finished():
	if state == PlayerState.TRS_TO_HIDE:
		state = PlayerState.HIDING
		player.play("hide")
	if state == PlayerState.TRS_FROM_HIDE:
		state = PlayerState.NORMAL
		player.play("idle")
		main.hide_available = false
		hiding = false
	if state == PlayerState.EATING:
		last_ate = 0
		heartbeat.hide()
		is_hungry = false
		state = PlayerState.NORMAL
		player.play("idle")

		if last_input == "right":
			player.position.x -= 16
		elif last_input == "left":
			player.position.x += 16

	if state == PlayerState.TRS_TO_FALL:
		state = PlayerState.FALL
	if state == PlayerState.DYING:
		get_tree().change_scene_to_file("res://scenes/dead_menu.tscn")

func _on_kill_range_entered(body):
	if body.is_in_group("Eatable"):
		main.eatConfirm(true, body)

func _on_kille_range_exited(body):
	if body.is_in_group("Eatable"):
		main.eatConfirm(false, body)
