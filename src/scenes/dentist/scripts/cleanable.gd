extends Node2D

func _process(delta: float):
	var mouse_pos = get_viewport().get_mouse_position()
	var distance = global_position.distance_to(mouse_pos)

func clean():
	var mouse_pos = get_viewport().get_mouse_position()
	var distance = global_position.distance_to(mouse_pos)
	if distance <30:
		queue_free()
		return true
	return false
