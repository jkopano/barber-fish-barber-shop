extends CharacterBody2D

@export var speed = 5000
var is_interactable = false

signal fish_interact_furniture(scene: PackedScene)
signal fish_interact

func _ready() -> void:
	if Globals.player_data and Globals.player_data.pos:
		position = Globals.player_data.pos
	if Globals.player_data and Globals.player_data.frame:
		$Fish.frame = Globals.player_data.frame

func _process(dt: float) -> void:
	move(dt)
	interact()

func cart_to_iso(vec: Vector2) -> Vector2:
	return Vector2(vec.x, vec.y / 2)

func interact():
	if Input.is_action_just_pressed("ACTION") and is_interactable:
		print("lool")
		fish_interact.emit()

func move(dt):
	var input = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	var direction = cart_to_iso(input)
	choose_anim(input)

	velocity = direction * speed * dt

	move_and_slide()




func choose_anim(vec: Vector2) -> void:
	if vec == Vector2.UP:
		$Fish.frame = 1
	if vec == Vector2.RIGHT:
		$Fish.frame = 5
	if vec == Vector2.LEFT:
		$Fish.frame = 3
	if vec == Vector2.DOWN:
		$Fish.frame = 7
	if vec == ( Vector2.UP + Vector2.LEFT ).normalized():
		$Fish.frame = 0
	if vec == ( Vector2.UP + Vector2.RIGHT ).normalized():
		$Fish.frame = 2
	if vec == ( Vector2.DOWN + Vector2.LEFT ).normalized():
		$Fish.frame = 6
	if vec == ( Vector2.DOWN + Vector2.RIGHT ).normalized():
		$Fish.frame = 8


func _on_area_2d_body_entered(_body:Node2D) -> void:
	is_interactable = true

func _on_area_2d_body_exited(_body:Node2D) -> void:
	is_interactable = false

func load_barber():
	fish_interact_furniture.emit(load("res://src/scenes/barber/barber-main.tscn"))
func load_barman():
		fish_interact_furniture.emit(load("res://src/scenes/Bar/drink-bar/drink-bar.tscn"))
func load_dentist():
	fish_interact_furniture.emit(load("res://src/scenes/dentist/dentist-main.tscn"))
func load_beard():
	fish_interact_furniture.emit(load("res://src/scenes/beard/beard-main.tscn"))
	

func _on_barber_area_entered(_body:Node2D)-> void:
	if $"../BarberTable".to_be_picked == true:
		var rooter = get_tree().current_scene.name
		for child in get_tree().current_scene.get_children():
			if child.name == "TRANS":
				child.play_anim(load_barber, 0)

func _on_barman_area_entered(_body:Node2D) -> void:
	if $"../DrinkTable".to_be_picked == true:
		var rooter = get_tree().current_scene.name
		for child in get_tree().current_scene.get_children():
			if child.name == "TRANS":
				child.play_anim(load_barman, 0)

func _on_denstist_area_entered(_body:Node2D) -> void:
	if $"../DentistTable".to_be_picked == true:
		var rooter = get_tree().current_scene.name
		for child in get_tree().current_scene.get_children():
			if child.name == "TRANS":
				child.play_anim(load_dentist, 0)

func _on_beard_area_entered(_body:Node2D)-> void:
	if $"../BeardMirror".to_be_picked == true:
		var rooter = get_tree().current_scene.name
		for child in get_tree().current_scene.get_children():
			if child.name == "TRANS":
				child.play_anim(load_beard, 0)
