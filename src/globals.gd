extends Node

enum Need {
	HAIR,
	DRINK,
	TEETH
}

enum State {
	MENU,
	PLAYING,
	PAUSED,
	BARBER,
	BARMAN,
	DENTIST,
}

var serializeData = {
	pos = Vector2(0, 0),
	frame = 1,
	level = 1,
	time = 0,
}
var has_ever_visited_after_death_scene := false
