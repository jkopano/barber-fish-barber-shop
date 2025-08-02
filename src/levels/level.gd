extends Node2D

var shark = preload("res://src/scenes/shark/shark.tscn")

func _ready() -> void:
	var shark_instance = shark.instantiate()
	$Sharks.add_child(shark_instance)
