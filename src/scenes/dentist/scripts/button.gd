extends Button

var max_y = -50
var default_position = Vector2.ZERO

var play_anim = 0  # -1 = down, 1 = up
var max_anim_time = 1.0
var anim_time = 0.0

var isSelected = false

func unSelected():
	if isSelected:
		isSelected = false
		play_anim = -1
		anim_time = 0.0  # reset anim time

func switchCategory():
	if isSelected:
		return
	get_parent().setCategory(name)
	for child in get_parent().get_children():
		if child.name == "mouse following":
			child.playAnim(name)
	for child in get_parent().get_children():
		if child is Button and child != self:
			child.unSelected()
	isSelected = true
	play_anim = 1
	anim_time = 0.0

func _ready() -> void:
	focus_mode = Control.FOCUS_NONE
	if name == "yellow":
		switchCategory()
	default_position = position
	pressed.connect(switchCategory)

func _process(delta: float) -> void:
	if play_anim != 0:
		anim_time += delta
		if anim_time >= max_anim_time:
			play_anim = 0
			anim_time = 0.0

	var t = clamp(anim_time / max_anim_time, 0.0, 1.0)
	var ease = 1.0 - pow(1.0 - t, 2)

	var offset = 0.0
	if play_anim == 1:
		offset = ease * max_y
	elif play_anim == -1:
		offset = (1.0 - ease) * max_y
	elif isSelected:
		offset = max_y
	else:
		offset = 0.0

	position.y = default_position.y + offset
