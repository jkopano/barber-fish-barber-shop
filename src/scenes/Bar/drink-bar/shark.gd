extends Area2D

var moving := false
var speed := 500
var chosen_drink = null

@export var drink_indicator_scene : PackedScene

var drink_indicator_instance = null

func _ready():
	randomize()
	
	var viewport_size = get_viewport_rect().size
	position = Vector2(800, 0)

	var shark_size = Vector2(667, 595)
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(-200 , 0), 1.0)\
	.set_trans(Tween.TRANS_EXPO)\
	.set_ease(Tween.EASE_IN)
	
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(self, "position", Vector2(-290,0), 0.05)
	tween.tween_property(self, "position", Vector2(-210,0), 0.1)
	tween.tween_property(self, "position", Vector2(-250,0), 0.05)
	
	var drinks = get_tree().get_nodes_in_group("Drinks")
	if drinks.size() == 0:
		print("No drinks")
		return
		
	chosen_drink = drinks[randi() % drinks.size()]
	
	if drink_indicator_scene:
		drink_indicator_instance = drink_indicator_scene.instantiate()
		add_child(drink_indicator_instance)
		drink_indicator_instance.position = Vector2(400, -300)

		var drink_sprite = chosen_drink.get_node_or_null("Sprite2D")
		if drink_sprite:
			drink_indicator_instance.set_drink_texture(drink_sprite.texture)
	
	connect("area_entered", Callable(self, "_on_Shark_area_entered"))

func start_moving():
	var target_x = -get_viewport_rect().size.x - 200
	var distance = position.x - target_x
	var duration = distance / speed
	
	var tween = create_tween()
	tween.tween_property(self, "position:x", target_x, duration)\
		.set_trans(Tween.TRANS_EXPO)\
		.set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(Callable(self, "queue_free"))
		
func _on_drink_dropped(drink):
	if drink == chosen_drink:
		if drink_indicator_instance:
			drink_indicator_instance.queue_free()
		start_moving()
		drink.queue_free()
	else:
		var death_scene = preload("res://src/scenes/death/death.tscn")
		get_tree().change_scene_to_packed(death_scene)	
		
	
