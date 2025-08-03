extends Node2D

func _ready():
	var shrek_number = Globals.game.get_current_run().get_current().current_shrek_number
	var shrek_amount = Globals.game.get_current_run().get_current().shrek_amount
	var level = Globals.game.get_current_run().current_level

	print(shrek_number, shrek_amount)

	$SharksLeft.text = "Sharks Left " + str( shrek_amount - shrek_number + 1 ) + "/" + str( shrek_amount )
	$CurrentLevel/Label.text = "Level " + str(level + 1)
