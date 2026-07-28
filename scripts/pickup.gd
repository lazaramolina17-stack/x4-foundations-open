extends Area3D
class_name Pickup

@export var pickup_type: String = "health"
@export var amount: int = 25

var pickup_data: Dictionary
var rotation_speed: float = 2.0
var bob_amplitude: float = 0.5
var bob_speed: float = 3.0
var lifetime: float = 30.0
var age: float = 0.0
var attracted_to_player: bool = false
var attraction_speed: float = 20.0
var attraction_range: float = 20.0

var initial_y: float
var mesh: MeshInstance3D

func _ready():
	add_to_group("Pickups")
	initial_y = global_position.y
	_setup_visuals()
	_setup_collision()
	body_entered.connect(_on_body_entered)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3.ONE, 0.3).from(Vector3.ZERO)

func init(data: Dictionary):
	pickup_data = data
	amount = data.get("amount", 25)
	pickup_type = data.get("pickup_type", pickup_type)
	_setup_visuals()

func _setup_visuals():
	if mesh: mesh.queue_free()
	mesh = MeshInstance3D.new()
	mesh.mesh = BoxMesh.new()
	mesh.set_surface_override_material(0, _create_material(_get_pickup_color()))
	add_child(mesh)

func _create_material(color: Color) -> Material:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mat.emission = color
	mat.emission_enabled = true
	mat.emission_energy_multiplier = 0.5
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.metallic = 0.5
	mat.roughness = 0.3
	return mat

func _get_pickup_color() -> Color:
	match pickup_type:
		"health": return Color(0, 1, 0)
		"shield": return Color(0, 0.5, 1)
		"energy": return Color(1, 1, 0)
		"credits": return Color(1, 0.8, 0)
		"weapon_upgrade": return Color(1, 0, 1)
		"missile_ammo": return Color(1, 0.5, 0)
	return Color.WHITE

func _setup_collision():
	var collision = CollisionShape3D.new()
	var shape = SphereShape3D.new()
	shape.radius = 1.5
	collision.shape = shape
	add_child(collision)

func _physics_process(delta):
	age += delta
	if age >= lifetime: _despawn(); return
	_handle_movement(delta)
	_handle_attraction(delta)

func _handle_movement(delta):
	rotate_y(rotation_speed * delta)
	var bob_offset = sin(age * bob_speed) * bob_amplitude
	global_position.y = initial_y + bob_offset

func _handle_attraction(delta):
	if not GameManager.player or not is_instance_valid(GameManager.player): return
	var distance = global_position.distance_to(GameManager.player.global_position)
	if distance <= attraction_range:
		attracted_to_player = true
		var direction = (GameManager.player.global_position - global_position).normalized()
		var speed_factor = 1.0 - distance / attraction_range
		global_position += direction * attraction_speed * speed_factor * delta

func _on_body_entered(body: Node3D):
	if body.is_in_group("Player"): _collect(body)

func _collect(player: PlayerShip):
	match pickup_type:
		"health": player.heal(amount)
		"shield": player.recharge_shield(amount)
		"energy": player.recharge_energy(amount)
		"credits": GameManager.add_credits(amount)
		"missile_ammo": player.current_missiles = min(player.current_missiles + amount, player.missile_capacity)
	queue_free()

func _despawn():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5)
	tween.tween_callback(queue_free)
