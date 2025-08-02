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

var time_elapsed = 0

var serializeData = {
	pos = Vector2(0, 0),
	frame = 1,
	level = 1,
	time = 0,
}
var has_ever_visited_after_death_scene := false

var has_ever_visited_main_room := false
