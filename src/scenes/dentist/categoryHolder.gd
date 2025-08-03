extends MiniGame

var category = "yellow"
func getCategory():
	return category
func setCategory(newCategory:String):
	category = newCategory

var peasDone = false
var greenYellowDonw = false

var playing_anim = false
func _process(delta: float) -> void:
	if peasDone and greenYellowDonw:
		if not playing_anim:
			playing_anim = true
			for child in get_children():
				if child.name == "TRANS":
					child.play_anim(exit_game, 0.1)
