extends Node2D

var mask_texture

var mouthMask = preload("res://img/mouth-mask.png")


var peas = []

func spawn_entites(entitiesToSpawn):
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
		var rock = redRock.instantiate()
		object.add_child(rock)
		rock.position = chosen_pixel - Vector2i(offset)
		redRocks.append(rock)
func _ready():
	var yellowToGenerate = get_child_count()
	var redToGenerate = get_child_count()
		
	
	for child in get_children():
		if child is Sprite2D:
			var texture = child.texture
			if texture and texture is Texture2D:
				var file_path = texture.resource_path
				var origin = child.transform.get_origin()
				file_path = file_path.split("/")[-1];
				file_path = file_path.substr(0, file_path.length() - 4)
				spawn_entites(file_path, child, texture.get_size()/2, int(randf() * 3), int(randf() * 3))
				
func switchCollectingCategory(category):
	collectingCategory = category
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if (collectingCategory == "yellow"):
			for rock in yellowRocks:
				if rock.clean():
					yellowRocks.erase(rock)
		elif (collectingCategory == "red"):
			for rock in redRocks:
				if rock.clean():
					redRocks.erase(rock)
