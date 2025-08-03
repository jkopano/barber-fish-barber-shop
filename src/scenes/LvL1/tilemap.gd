extends Node2D

signal swap_scene(scene: PackedScene)

signal shark_needs_barber()
signal shark_needs_drink()
signal shark_needs_denstist()

var shark = preload("res://src/scenes/LvL1/shark/shark.tscn")

func _init() -> void:
	if not Globals.game:
		Globals.game = Globals.GameData.new()

func _ready() -> void:
	var shark_instance = shark.instantiate()
	$Sharks.add_child(shark_instance)
	Globals.has_ever_visited_main_room = true


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

func _on_player_fish_interact_furniture(scene:PackedScene) -> void:
	Globals.player_data.pos = %Player.position
	Globals.player_data.frame = %Player/Fish.frame
	print(Globals.player_data.pos)
	get_tree().change_scene_to_packed(scene)
