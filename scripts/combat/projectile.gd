extends Area3D
class_name Projectile

var weapon_data: Dictionary = {}
var faction_id: String = ""
var owner_ship: Node = null
var speed: float = 800.0
var damage: float = 15.0
var lifetime: float = 3.0
var age: float = 0.0
var tracking: bool = false
var turn_rate: float = 0.0
var target: Node3D = null
var piercing: bool = false
var penetration_left: int = 0
var aoe_radius: float = 0.0
var proximity_fuse: bool = false

func init(data: Dictionary, faction: String, owner: Node):
	weapon_data = data
	faction_id = faction
	owner_ship = owner
	speed = data.get("speed", 800)
	damage = data.get("damage", 15)
	lifetime = data.get("range", 800) / maxf(speed, 1) + 0.5
	tracking = data.get("tracking", false)
	turn_rate = data.get("turn_rate", 0.0)
	piercing = data.get("piercing", false)
	penetration_left = data.get("penetration", 1)
	aoe_radius = data.get("aoe_radius", 0.0)
	proximity_fuse = data.get("proximity_fuse", false)

	var mesh = MeshInstance3D.new()
	if tracking:
		mesh.mesh = SphereMesh.new()
		mesh.mesh.radius = 0.5
	else:
		mesh.mesh = BoxMesh.new()
		mesh.mesh.size = Vector3(0.3, 0.3, 1.5)
	var mat = StandardMaterial3D.new()
	mat.albedo_color = data.get("color", Color.RED)
	mat.emission_enabled = true
	mat.emission = data.get("color", Color.RED)
	mat.emission_energy = 5.0
	mesh.mesh.material = mat
	add_child(mesh)

	var col = CollisionShape3D.new()
	col.shape = SphereShape3D.new()
	col.shape.radius = 1.0
	add_child(col)
	body_entered.connect(_on_hit)
	add_to_group("projectiles")

func _process(delta):
	age += delta
	if age > lifetime:
		_destroy()
		return

	if tracking and target and is_instance_valid(target):
		var dir = (target.global_position - global_position).normalized()
		var forward = -global_transform.basis.z
		var rot = forward.slerp(dir, turn_rate * delta).normalized()
		global_transform.basis = Basis.looking_at(rot, Vector3.UP)
		global_position += -global_transform.basis.z * speed * delta
	else:
		global_position += -global_transform.basis.z * speed * delta

func _on_hit(body: Node):
	if body == owner_ship: return
	if body.is_in_group("projectiles"): return

	var ship = body as ShipBase
	if ship:
		if ship.faction_id == faction_id: return
		if piercing and penetration_left > 0:
			penetration_left -= 1
		else:
			_destroy()
		var mult = 1.0
		if weapon_data.get("type", 0) == 6: mult = weapon_data.get("shield_damage_mult", 1.0)
		ship.take_damage(damage * mult, faction_id)
		if aoe_radius > 0:
			_do_aoe_damage()
	elif aoe_radius > 0:
		_do_aoe_damage()
		_destroy()

func _do_aoe_damage():
	var space = get_tree().root.find_child("SectorContainer", true, false)
	if not space: return
	var all_ships = get_tree().get_nodes_in_group("ships")
	for s in all_ships:
		if s == owner_ship: continue
		var dist = global_position.distance_to(s.global_position)
		if dist < aoe_radius:
			var falloff = 1.0 - (dist / aoe_radius)
			s.take_damage(damage * falloff * 0.5, faction_id)

func _destroy():
	queue_free()
