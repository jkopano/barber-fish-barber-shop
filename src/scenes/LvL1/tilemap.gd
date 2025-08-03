extends Node2D


@export var shrek_amount = 1
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
var shark_leaving = preload("res://src/scenes/LvL1/shark/shark_leaving.tscn")

func _init() -> void:
	if not Globals.game:
		Globals.game = Globals.GameData.new()
		Globals.time = time
		
	match Globals.game.get_current_run().current_level:
		0:
			Globals.time = 60
			Globals.game.get_current_run().get_current().shrek_amount = 3
		1:
			Globals.time = 55
			Globals.game.get_current_run().get_current().shrek_amount = 3
		2:
			Globals.time = 50
			Globals.game.get_current_run().get_current().shrek_amount = 4
		3:
			Globals.time = 45
			Globals.game.get_current_run().get_current().shrek_amount = 4
		4:
			Globals.time = 40
			Globals.game.get_current_run().get_current().shrek_amount = 5
		5:
			Globals.time = 35
			Globals.game.get_current_run().get_current().shrek_amount = 5
		6:
			Globals.time = 30
			Globals.game.get_current_run().get_current().shrek_amount = 6
		7:
			Globals.time = 25
			Globals.game.get_current_run().get_current().shrek_amount = 6
		8:
			Globals.time = 20
			Globals.game.get_current_run().get_current().shrek_amount = 6
		9:
			Globals.time = 15
			Globals.game.get_current_run().get_current().shrek_amount = 6

func _ready() -> void:
	print(Globals.game.get_current_run().current_level)
	print(Globals.game.get_current_run().get_current().current_shrek_number)

	var shrek_number = Globals.game.get_current_run().get_current().current_shrek_number
	var shark_amount = Globals.game.get_current_run().get_current().shrek_amount
	var shark_instance = shark.instantiate()

	$Sharks.add_child(shark_instance)
	if Globals.game.get_current_run().get_current().current_shrek_number == 1:
		add_child(level_popup.instantiate())

	if Globals.game.get_current_run().get_current().current_shrek_number != 1:
		$Sharks.add_child(shark_leaving.instantiate())

	Globals.has_ever_visited_main_room = true

	$SharksLeft.text = "Sharks Left " + str( shark_amount - shrek_number + 1 ) + "/" + str( shark_amount )
	


	if Globals.game.get_current_run().get_current().current_shrek_number == 1:
		Globals.time_elapsed = 0



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
