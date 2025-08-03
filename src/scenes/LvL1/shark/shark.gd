extends Node2D
class_name Shark

var tooth_bubble = preload("res://sprites/levels/brush-dymek.png")
var drink_bubble = preload("res://sprites/levels/winkoi-dymek.png")
var brush_bubble = preload("res://sprites/levels/nozycki-dymek.png")
var broda_bubble = preload("res://sprites/levels/dymek-maszynka.png")

var changer = preload("res://src/scenes/LvL1/level_changer.tscn")

var a_need: String
var id: int

func _ready():
	a_need = Globals.Need.keys()[randi() % Globals.Need.size()]

	if Globals.game.get_current_run().get_current().current_shrek_number > 1:
		var changer_instance = changer.instantiate()
		add_child(changer_instance)

	if a_need == "DRINK":
		$Need.texture = drink_bubble
	elif a_need == "HAIR":
		$Need.texture = brush_bubble
	elif a_need == "TEETH":
		$Need.texture = tooth_bubble
	elif a_need == "BEARD":
		$Need.texture = broda_bubble


func _process(_dt):

	pass

func interact():
	if $Need:
		$Need.queue_free()
