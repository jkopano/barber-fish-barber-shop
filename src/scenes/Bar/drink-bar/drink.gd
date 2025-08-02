extends Area2D

var dragging := false
var drag_offset := Vector2.ZERO

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = global_position - get_global_mouse_position()
		else:
			dragging = false
			_check_drop()

func _unhandled_input(event):
	if event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() + drag_offset		

func _check_drop():
	var overlapping_areas = get_overlapping_areas()
	for area in overlapping_areas:
		if area.name == "Shark":
			area._on_drink_dropped(self)
			return
			
