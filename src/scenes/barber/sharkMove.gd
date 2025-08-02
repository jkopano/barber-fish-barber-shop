extends Sprite2D

func _process(delta: float) -> void:
	position = get_parent().get_child(2).hair_center
