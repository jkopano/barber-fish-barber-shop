extends Node2D


func clean():
	if Input.is_action_just_released(""):
		pass
	var mouse_pos = get_viewport().get_mouse_position()
	var distance = global_position.distance_to(mouse_pos)
	if distance <10:
		queue_free()
		return true
	return false
