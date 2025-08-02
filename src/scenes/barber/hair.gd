extends Node2D

var hair_strands = []
var cut_hair_strands = []
var time = 0.0
var initial_inside_density = 0.0
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
const hairRadius = 150
var hair_center = Vector2(1000, 300)

# Reference circle
var reference_radius = 0.0
var reference_offset = Vector2.ZERO

var move_x = 0

var play = false

func _ready():
	randomize()
	hair_center.y = get_viewport_rect().size.y / 2
	hair_center.x = get_viewport_rect().size.x
	move_x = - hair_center.x * 0.4
	# Hair strands setup
	for i in range(1000):
		var valid_position_found = false
		var hairStrandOffset = Vector2.ZERO
		var numTries = 0
		while not valid_position_found and numTries < 10:
			numTries += 1
			var angle = randf() * TAU
			var direction = Vector2(cos(angle), sin(angle))
			direction *= randf() * hairRadius
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
			"hair_color": base_color + Color(randf()*hair_color_variation, randf()*hair_color_variation, randf()*hair_color_variation)
		})

	# Reference circle
	reference_radius = hairRadius * (randf() * 0.4 + 0.4)
	var angle = randf() * TAU
	var direction = Vector2(cos(angle), sin(angle))
	reference_offset = direction * randf() * (hairRadius - reference_radius)

	# Initial densities
	var inside_count = 0
	var outside_count = 0
	for strand in hair_strands:
		var dist = strand["base_offset"].distance_to(reference_offset)
		if dist <= reference_radius:
			inside_count += 1
		else:
			outside_count += 1

	var inside_area = PI * reference_radius * reference_radius
	var outside_area = PI * hairRadius * hairRadius - inside_area

	initial_inside_density = inside_count / inside_area
	initial_outside_density = outside_count / outside_area

	start_movement_tween(set_done)
func set_done():
	play = !play
func complete_game():
	print("yeepie")
func start_movement_tween(callback):
	# Example wiggle + ease in sequence:
	var tween = create_tween()

	# EASE IN to the left
	var target1 = hair_center + Vector2(move_x, 0)
	tween.tween_property(self, "hair_center", target1, 1.0)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)

	# Quick tweaks
	tween.tween_property(self, "hair_center", hair_center + Vector2(move_x, 0) + Vector2(-100, 0), 0.05)
	tween.tween_property(self, "hair_center", hair_center + Vector2(move_x, 0) + Vector2(100, 0), 0.1)
	tween.tween_property(self, "hair_center", hair_center + Vector2(move_x, 0) + Vector2(-100, 0), 0.05)
	
	tween.tween_callback(callback)

func _process(delta):
	time += delta
	density_timer += delta

	var mouse_pos = get_viewport().get_mouse_position()

	# Cutting
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and play == true:
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

		# Damping + spring force
		velocity *= 0.98

		# Enforce max length
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

	# Densities
	if density_timer >= 0.5:
		density_timer = 0.0

		var inside_count = 0
		var outside_count = 0

		for strand in hair_strands:
			var dist = strand["base_offset"].distance_to(reference_offset)
			if dist <= reference_radius:
				inside_count += 1
			else:
				outside_count += 1

		var inside_area = PI * reference_radius * reference_radius
		var outside_area = PI * hairRadius * hairRadius - inside_area

		var inside_density = inside_count / inside_area
		var outside_density = outside_count / outside_area
		var outside_ratio = outside_density / initial_outside_density
		var inside_ratio = inside_density / initial_inside_density

		if outside_ratio <= 0.2 and inside_ratio >= 0.5:
			if move_x<0:
				play = false
				move_x = -move_x
				start_movement_tween(complete_game)
		elif inside_ratio < 0.5:
			show_green = false
			show_red = true
			var death_scene = preload("res://src/scenes/death/death.tscn")
			get_tree().change_scene_to_packed(death_scene)
		else:
			show_green = false
			show_red = false

	queue_redraw()

func _draw():
	draw_circle(hair_center + reference_offset, reference_radius, Color.DARK_GRAY)

	for strand in hair_strands:
		draw_line(
			hair_center + strand["base_offset"],
			hair_center + strand["tip_offset"],
			strand["hair_color"], 3
		)

	for strand in cut_hair_strands:
		var pos = strand["position"]
		var dir = strand["direction"].rotated(strand["angle"])
		var length = strand["length"]
		draw_line(pos, pos + dir * length, strand["hair_color"] + Color(0.3, 0.3, 0.3), 3)

	if show_green:
		draw_circle(hair_center + reference_offset, reference_radius, Color.SEA_GREEN)
	elif show_red:
		draw_circle(hair_center + reference_offset, reference_radius, Color.INDIAN_RED)
