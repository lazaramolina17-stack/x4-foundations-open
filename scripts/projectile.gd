extends Area3D
class_name Projectile

var damage: float = 15.0
var speed: float = 80.0
var range: float = 100.0
var damage_type: String = "laser"
var owner_node: Node
var distance_traveled: float = 0.0
var start_position: Vector3
var has_exploded: bool = false

var tracking_target: Node3D
var turn_rate: float = 3.0
var explosion_radius: float = 0.0
var penetration: int = 0
var hits: int = 0
var proximity_range: float = 5.0
var color: Color = Color(1, 0.2, 0.2)

func init(weapon_data: Dictionary, owner: Node):
	damage = weapon_data["damage"]
	speed = weapon_data["speed"]
	range = weapon_data["range"]
	damage_type = weapon_data["type"]
	owner_node = owner
	start_position = global_position
	color = weapon_data.get("color", Color.WHITE)
	if weapon_data.get("tracking", false):
		_setup_tracking()
	explosion_radius = weapon_data.get("aoe_radius", 0.0)
	penetration = weapon_data.get("penetration", 0)
	proximity_range = weapon_data.get("explosion_radius", explosion_radius)
	proximity_range = max(proximity_range, 5.0)
	_setup_collision()
	_setup_visuals()
	body_entered.connect(_on_body_entered)

func _setup_tracking():
	if not GameManager.player: return
	tracking_target = GameManager.player
	look_at(tracking_target.global_position, Vector3.UP)

func _setup_collision():
	collision_layer = 4
	collision_mask = 8
	var shape = CollisionShape3D.new()
	var box = BoxShape3D.new()
	box.size = Vector3(0.5, 0.5, 2.0)
	shape.shape = box
	add_child(shape)

func _setup_visuals():
	var mesh = MeshInstance3D.new()
	var material = StandardMaterial3D.new()
	material.emission = color
	material.emission_enabled = true
	material.emission_energy_multiplier = 2.0
	var cylinder = CylinderMesh.new()
	cylinder.height = 0.5
	cylinder.radius = 0.1
	mesh.mesh = cylinder
	mesh.material_override = material
	add_child(mesh)
	var light = OmniLight3D.new()
	light.light_color = color
	light.light_energy = 2.0
	light.omni_range = 5.0
	add_child(light)

func _physics_process(delta):
	if owner_node == null or not is_instance_valid(owner_node):
		queue_free(); return
	distance_traveled += abs(global_position.distance_to(start_position))
	if distance_traveled >= range:
		_explode(); return
	global_translate(-global_transform.basis.z * speed * delta)
	distance_traveled += speed * delta
	if tracking_target and is_instance_valid(tracking_target):
		_track_target(delta)
	if tracking_target:
		var dist = global_position.distance_to(tracking_target.global_position)
		if dist <= proximity_range:
			_explode()

func _track_target(delta):
	if not tracking_target or not is_instance_valid(tracking_target): return
	var target_dir = (tracking_target.global_position - global_position).normalized()
	var quat = Quaternion(global_transform.basis.z, target_dir)
	quaternion = quaternion.slerp(quat, turn_rate * delta)

func _on_body_entered(body: Node3D):
	if has_exploded or body == owner_node: return
	if body.has_method("take_damage"):
		body.take_damage(damage, damage_type)
		GameManager.register_shot(true)
	if penetration > 0:
		hits += 1
		if hits >= penetration: _explode()
	else:
		_explode()

func _explode():
	if has_exploded: return
	has_exploded = true
	if explosion_radius > 0:
		var enemies = get_tree().get_nodes_in_group("Enemy")
		for enemy in enemies:
			if enemy != owner_node and is_instance_valid(enemy):
				var dist = global_position.distance_to(enemy.global_position)
				if dist <= explosion_radius:
					var falloff = 1.0 - dist / explosion_radius
					enemy.take_damage(damage * falloff, damage_type)
		var explosion = preload("res://scenes/effects/explosion_small.tscn").instantiate()
		get_parent().add_child(explosion)
		explosion.global_position = global_position
	queue_free()

func get_damage() -> float: return damage
func get_damage_type() -> String: return damage_type
