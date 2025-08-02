class_name MiniGame extends Node2D

func exit_game():
	Globals.serializeData.level += 1

	get_tree().change_scene_to_file("res://src/scenes/LvL1/tilemap.tscn")
