extends Node3D
class_name StarField

@export var star_count: int = 500
@export var radius: float = 400.0
@export var min_size: float = 0.5
@export var max_size: float = 3.0

func _ready():
	_generate()

func _generate():
	for i in range(star_count):
		var star = MeshInstance3D.new()
		var sphere = SphereMesh.new()
		sphere.radius = randf_range(min_size, max_size) * 0.5
		sphere.height = sphere.radius * 2
		star.mesh = sphere
		var mat = StandardMaterial3D.new()
		var b = randf_range(0.5, 1.0)
		mat.albedo_color = Color(b, b, b + randf_range(-0.1, 0.1))
		mat.emission = mat.albedo_color
		mat.emission_enabled = true
		mat.emission_energy_multiplier = randf_range(0.5, 2.0)
		star.material_override = mat
		var theta = randf() * TAU
		var phi = acos(2.0 * randf() - 1.0)
		var r = radius + randf_range(-50, 50)
		star.position = Vector3(
			r * sin(phi) * cos(theta),
			r * cos(phi) * 0.3,
			r * sin(phi) * sin(theta)
		)
		add_child(star)
