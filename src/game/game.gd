extends Node2D

# var main_scene = preload("res://src/scenes/LvL1/tilemap.tscn")

func _on_tilemap_swap_scene(scene:PackedScene) -> void:
	get_tree().change_scene_to_packed(scene)
