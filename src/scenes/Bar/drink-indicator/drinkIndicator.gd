extends Node2D

@export var drink_texture: Texture2D:
	set(value):
		drink_texture = value
		$Cloud/DrinkSprite.texture = value
		$Cloud/DrinkSprite.modulate = Color(0.5, 0.5, 0.5, 1.0)
		
func set_drink_texture(texture: Texture2D):
	drink_texture = texture
	$Cloud/DrinkSprite.texture = texture
	$Cloud/DrinkSprite.modulate = Color(0.4, 0.4, 0.4, 1.0)
