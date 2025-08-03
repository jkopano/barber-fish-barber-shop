class_name MiniGame extends Node2D

func exit_game():
	Globals.game.get_current_run().next_shrek()
	
	get_tree().change_scene_to_file("res://src/scenes/LvL1/tilemap.tscn")
