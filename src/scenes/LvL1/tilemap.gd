extends Node2D

@export var shrek_amount = 3
@export var current_shark = 1
@export var time = 60
@export var points = 100

signal swap_scene(scene: PackedScene)

signal shark_needs_barber()
signal shark_needs_drink()
signal shark_needs_denstist()
signal shark_needs_beard()

var shark = preload("res://src/scenes/LvL1/shark/shark.tscn")
var level_popup = preload("res://src/scenes/LvL1/level_changer.tscn")

func _init() -> void:
	if not Globals.game:
		Globals.game = Globals.for_bubert(shrek_amount, current_shark, time, null)
		Globals.time = time

func _ready() -> void:
	var shark_instance = shark.instantiate()
	$Sharks.add_child(shark_instance)
	if Globals.game.get_current_run().get_current().current_shrek_number == 1:
		add_child(level_popup.instantiate())
	Globals.has_ever_visited_main_room = true



func interact_with_shark() -> void:
	if $Sharks.get_child(0).a_need == "DRINK":
		shark_needs_drink.emit()
	if $Sharks.get_child(0).a_need == "HAIR":
		shark_needs_barber.emit()
	if $Sharks.get_child(0).a_need == "TEETH":
		shark_needs_denstist.emit()
	if $Sharks.get_child(0).a_need == "BEARD":
		shark_needs_beard.emit()

	$Sharks.get_child(0).get_node("Need").queue_free()


func _on_player_fish_interact() -> void:
	interact_with_shark()

func _on_player_fish_interact_furniture(scene:PackedScene) -> void:
	Globals.player_data.pos = %Player.position
	Globals.player_data.frame = %Player/Fish.frame
	print(Globals.player_data.pos)
	get_tree().change_scene_to_packed(scene)
