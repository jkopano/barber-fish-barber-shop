extends AnimatedSprite2D

const spawn = Vector2(-100, 400)
const final = Vector2(500, 400)
var move_x = final.x - spawn.x

func start_movement_tween():
	var tween = create_tween()
	var target1 = spawn + Vector2(move_x, 0)
	tween.tween_property(self, "position", target1, 1.0)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)

	tween.tween_property(self, "position", target1+ Vector2(-100, 0), 0.05)
	tween.tween_property(self, "position", target1 + Vector2(100, 0), 0.1)
	tween.tween_property(self, "position", target1 + Vector2(-100, 0), 0.05)


func _ready() -> void:
	play("sad")
	start_movement_tween()

func on_complete():
	play("happi")
	get_parent().on_finish_game()
