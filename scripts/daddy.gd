extends CharacterBody2D

@export var main: Node2D
@export var player: CharacterBody2D
@onready var htmrk = $"Huutomerkki"
@onready var qstn = $"kymysys"
@onready var notice_timer = $"notice_timer"

@onready var anim = $AnimatedSprite2D

var speed = -1500
var max_move = 700

@onready var collision = $"Collision"

# random counters
var movement = 0
var searchi = 0
var is_close = false
var is_on_attack_zone = false
var close_counter = 0
var forget_counter = 0

var facing_right = false

var direction

var i = 0

var just_attacked: bool = false
var attack_cooldown = 200

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	#if not is_on_floor(): daddy ain't getting gravity
	#	velocity += get_gravity() * delta

	if (velocity.x == 0 && not main.aggro):
		anim.play("idle")
	else:
		anim.stop()

	if (just_attacked && attack_cooldown >= 0):
		attack_cooldown -= 1
	else:
		just_attacked = false

	if main.aggro && player.hiding:#player.state == player.PlayerState.HIDING: # TODO: Vihollinen huomaa, jos meet piilon sen lähellä (käytä ehkä daddyn is_close boolia)
		main.searching = true
		main.aggro = false

	if is_close && not main.aggro && not player.hiding:
		notice_timer.show()
		if !main.paused:
			notice_timer.play("timer")
			close_counter += 1
		if close_counter == 130:
			notice_timer.hide()
			is_close = false
			main.aggro = true
			close_counter = 0

	elif not is_close && main.aggro && not main.paused:
		forget_counter += 1
		if forget_counter == 1000:
			main.aggro = false
			main.searching = true
			forget_counter = 0
	else:
		notice_timer.hide()
		notice_timer.stop()
		close_counter = 0

	if not main.aggro && not main.searching && not main.paused: # normal roaming
		htmrk.hide()
		qstn.hide()
		if movement < max_move:
			velocity.x = speed * delta
			movement += 1
		else:
			if i < 250:
				velocity.x = 0
				i += 1
			else:
				flip()
				movement = 0
				i = 0
	elif main.aggro:		# aggro
		anim.play("angry")
		qstn.hide()
		htmrk.show()
		if !facing_right:
			direction = (player.position - position).normalized()
			velocity.x = (direction.x*2 * -speed*1.5) * delta
		else:
			flip()

	elif main.searching: #searching
		htmrk.hide()
		qstn.show()

		if !main.paused:
			search(delta)

	move_and_slide()

func search(delta: float):
	searchi += 1

	if searchi == 1000:
		main.searching = false
		searchi = 0

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
	# todo: kato, onko pelaaja piilossa

	if area.is_in_group("Player"):
		if main.searching == true:
			main.aggro = true

		if not main.aggro:
			is_close = true
		
		if player.is_eating:
			main.aggro = true

func far_from_player(area: Area2D) -> void:

	if area.is_in_group("Player"):
		if not main.aggro:
			is_close = false

func attackus(_area: Area2D) -> void:
	is_on_attack_zone = true

	if (main.aggro and just_attacked == false and is_on_attack_zone):
		var kick = 690 # irl 1.6 km/s
		var kickdir
		var dir = (player.position - position).normalized()
		if dir.x > 0: #position.x: # player is on the left
			kickdir = kick #+ (dir*1)
			player.velocity.x += kickdir
		if dir.x < 0:
			kickdir = -kick#+ (dir*-1)
			player.velocity.x += kickdir

		player.hp.value -= 1
		player.stamina_bar.value -= 200
		just_attacked = true
		attack_cooldown = 200

	# todo: katso pelaajan suunta suhteessa viholliseen

func attack_exited(_area: Area2D) -> void:
	is_on_attack_zone = false
