extends Node

func _ready():
	Globals.game = Globals.GameData.new()
	Globals.has_ever_visited_after_death_scene = false
	Globals.has_ever_visited_main_room = false

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_start_pressed() -> void:
	Globals.new_run()
	get_tree().change_scene_to_file("res://src/scenes/LvL1/tilemap.tscn")
