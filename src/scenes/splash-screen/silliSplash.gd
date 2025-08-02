extends Node


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_start_pressed() -> void:
	var main_scene = preload("res://src/scenes/LvL1/tilemap.tscn")
	get_tree().change_scene_to_packed(main_scene)
