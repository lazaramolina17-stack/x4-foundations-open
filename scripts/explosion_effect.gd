extends Node3D
class_name ExplosionEffect

@export var explosion_type: String = "small"
@export var duration: float = 1.5

var particles: GPUParticles3D
var light: OmniLight3D
var timer: float = 0.0

func _ready():
	_setup_particles()
	_setup_light()

func _setup_particles():
	particles = GPUParticles3D.new()
	particles.one_shot = true
	particles.explosiveness = 1.0
	particles.lifetime = duration
	var material = ParticleProcessMaterial.new()
	material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	material.emission_sphere_radius = 1.0
	material.gravity = Vector3(0, -2, 0)
	match explosion_type:
		"small":
			material.color = Color(1, 0.5, 0.2)
			particles.amount = 30
			material.scale_min = 0.2; material.scale_max = 0.5
			material.initial_velocity_min = 2.0; material.initial_velocity_max = 8.0
		"medium":
			material.color = Color(1, 0.6, 0.2)
			particles.amount = 80
			material.scale_min = 0.3; material.scale_max = 0.8
			material.initial_velocity_min = 3.0; material.initial_velocity_max = 12.0
		"large":
			material.color = Color(1, 0.7, 0.3)
			particles.amount = 200
			material.scale_min = 0.5; material.scale_max = 1.5
			material.initial_velocity_min = 5.0; material.initial_velocity_max = 20.0
	particles.process_material = material
	add_child(particles)
	particles.emitting = true

func _setup_light():
	light = OmniLight3D.new()
	light.light_color = Color(1, 0.6, 0.2)
	light.omni_range = 10.0
	match explosion_type:
		"small": light.light_energy = 5.0
		"medium": light.light_energy = 15.0
		"large": light.light_energy = 30.0
	add_child(light)
	var tween = create_tween()
	tween.tween_property(light, "light_energy", 0, duration)

func _process(delta):
	timer += delta
	if timer >= duration * 1.5: queue_free()
