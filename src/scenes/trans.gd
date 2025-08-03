extends Node2D

var should_play = false
var angle = 0.0
var speed = 1.5 # Rotation speed
var num_triangles = 8 # Number of triangles

func play_anim(callback, wait):
	if should_play:
		return
	await get_tree().create_timer(wait).timeout
	should_play = true
	get_child(0).play_anim(callback)

func _process(delta: float) -> void:
	if not should_play:
		return
	angle += speed * delta
	queue_redraw()

func _draw() -> void:
	if not should_play:
		return
	var viewport_size = get_viewport_rect().size
	var center = viewport_size / 2
	var radius = viewport_size.length() # Large enough to cover screen

	for i in range(num_triangles):
		var a1 = angle + (TAU / num_triangles) * i
		var a2 = angle + (TAU / num_triangles) * (i + 1)

		var p1 = center
		var p2 = center + Vector2(cos(a1), sin(a1)) * radius
		var p3 = center + Vector2(cos(a2), sin(a2)) * radius
		var color = Color.MEDIUM_PURPLE
		if i%2==0:
			color = Color.CADET_BLUE
		draw_colored_polygon([p1, p2, p3], color)
		
