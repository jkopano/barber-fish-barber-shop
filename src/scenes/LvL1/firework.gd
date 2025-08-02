extends Sprite2D

@onready var fireworks = [
	get_parent().get_node("Firework1"),
	get_parent().get_node("Firework2"),
	get_parent().get_node("Firework3"),
	get_parent().get_node("Firework4"),
	get_parent().get_node("Firework5"),
	get_parent().get_node("Firework6")
]
var base = self
var tween = create_tween()

func _ready():
	for firework in fireworks:
		firework.visible = false
		firework.scale = Vector2(2,2)
		
	if Globals.has_ever_visited_main_room:
		
		tween.tween_property(self,"position:y",-150,0.75)
		tween.connect("finished", Callable(self, "_on_fireworkbase_tween_finished"))
		
func _on_fireworkbase_tween_finished():
	var radius = 100.0  # jak daleko leci fajerwerk
	var angle_step = 60  # co ile stopni
	var center = Vector2(position.x + 5,position.y)

	for i in range(fireworks.size()):
		var firework = fireworks[i]
		var angle_deg = i * angle_step
		var angle_rad = deg_to_rad(angle_deg)

		var offset = Vector2(cos(angle_rad), sin(angle_rad)) * radius
		var target_position = center + offset

		firework.position = center
		firework.visible = true
		firework.play("fire")

		var tween = create_tween()
		tween.tween_property(firework, "position", target_position, 1.0)
		tween.connect("finished", Callable(self, "_on_firework_tween_finished").bind(firework))
		
func _on_firework_tween_finished(firework):
	firework.queue_free()
	self.queue_free()
