extends Sprite2D

var playing = false

func _init():
	return
	#visible = false
func _ready() -> void:
	#visible = false
	position = Vector2(0,0)
	scale = Vector2(1, 1) * 50
	play_anim()
 
func set_vis():
	return
func play_anim():
	visible = true
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.tween_callback(set_vis)
