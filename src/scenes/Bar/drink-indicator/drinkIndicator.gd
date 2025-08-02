extends Node2D

@export var drink_texture: Texture2D:
	set(value):
		drink_texture = value
		$Cloud/DrinkSprite.texture = value
		
func set_drink_texture(texture: Texture2D):
	drink_texture = texture
	$Cloud/DrinkSprite.texture = texture
