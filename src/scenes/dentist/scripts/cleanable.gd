extends Node2D

func clean(min_distance):
	var mouse_pos = get_viewport().get_mouse_position()
	var distance = global_position.distance_to(mouse_pos)
	if distance <min_distance:
		queue_free()
		return true
	return false
