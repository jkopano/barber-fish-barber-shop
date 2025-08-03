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

class GameData:
	var id: int
	var runs: Array[RunData]

	func _init():
		id = randi()
		new_run()

	func get_current_run():
		return runs[runs.size() - 1]

	func new_run():
		runs.push_front(RunData.new())



class RunData:
	var current_level: int = 0
	var levels: Array[LevelData]

	func _init():
		for x in range(20):
			levels.push_front(LevelData.new(x))

	func get_current():
		return levels[current_level]
	
	func next_shrek():
		if get_current().current_shrek_number + 1 >= get_current().shrek_amount:
			current_level += 1
		else:
			get_current().current_shrek_number += 1




class LevelData:
	var id: int
	var current_shrek_number: int = 1
	var shrek_amount: int = 3
	var points: int = 100

	func _init(_id):
		id = _id

var game: GameData

var player_data = {
	pos = Vector2(0, 0),
	frame = 1,
}

func new_run():
	time_elapsed = 0
	player_data = null
	game.new_run()

var has_ever_visited_after_death_scene := false
var has_ever_visited_main_room := false
