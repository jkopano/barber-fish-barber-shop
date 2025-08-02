extends Node

@onready var label = $Label
@onready var request = $Request
@onready var accept = $Accept
@onready var refuse = $Refuse
var full_text_label = "SINCE WHEN WERE YOU THE ONE IN CONTROL?"
var full_text_request = "GIVE ME YOUR SOUL OR YOU WON'T BE ABLE TO GO BACK!"
var current_index = 0
var typing_speed = 0.075

func _ready():
	label.text = ""
	request.text = ""
	accept.visible = false
	refuse.visible = false
	if Global.has_ever_visited_after_death_scene:
		start_typing(label,full_text_label)
		await get_tree().create_timer(5).timeout
	start_typing(request,full_text_request)
	await get_tree().create_timer(5).timeout
	accept.visible = true
	refuse.visible = true
	Global.has_ever_visited_after_death_scene = true
	
func start_typing(l,t):
	current_index = 0
	_reveal_next_char(l,t)
	
func _reveal_next_char(l,t):
	if current_index < t.length():
		l.text += t[current_index]
		current_index += 1
		await get_tree().create_timer(typing_speed).timeout
		_reveal_next_char(l,t)

func _on_accept_pressed() :
	var main_menu_scene = preload("res://src/scenes/splash-screen/silli-splash-screen.tscn")
	get_tree().change_scene_to_packed(main_menu_scene)


func _on_refuse_pressed():
	var after_death_scene = preload("res://src/scenes/death/after-death/after-death.tscn")
	get_tree().change_scene_to_packed(after_death_scene)
