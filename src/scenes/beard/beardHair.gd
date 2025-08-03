extends Node2D

# === CONFIG ===
const NUM_VINES := 10
const NUM_EDGES := 40
const VINE_LENGTH := 200.0
const GRAVITY := Vector2(0, 500)
const DAMPING := 0.99
const CONSTRAINT_ITERATIONS := 10
const LINE_LEGHT := 100

const REPULSION_RADIUS := 10.0
const REPULSION_STRENGTH := 700.0

const forgivness = 0.1

var one_bone_length = VINE_LENGTH / (NUM_EDGES - 1)

# === INTERNAL DATA ===
var vines = []             # Active vines still attached
var falling_vines = []     # Cut pieces falling with rotation

var where_to_cut_vines = []

const POSSIBLE_VERSIONS = 4
var last_mouse_pos = Vector2()

func get_where_to_cut(vineNum, functionType, offsetArg, variationArg):
	var offset = offsetArg * NUM_EDGES
	var variation = variationArg * NUM_EDGES
	var twox = 2*(float(vineNum) / float(NUM_VINES))
	if functionType == 0:
		return offset
	elif functionType == 1:
		var quad = (twox-1)*(twox-1)
		return int(offset - quad  * variation)
	elif functionType == 2:
		var cub = pow(twox-1, 3) * 0.5 + 0.5
		return int(offset - cub  * variation)
	return 0

func _ready():
	randomize()
	var funType =  int(POSSIBLE_VERSIONS * randf())
	
	var min_a = 0.4
	var min_b = 0.2
	var total_max = 1.0

	var max_a = total_max - min_b  # So B can still be at least min_b
	var a = randf_range(min_a, max_a)

	var max_b = min(a, total_max - a)
	var b = randf_range(min_b, max_b)


	for i in range(NUM_VINES):
		var vine = []
		var positions = []
		var prev_positions = []
		var edge_to_cut = 0
		var start_x = i * (LINE_LEGHT / NUM_VINES)
		for j in range(NUM_EDGES):
			var pos = Vector2(start_x + 2.5 * j, j * one_bone_length)
			positions.append(pos)
			prev_positions.append(pos)
		edge_to_cut = get_where_to_cut(i,1, a, b)
		where_to_cut_vines.append(edge_to_cut)
		vine.append(positions)
		vine.append(prev_positions)
		vines.append(vine)

	last_mouse_pos = get_viewport().get_mouse_position()


func _physics_process(delta):
	var mouse_pos = get_viewport().get_mouse_position()

	# Update active vines
	for vine in vines:
		var positions = vine[0]
		var prev_positions = vine[1]

		for i in range(1, positions.size()):
			var vel = (positions[i] - prev_positions[i]) * DAMPING
			prev_positions[i] = positions[i]
			positions[i] += vel
			positions[i] += GRAVITY * delta * delta

			# Repulsion
			var to_mouse = position + positions[i] - mouse_pos
			var dist = to_mouse.length()
			if dist < REPULSION_RADIUS:
				var repulsion = to_mouse.normalized() * (REPULSION_RADIUS - dist) * REPULSION_STRENGTH * delta * delta
				positions[i] += repulsion

		# Fix first point
		positions[0] = Vector2(positions[0].x, 0)
		prev_positions[0] = positions[0]

		# Apply constraints
		for _i in range(CONSTRAINT_ITERATIONS):
			for j in range(1, positions.size()):
				var dir = positions[j] - positions[j - 1]
				var dist = dir.length()
				var diff = (dist - one_bone_length) / dist if dist != 0 else 0
				dir = dir.normalized()
				if j != 1:
					positions[j - 1] += dir * 0.5 * diff * one_bone_length
				positions[j] -= dir * 0.5 * diff * one_bone_length

			positions[0] = Vector2(positions[0].x, 0)

	# Update falling vines (apply gravity and rotation)
	for falling in falling_vines:
		var positions = falling.positions
		var velocities = falling.velocities
		var angular_velocity = falling.angular_velocity

		# Update each point position using velocity
		for i in range(positions.size()):
			velocities[i] += GRAVITY * delta
			positions[i] += velocities[i] * delta

		# Update rotation
		falling.rotation += angular_velocity * delta

	# Cutting
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		cut_vines(last_mouse_pos, mouse_pos)

	last_mouse_pos = mouse_pos

	queue_redraw()

func cut_vines(from_pos, to_pos):
	var new_vines = []
	for vine in vines:
		var positions = vine[0]
		var prev_positions = vine[1]
		var cut_index = -1

		for i in range(positions.size() - 1):
			var a = position + positions[i]
			var b = position + positions[i + 1]

			if segments_intersect(from_pos, to_pos, a, b):
				cut_index = i + 1
				break

		if cut_index != -1:
			# Split the vine into two parts: attached and falling
			var attached_positions = positions.slice(0, cut_index)
			var attached_prev_positions = prev_positions.slice(0, cut_index)

			if attached_positions.size() >= 2:
				new_vines.append([attached_positions, attached_prev_positions])

			# The cut part falls
			var falling_positions = positions.slice(cut_index, positions.size())
			var falling_prev_positions = prev_positions.slice(cut_index, prev_positions.size())
			if falling_positions.size() >= 2:
				# Prepare velocities (initial velocity = previous position difference)
				var velocities = []
				for i in range(falling_positions.size()):
					velocities.append(falling_positions[i] - falling_prev_positions[i])

				# Add random angular velocity for rotation effect
				var falling_data = {
					"positions": falling_positions,
					"velocities": velocities,
					"rotation": 0.0,
					"angular_velocity": randf_range(-5, 5)
				}
				falling_vines.append(falling_data)
		else:
			new_vines.append(vine)

	vines = new_vines

func segments_intersect(p1, p2, q1, q2):
	var r = p2 - p1
	var s = q2 - q1
	var rxs = r.cross(s)
	var qp = q1 - p1
	var t = qp.cross(s) / rxs if rxs != 0 else 0
	var u = qp.cross(r) / rxs if rxs != 0 else 0
	return (rxs != 0 and 0 <= t and t <= 1 and 0 <= u and u <= 1)
func check_if_complete():
	var result = "complete"
	for hjk in range(len(vines)):
		var vine = vines[hjk]
		var lastVineIndex = vine[0].size() - 1
		var where =  where_to_cut_vines[hjk]
		var missing = abs(lastVineIndex - where)
		var fogiving_value = int(forgivness * NUM_EDGES)
		if (missing>fogiving_value):
			if lastVineIndex < where:
				result = "impossible"
			elif result != "impossible":
				result = "not yet"
	return result
	
const DefaultColor = Color.DARK_CYAN
const CutColor = Color.RED
const hairWidth = 4
func _draw():
	# Draw active vines
	for hjk in range(len(vines)):
		var vine = vines[hjk]
		var positions = vine[0]
		for i in range(positions.size() - 1):
			var color = DefaultColor
			if (i>where_to_cut_vines[hjk]):
				color = CutColor
			draw_line(positions[i], positions[i + 1], color, hairWidth)

	# Draw falling vines with rotation applied
	for falling in falling_vines:
		var positions = falling.positions
		var center = Vector2()
		for pos in positions:
			center += pos
		center /= positions.size()

		var angle = falling.rotation

		for i in range(positions.size() - 1):
			# Rotate points around center
			var p1 = positions[i] - center
			var p2 = positions[i + 1] - center

			var rp1 = Vector2(
				p1.x * cos(angle) - p1.y * sin(angle),
				p1.x * sin(angle) + p1.y * cos(angle)
			) + center

			var rp2 = Vector2(
				p2.x * cos(angle) - p2.y * sin(angle),
				p2.x * sin(angle) + p2.y * cos(angle)
			) + center

			draw_line(rp1, rp2, DefaultColor, hairWidth)


func _process(delta: float) -> void:
	position.x += 10 * delta
	var res = check_if_complete()
	if res == "complete":
		get_parent().on_finish_game()
	elif res == "impossible":
		var death_scene = preload("res://src/scenes/death/death-with-animation/death.tscn")
		get_tree().change_scene_to_packed(death_scene)
