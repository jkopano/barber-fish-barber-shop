extends Node2D

var a_need: String
var id: int

func _ready():
	a_need = Globals.Need.keys()[randi() % Globals.Need.size()]

func _process(_dt):

	pass
