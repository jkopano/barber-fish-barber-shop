extends Node2D

var fishClosed = preload("res://place-holders/dentist-fish-closed-atlas.png")
var pos = Vector2.ZERO
var last_mouse_position : Vector2
var current_rotation : float = 0.0

var wind_direction =Vector2.ZERO
var rotation_smoothness : float = 5.0

func _ready() -> void:
	last_mouse_position = get_viewport().get_mouse_position()
func _process(delta: float) -> void:
	var current_mouse_position = get_viewport().get_mouse_position()
	var mouse_velocity = current_mouse_position - last_mouse_position

	if mouse_velocity.length() > 0.01:
		rotation_smoothness = 5.0
		wind_direction = -mouse_velocity.normalized()
	else:
		rotation_smoothness = 1.0
		wind_direction = Vector2(1, 0)
	var target_angle = wind_direction.angle()

	current_rotation = lerp_angle(current_rotation, target_angle, rotation_smoothness * delta)

	get_children()[0].rotation = current_rotation
	last_mouse_position = current_mouse_position
	position = get_viewport().get_mouse_position()
