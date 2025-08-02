extends Node2D

@onready var particles = self
var rng = RandomNumberGenerator.new()

func _ready():
	var material := particles.material as ParticleProcessMaterial
	var rand = rng.randf_range(1.0, 3.0)
	if material:
		material.scale = Vector2(rand, rand)
		particles.restart()
