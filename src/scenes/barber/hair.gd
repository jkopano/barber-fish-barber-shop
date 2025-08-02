extends Node2D

var hair_strands = []
var cut_hair_strands = []
var time = 0.0
var initial_inside_density = 0.0
var initial_outside_density = 0.0
var show_green = false
var show_red = false
var density_timer = 0.0
var movingVelocity = Vector2.ZERO


# general
const gravity = Vector2(0, 150)
const repulsion_radius = 60
const repulsion_strength = 1500
const min_distance_between_hair = 10

# Main circle
const hairRadius = 200
var hair_center = Vector2(500, 300)

# Reference circle
var reference_radius = hairRadius * (randf() * 0.4 + 0.4)
var reference_offset = Vector2.ZERO

func _ready():
	randomize()
	movingVelocity = Vector2(30, 0)
	# Hair strands
	for i in range(1500):
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
			"velocity": Vector2.ZERO
		})

	# Reference circle
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

func _process(delta):
	time += delta
	density_timer += delta

	hair_center += movingVelocity * delta

	var mouse_pos = get_viewport().get_mouse_position()

	# Cutting
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
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
					"direction": (strand["tip_offset"] - strand["base_offset"]).normalized()
				}
				cut_hair_strands.append(cut_strand)
				hair_strands.remove_at(i)

	# Hair
	for strand in hair_strands:
		var base = strand["base_offset"]
		var tip = strand["tip_offset"]
		var velocity = strand["velocity"]

		# Gravity
		velocity += gravity * delta

		# Repulsion
		var dist_to_mouse = (hair_center + tip).distance_to(mouse_pos)
		if dist_to_mouse < repulsion_radius:
			var dir = ((hair_center + tip) - mouse_pos).normalized()
			var force = dir * (repulsion_strength * (1.0 - dist_to_mouse / repulsion_radius))
			velocity += force * delta

		# Integrate
		tip += velocity * delta

		# Spring
		var spring = movingVelocity * -2.0
		velocity += spring * delta

		# Damping
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

	# Simulate cut hairs
	for strand in cut_hair_strands:
		strand["velocity"] += gravity * delta
		strand["position"] += strand["velocity"] * delta
		strand["angle"] += strand["angular_velocity"] * delta

	# Check densities
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
			show_green = true
			show_red = false
		elif inside_ratio < 0.5:
			show_green = false
			show_red = true
		else:
			show_green = false
			show_red = false

	queue_redraw()

func _draw():
	# Outer hair area
	draw_circle(hair_center, hairRadius, Color.BLACK)

	# Reference circle
	draw_circle(hair_center + reference_offset, reference_radius, Color.DARK_GRAY)

	# Hair strands
	for strand in hair_strands:
		draw_line(
			hair_center + strand["base_offset"],
			hair_center + strand["tip_offset"],
			Color.SADDLE_BROWN, 3
		)

	# Cut hairs
	for strand in cut_hair_strands:
		var pos = strand["position"]
		var dir = strand["direction"].rotated(strand["angle"])
		var length = strand["length"]
		draw_line(pos, pos + dir * length, Color.DARK_GOLDENROD, 3)

	if show_green:
		draw_circle(hair_center + reference_offset, reference_radius, Color.SEA_GREEN)
	elif show_red:
		draw_circle(hair_center + reference_offset, reference_radius, Color.INDIAN_RED)
