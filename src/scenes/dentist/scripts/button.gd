extends Button

var max_y = -50
var default_position = Vector2.ZERO

var play_anim = 0
var max_anim_time = 1.0
var anim_time = 0.

var selected = 0

var isSelected = false


func unSelected():
	if isSelected:
		play_anim = -1
		isSelected = false
func switchCategory():
	self.get_parent().setCategory(name)
	for child in self.get_parent().get_children():
		if child.name == "mouse following":
			child.playAnim(name)
	if (not isSelected):
		play_anim = 1
	isSelected = true
	for child in get_parent().get_children():
		if child is Button and child.name != name:
			child.unSelected();
func _ready() -> void:
	if name == "yellow":
		switchCategory()
	default_position = position
	self.pressed.connect(switchCategory)
func _process(delta: float) -> void:
	if play_anim != 0:
		anim_time += delta
		if anim_time > max_anim_time:
			if play_anim == 1:
				selected = 1
			elif play_anim == -1:
				selected = 0
			play_anim = 0
			anim_time = 0.

	var t: float = clamp(anim_time / max_anim_time, 0.0, 1.0)
	var ease_out: float = 1.0 - pow(1.0 - t, 2)
	position.y = default_position.y + (ease_out * max_y*play_anim) + (selected * max_y)
