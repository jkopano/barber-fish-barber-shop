extends Node2D

var shark = preload("res://src/scenes/shark/shark.tscn")

func _ready() -> void:
	var shark_instance = shark.instantiate()
	$Sharks.add_child(shark_instance)


func _on_player_fish_interact() -> void:
	$Sharks.get_child(0).get_node("Need").queue_free()
