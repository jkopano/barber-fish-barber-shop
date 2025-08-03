extends AnimatedSprite2D

var fireworks = []
var base = self

func _ready():
	for i in range(1,7):
		var firework = get_parent().get_node_or_null("Firework%d" % i)
		if firework:
			fireworks.append(firework)
		else:
			print("no node for Firework%d" % i)

func start(position: Vector2):
	print("got signal in firework")
	
	for firework in fireworks:
		firework.visible = false
		firework.scale = Vector2(2,2)
		
	self.visible = true
	self.play("start")
	self.position = position
	var tween = create_tween()
	tween.tween_property(self,"position:y",-200,0.75)
	tween.connect("finished", Callable(self, "_on_fireworkbase_tween_finished"))
		
func _on_fireworkbase_tween_finished():
	print("got explosion signal")
	self.visible = false
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
		firework.rotation = angle_rad
		firework.visible = true
		firework.play("fire")

		var tween = create_tween()
		tween.tween_property(firework, "position", target_position, 1.0)
		tween.connect("finished", Callable(self, "_on_firework_tween_finished").bind(firework))
		
func _on_firework_tween_finished(firework):
	firework.queue_free()
	self.queue_free()
