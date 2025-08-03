extends Node2D

func _ready():
	var shrek_number = Globals.game.get_current_run().get_current().current_shrek_number
	var shrek_amount = Globals.game.get_current_run().get_current().shrek_amount

	print(shrek_number, shrek_amount)

	$SharksLeft.text = "Sharks Left " + str( shrek_amount - shrek_number + 1 ) + "/" + str( shrek_amount )
