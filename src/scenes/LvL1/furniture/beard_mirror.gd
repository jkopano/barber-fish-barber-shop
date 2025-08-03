extends Sprite2D

var to_be_picked = false

func _ready():
	$Point.visible = false

func _on_tilemap_shark_needs_beard() -> void:
	$Point.visible = true
	to_be_picked = true
