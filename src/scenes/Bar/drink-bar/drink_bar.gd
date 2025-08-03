extends MiniGame


func _on_shark_end_minigame() -> void:
	for child in get_children():
		if child.name == "TRANS":
			child.play_anim(exit_game, 1.3)
