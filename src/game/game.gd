extends Node2D


func return_to_main():
	Globals.serializeData.level += 1

	var old_node = get_node("Deck")
	remove_child(old_node)
	old_node.queue_free()

	var new_node_scene = load("res://src/scenes/LvL1/tilemap.tscn")
	var new_node = new_node_scene.instantiate()
	add_child(new_node)

