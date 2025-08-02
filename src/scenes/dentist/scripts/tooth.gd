extends Node2D

var mask_texture

var yellowRock = preload("res://src/scenes/dentist/yellowRock.tscn")
var redRock = preload("res://src/scenes/dentist/redRock.tscn")

var collectingCategory = "yellow"

var yellowRocks = []
var redRocks = []

func spawn_entites(texture_name:String, object:Sprite2D, offset, redEntitiesToSpawn, yellowEntitiesToSpawn):
	randomize()
	var path = "res://img/"+texture_name+"-mask.png"
	mask_texture = load(path)
	var image = mask_texture.get_image()
	var color_pixels := {}

	for y in image.get_height():
		for x in image.get_width():
			var color = image.get_pixel(x, y)
			if color.a > 0.0:
				if not color_pixels.has(color):
					color_pixels[color] = []
				color_pixels[color].append(Vector2i(x, y))
	
	
	for color in color_pixels.keys():
		var pixels = color_pixels[color]
		if color == Color(1, 0, 0):
			for i in range(redEntitiesToSpawn):
				var chosen_pixel = pixels[randi() % pixels.size()]
				var rock = redRock.instantiate()
				object.add_child(rock)
				rock.position = chosen_pixel - Vector2i(offset)
				redRocks.append(rock)
		elif color == Color(1, 1, 0):
			for i in range(yellowEntitiesToSpawn):
				var chosen_pixel = pixels[randi() % pixels.size()]
				var rock = yellowRock.instantiate()
				object.add_child(rock)
				rock.position = chosen_pixel - Vector2i(offset)
				yellowRocks.append(rock)
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
