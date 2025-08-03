extends Node2D

@onready var fish = get_node("Node2D/AnimatedSprite2D")

var pos = Vector2.ZERO
var last_mouse_position = Vector2.ZERO
var current_rotation : float = 0.0

var wind_direction = Vector2.ZERO
var rotation_smoothness : float = 5.0

func _ready() -> void:
	playAnim("normal")
	
func _process(delta: float) -> void:
	var camera = get_viewport().get_camera_2d()
	var current_mouse_position = camera.get_global_mouse_position()
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
	position = camera.get_global_mouse_position()
func playAnim(animName):
	get_child(0).get_child(0).playAnim(animName)
