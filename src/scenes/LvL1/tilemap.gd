extends Node2D

signal shark_needs_barber()
signal shark_needs_drink()
signal shark_needs_denstist()

var shark = preload("res://src/scenes/LvL1/shark/shark.tscn")

func _ready() -> void:
	var shark_instance = shark.instantiate()
	$Sharks.add_child(shark_instance)


func interact_with_shark() -> void:
	if $Sharks.get_child(0).a_need == "DRINK":
		shark_needs_drink.emit()
	if $Sharks.get_child(0).a_need == "HAIR":
		shark_needs_barber.emit()
	if $Sharks.get_child(0).a_need == "TEETH":
		shark_needs_denstist.emit()

	$Sharks.get_child(0).get_node("Need").queue_free()


func _on_player_fish_interact() -> void:
	interact_with_shark()

