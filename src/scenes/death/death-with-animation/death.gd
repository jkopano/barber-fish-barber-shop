extends Node

func _ready():
	randomize()
	
	$Button.visible = false
	$DeathAnimation.connect("animation_finished",Callable(self,"_on_animation_finished"))

func _on_animation_finished():
	$Button.visible = true

const chances_of_undertale_percentage = 10

func _on_button_pressed() -> void:
	randomize()
	var after_death_scene
	if randf() < (chances_of_undertale_percentage / 100.0):
		after_death_scene = preload("res://src/scenes/death/after-death/after-death.tscn")
	else:
		after_death_scene = preload("res://src/scenes/splash-screen/silli-splash-screen.tscn")
	get_tree().change_scene_to_packed(after_death_scene) # Replace with function body.
