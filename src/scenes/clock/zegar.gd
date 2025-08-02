extends Node2D

#Timerek odmierzający 60 sek na zegarku ~ hubiś

@onready var kreska = $"Zegar-kreska"
@onready var tarcza = $"Zegar-tarcza"

var time = 60.0
var for_every : float
var next_rotate : float
var time_elapsed := 0.0
var ispaused = false

func _ready() -> void:
	for_every = time / 16
	next_rotate = for_every

func _process(delta: float) -> void:
	if ispaused == false:
		time_elapsed += delta
	
	if next_rotate <= time_elapsed:
		kreska.rotation += 0.3926991
		next_rotate = next_rotate + for_every
		
	if time * 0.75 <= time_elapsed:
		tarcza.self_modulate = Color(255, 0, 0, 255)
		
	if time <= time_elapsed:
		await get_tree().create_timer(0.2).timeout
		var death_scene = preload("res://src/scenes/death/death-with-animation/death.tscn")
		get_tree().change_scene_to_packed(death_scene)

#
