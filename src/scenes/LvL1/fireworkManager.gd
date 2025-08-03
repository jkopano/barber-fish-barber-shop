extends Node

@export var firework_scene: PackedScene
var rng = RandomNumberGenerator.new()

func _ready():
	if Globals.has_ever_visited_main_room:
		spawn_fireworks(self.position)
		
func spawn_fireworks(position):
	for i in range(5):
		var wait_time = rng.randf_range(0.0, 0.5)
		await get_tree().create_timer(wait_time).timeout
		var firework = firework_scene.instantiate()
		add_child(firework)
		firework.start_fire(position + Vector2(100 * i, 0))
