extends Node

func start_fire(position):
	print("got signal in fireowrk scene")
	var firework = $FireworkBase
	firework.start(position)
