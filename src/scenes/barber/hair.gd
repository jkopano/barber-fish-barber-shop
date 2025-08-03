extends MiniGame

@onready var sfxplayer = $"../AudioStreamPlayer"

var hair_strands = []
var cut_hair_strands = []
var time = 0.0
var initial_inside_density = []
var initial_outside_density = 0.0
var show_green = false
var show_red = false
var density_timer = 0.0

# general
const gravity = Vector2(0, 150)
const repulsion_radius = 60
const repulsion_strength = 1500
const min_distance_between_hair = 10
const base_color = Color.SADDLE_BROWN
const hair_color_variation = 0.1

# Main circle
const hairRadius = 125
var hair_center = Vector2(1000, 300)

# Reference circles
var numCircles = 1
var reference_circles = []

var move_x = 0

var play = false

func getNumCircles():
	if Globals.serializeData.level<2:
		numCircles = 1
	elif Globals.serializeData.level<4:
		numCircles = 2
	else:
		numCircles = 3
func _ready():
	randomize()
	getNumCircles()
	hair_center.y = get_viewport_rect().size.y / 2
	hair_center.x = get_viewport_rect().size.x
	move_x = -hair_center.x * 0.6
	
	
	for i in range(1000):
		var valid_position_found = false
		var hairStrandOffset = Vector2.ZERO
		var numTries = 0
		while not valid_position_found and numTries < 10:
			numTries += 1

			var angle = randf() * TAU
			var distance = sqrt(randf()) * hairRadius  # This gives uniform density
			var direction = Vector2(cos(angle), sin(angle)) * distance
			hairStrandOffset = direction

			valid_position_found = true
			for strand in hair_strands:
				if hairStrandOffset.distance_to(strand.base_offset) < min_distance_between_hair:
					valid_position_found = false
					break

		hair_strands.append({
			"base_offset": hairStrandOffset,
			"tip_offset": hairStrandOffset + Vector2(0, 30),
			"velocity": Vector2.ZERO,
			"hair_color": base_color + Color(
				randf() * hair_color_variation,
				randf() * hair_color_variation,
				randf() * hair_color_variation
			)
		})

	# Reference circles generation
	while reference_circles.size() < numCircles:
		var radius = hairRadius * (randf() * 0.2 + 0.3) # 0.3 to 0.5
		var tries = 0
		var offset = Vector2.ZERO
		var valid = false

		while tries < 100 and not valid:
			tries += 1
			var angle = randf() * TAU
			var dist = randf() * (hairRadius - radius)
			offset = Vector2(cos(angle), sin(angle)) * dist

			valid = true
			for existing in reference_circles:
				if offset.distance_to(existing.offset) < (radius + existing.radius):
					valid = false
					break

		if valid:
			reference_circles.append({
				"radius": radius,
				"offset": offset
			})

	# Initial densities
	var inside_counts = []
	for i in range(reference_circles.size()):
		inside_counts.append(0)
	var outside_count = 0

	for strand in hair_strands:
		var inside_any = false
		for i in range(reference_circles.size()):
			var circle = reference_circles[i]
			if strand["base_offset"].distance_to(circle.offset) <= circle.radius:
				inside_counts[i] += 1
				inside_any = true
				break
		if not inside_any:
			outside_count += 1

	var outside_area = PI * hairRadius * hairRadius
	for circle in reference_circles:
		outside_area -= PI * circle.radius * circle.radius

	for i in range(reference_circles.size()):
		var circle = reference_circles[i]
		var inside_area = PI * circle.radius * circle.radius
		initial_inside_density.append(inside_counts[i] / inside_area)

	initial_outside_density = outside_count / outside_area

	start_movement_tween(set_done)

func set_done():
	play = !play

func complete_game():
	exit_game()

	

func start_movement_tween(callback):
	var tween = create_tween()
	var target1 = hair_center + Vector2(move_x, 0)
	tween.tween_property(self, "hair_center", target1, 1.0)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)

	tween.tween_property(self, "hair_center", hair_center + Vector2(move_x, 0) + Vector2(-100, 0), 0.05)
	tween.tween_property(self, "hair_center", hair_center + Vector2(move_x, 0) + Vector2(100, 0), 0.1)
	tween.tween_property(self, "hair_center", hair_center + Vector2(move_x, 0) + Vector2(-100, 0), 0.05)

	tween.tween_callback(callback)

func _process(delta):
	time += delta
	density_timer += delta

	var mouse_pos = get_viewport().get_mouse_position()

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and play == true:
		sfxplayer.play()
		for i in range(len(hair_strands) - 1, -1, -1):
			var strand = hair_strands[i]
			var base = hair_center + strand["base_offset"]
			if base.distance_to(mouse_pos) < repulsion_radius * 0.66:
				var cut_strand = {
					"position": base,
					"velocity": strand["velocity"],
					"angle": randf() * TAU,
					"angular_velocity": randf_range(-5, 5),
					"length": (strand["tip_offset"] - strand["base_offset"]).length(),
					"direction": (strand["tip_offset"] - strand["base_offset"]).normalized(),
					"hair_color": strand["hair_color"]
				}
				cut_hair_strands.append(cut_strand)
				hair_strands.remove_at(i)
				
	else:
		sfxplayer.stop()

	# Hair physics
	for strand in hair_strands:
		var base = strand["base_offset"]
		var tip = strand["tip_offset"]
		var velocity = strand["velocity"]

		velocity += gravity * delta

		var dist_to_mouse = (hair_center + tip).distance_to(mouse_pos)
		if dist_to_mouse < repulsion_radius:
			var dir = ((hair_center + tip) - mouse_pos).normalized()
			var force = dir * (repulsion_strength * (1.0 - dist_to_mouse / repulsion_radius))
			velocity += force * delta

		tip += velocity * delta
		velocity *= 0.98

		var max_length = 30.0
		var diff = tip - base
		var dist = diff.length()
		if dist > max_length:
			diff = diff.normalized() * max_length
			tip = base + diff
			velocity -= velocity.project(diff.normalized())

		strand["tip_offset"] = tip
		strand["velocity"] = velocity

	# Cut hairs
	for strand in cut_hair_strands:
		strand["velocity"] += gravity * delta
		strand["position"] += strand["velocity"] * delta
		strand["angle"] += strand["angular_velocity"] * delta

	if density_timer >= 0.5:
		density_timer = 0.0

		var inside_counts = []
		for i in range(reference_circles.size()):
			inside_counts.append(0)
		var outside_count = 0

		for strand in hair_strands:
			var inside_any = false
			for i in range(reference_circles.size()):
				var circle = reference_circles[i]
				if strand["base_offset"].distance_to(circle.offset) <= circle.radius:
					inside_counts[i] += 1
					inside_any = true
					break
			if not inside_any:
				outside_count += 1

		var outside_area = PI * hairRadius * hairRadius
		for circle in reference_circles:
			outside_area -= PI * circle.radius * circle.radius

		var inside_ok = true
		for i in range(reference_circles.size()):
			var circle = reference_circles[i]
			var inside_area = PI * circle.radius * circle.radius
			var inside_density = inside_counts[i] / inside_area
			var ratio = inside_density / initial_inside_density[i]
			if ratio < 0.5:
				inside_ok = false

		var outside_density = outside_count / outside_area
		var outside_ratio = outside_density / initial_outside_density

		if outside_ratio <= 0.2 and inside_ok:
			if move_x < 0:
				play = false
				move_x = -move_x
				start_movement_tween(complete_game)
		elif not inside_ok:
			show_green = false
			show_red = true
			var death_scene = preload("res://src/scenes/death/death-with-animation/death.tscn")
			get_tree().change_scene_to_packed(death_scene)
		else:
			show_green = false
			show_red = false

	queue_redraw()

func _draw():
	for circle in reference_circles:
		draw_circle(hair_center + circle.offset, circle.radius, Color.GREEN)

	for strand in hair_strands:
		draw_line(
			hair_center + strand["base_offset"],
			hair_center + strand["tip_offset"],
			strand["hair_color"] * Color(1., 1., 1., 0.5), 3
		)

	for strand in cut_hair_strands:
		var pos = strand["position"]
		var dir = strand["direction"].rotated(strand["angle"])
		var length = strand["length"]
		draw_line(pos, pos + dir * length, strand["hair_color"] + Color(0.3, 0.3, 0.3) * Color(1., 1., 1., 0.5), 3)

	if show_green:
		for circle in reference_circles:
			draw_circle(hair_center + circle.offset, circle.radius, Color.SEA_GREEN)
	elif show_red:
		for circle in reference_circles:
			draw_circle(hair_center + circle.offset, circle.radius, Color.INDIAN_RED)
