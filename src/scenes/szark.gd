extends Sprite2D

var playing = false

func _init():
	visible = false
func _ready() -> void:
	visible = false
	position = get_viewport().size / 2
	scale = Vector2(1, 1)
 
func play_anim(callback):
	visible = true
	var tween = create_tween()
	tween.tween_property(self, "scale", scale * 10., .5)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", scale * 50., .5)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_callback(callback)
