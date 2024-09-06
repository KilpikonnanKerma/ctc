extends Node

@export var player: CharacterBody2D

@export var Camera_Zone0: PhantomCamera2D
@export var Camera_Zone1: PhantomCamera2D
@export var Camera_Zone2: PhantomCamera2D
@export var Camera_Zone3: PhantomCamera2D
@export var Camera_Zone4: PhantomCamera2D

@export var Interaction_Area1: Area2D
@export var Interaction_Camera1: PhantomCamera2D

var current_camera_zone: int = 0

var is_active_interaction: bool = false
var active_interaction: Area2D

func _input(event):
	if Input.is_action_just_pressed("e"):
		if is_active_interaction:
			is_active_interaction = false
			update_camera()
		else:
			find_interaction()
		
func find_interaction():
	var areas: Array = [Interaction_Area1]
	var found_interaction_area: Area2D
	
	for area in areas:
		if found_interaction_area == null:
			var overlapping_bodies = area.get_overlapping_bodies()
			for i in overlapping_bodies:
				if i == player:
					found_interaction_area = area
					is_active_interaction = true
					active_interaction = found_interaction_area
					update_camera()

func update_current_zone(body, zone_a, zone_b):
	if body == player:
		match current_camera_zone:
			zone_a:
				current_camera_zone = zone_b
			zone_b:
				current_camera_zone = zone_a
		update_camera()

func update_camera():
	var cameras = [Camera_Zone0, Camera_Zone1, Camera_Zone2, Camera_Zone3, Camera_Zone4]
	for camera in cameras:
		if camera != null:
			camera.priority = 0
	
	if is_active_interaction:
		match active_interaction:
			Interaction_Area1:
				Interaction_Camera1.priority = 1
	else:
		match current_camera_zone:
			0:
				Camera_Zone0.priority = 1
			1:
				Camera_Zone1.priority = 1
			2:
				Camera_Zone2.priority = 1
			3:
				Camera_Zone3.priority = 1
			4:
				Camera_Zone4.priority = 1

func screen_shake_effect(shake_power, duration, camera):
	await get_tree().create_timer(1.0).timeout
	
	var og_global_pos: Vector2 = camera.global_position
	
	for i in duration:
		var shake_effect = Vector2(randf_range(-1,1), randf_range(-1,1)) * shake_power
		camera.global_position += shake_effect
		await get_tree().create_timer(0.01).timeout

	camera.global_position = og_global_pos
	

func _on_zone_01_body_entered(body):
	update_current_zone(body, 0, 1)
func _on_zone_12_body_entered(body):
	update_current_zone(body, 1, 2)
func _on_zone_23_body_entered(body):
	update_current_zone(body, 2, 3)
	screen_shake_effect(5, 10, Camera_Zone3)
func _on_zone_34_body_entered(body):
	update_current_zone(body, 3, 4)
