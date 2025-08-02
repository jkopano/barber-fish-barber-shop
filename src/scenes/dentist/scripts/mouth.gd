extends Sprite2D

var mask_texture

var mouthMask = preload("res://place-holders/mouth-mask.png")

var pea = preload("res://src/scenes/dentist/pea.tscn")


var peas = []
var pressed = false

func spawn_entites(offset, entitiesToSpawn):
	randomize()
	var image = mouthMask.get_image()
	var color_pixels := []

	for y in image.get_height():
		for x in image.get_width():
			var color = image.get_pixel(x, y)
			if color.a > 0.0:
				color_pixels.append(Vector2i(x, y))
	
	
	var pixels = color_pixels
	for i in range(entitiesToSpawn):
		var chosen_pixel = pixels[randi() % pixels.size()]
		var peaBean = pea.instantiate()
		add_child(peaBean)
		peaBean.position = chosen_pixel - Vector2i(offset)
		peas.append(peaBean)
func _ready():
	spawn_entites(texture.get_size()/2, int(randf() * 3+2))

func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		pressed = true
	else:
		if pressed == true:
			for peaBean in peas:
				if peaBean.clean(60):
					peas.erase(peaBean)
		pressed = false
