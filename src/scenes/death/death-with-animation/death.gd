extends Node

func _ready():
	$Button.visible = false
	$DeathAnimation.connect("animation_finished",Callable(self,"_on_animation_finished"))

func _on_animation_finished():
	$Button.visible = true

func _on_button_pressed() -> void:
	var after_death_scene = preload("res://src/scenes/death/after-death/after-death.tscn")
	get_tree().change_scene_to_packed(after_death_scene) # Replace with function body.
