extends CharacterBody2D

@export var speed = 10

func _process(dt: float) -> void:
	var input = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	var direction = cart_to_iso(input)

	velocity = direction * 5000 * dt
	move_and_slide()

func cart_to_iso(vec: Vector2) -> Vector2:
	return Vector2(vec.x - vec.y, (vec.x + vec.y) / 2)
