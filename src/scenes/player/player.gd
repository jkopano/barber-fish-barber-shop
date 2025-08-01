extends CharacterBody2D

func _process(_dt: float) -> void:
	var direction = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")

	velocity = direction * 500
	move_and_slide()
