extends CharacterBody2D

@export var speed = 10

signal fish_interact

func _process(dt: float) -> void:
	move(dt)
	interact()

func cart_to_iso(vec: Vector2) -> Vector2:
	return Vector2(vec.x, vec.y / 2)

func interact():
	print("inteacted")
	emit_signal("fish_interact")

func move(dt):
	var input = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	var direction = cart_to_iso(input)
	choose_anim(input)

	velocity = direction * 5000 * dt

	move_and_slide()











func choose_anim(vec: Vector2) -> void:
	if vec == Vector2.UP:
		$Fish.frame = 1
	if vec == Vector2.RIGHT:
		$Fish.frame = 5
	if vec == Vector2.LEFT:
		$Fish.frame = 3
	if vec == Vector2.DOWN:
		$Fish.frame = 7
	if vec == ( Vector2.UP + Vector2.LEFT ).normalized():
		$Fish.frame = 0
	if vec == ( Vector2.UP + Vector2.RIGHT ).normalized():
		$Fish.frame = 2
	if vec == ( Vector2.DOWN + Vector2.LEFT ).normalized():
		$Fish.frame = 6
	if vec == ( Vector2.DOWN + Vector2.RIGHT ).normalized():
		$Fish.frame = 8
