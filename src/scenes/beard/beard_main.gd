extends MiniGame

func on_finish_game():
	for child in get_children():
		if child.name == "TRANS":
			child.play_anim(exit_game, 0.7)
