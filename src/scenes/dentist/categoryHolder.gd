extends MiniGame

var category = "yellow"
func getCategory():
	return category
func setCategory(newCategory:String):
	category = newCategory

var peasDone = false
var greenYellowDonw = false

func _process(delta: float) -> void:
	if peasDone and greenYellowDonw:
		exit_game()
