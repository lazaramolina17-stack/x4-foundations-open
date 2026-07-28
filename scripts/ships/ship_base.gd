extends ShipPhysics
class_name ShipBase

signal hull_changed(current: float, max_value: float)
signal shield_changed(current: float, max_value: float)
signal cargo_changed(resource_id: String, amount: int)
signal ship_destroyed(ship_id: String)
signal docked(station_id: String)
signal undocked

var ship_id: String = "discoverer"
var ship_data: Dictionary = {}
var faction_id: String = "player"
var ship_name: String = ""

var max_hull: float = 100.0
var current_hull: float = 100.0
var max_shield: float = 100.0
var current_shield: float = 100.0
var shield_regen_rate: float = 5.0
var shield_regen_delay: float = 3.0
var shield_regen_timer: float = 0.0

var cargo: Dictionary = {}
var max_cargo: int = 100

var weapons: Array = []
var turrets: Array = []
var current_weapon_index: int = 0
var weapon_cooldowns: Dictionary = {}

var is_docked: bool = false
var docked_station_id: String = ""
var is_player_ship: bool = false

func _ready():
	add_to_group("ships")
	_init_from_data()

func _init_from_data():
	ship_data = ShipData.get(ship_id)
	max_speed = ship_data.get("speed", 40.0)
	acceleration = ship_data.get("acceleration", 15.0)
	boost_speed = ship_data.get("boost_speed", 80.0)
	travel_speed = ship_data.get("travel_speed", 400.0)
	yaw_rate = ship_data.get("yaw_rate", 3.0)
	pitch_rate = ship_data.get("pitch_rate", 2.5)
	roll_rate = ship_data.get("roll_rate", 3.5)
	max_hull = ship_data.get("hull", 100.0)
	max_shield = ship_data.get("shield", 100.0)
	max_cargo = ship_data.get("cargo", 100)
	mass = max_hull * 0.5

	current_hull = max_hull
	current_shield = max_shield

func _process(delta):
	if is_docked: return
	_regen_shield(delta)

func _regen_shield(delta):
	if current_shield < max_shield:
		shield_regen_timer += delta
		if shield_regen_timer >= shield_regen_delay:
			current_shield = min(current_shield + shield_regen_rate * delta, max_shield)
			shield_changed.emit(current_shield, max_shield)
	else:
		shield_regen_timer = 0.0

func take_damage(amount: float, attacker_faction: String = ""):
	if current_shield > 0:
		if amount >= current_shield:
			amount -= current_shield
			current_shield = 0
		else:
			current_shield -= amount
			amount = 0
		shield_regen_timer = 0.0
		shield_changed.emit(current_shield, max_shield)

	if amount > 0:
		current_hull -= amount
		hull_changed.emit(current_hull, max_hull)
		if current_hull <= 0:
			_destroy()

func _destroy():
	ship_destroyed.emit(ship_id)
	queue_free()

func get_hull_percent() -> float:
	return current_hull / max_hull if max_hull > 0 else 0.0

func get_shield_percent() -> float:
	return current_shield / max_shield if max_shield > 0 else 0.0

func dock_at(station_id: String):
	is_docked = true
	docked_station_id = station_id
	docked.emit(station_id)

func undock():
	is_docked = false
	docked_station_id = ""
	undocked.emit()

func add_cargo(resource_id: String, amount: int) -> bool:
	var current = cargo.get(resource_id, 0)
	var total_volume = _get_total_cargo_volume() + ResourceData.get(resource_id).volume * amount
	if total_volume > max_cargo: return false
	cargo[resource_id] = current + amount
	cargo_changed.emit(resource_id, cargo[resource_id])
	return true

func remove_cargo(resource_id: String, amount: int) -> bool:
	var current = cargo.get(resource_id, 0)
	if current < amount: return false
	cargo[resource_id] = current - amount
	if cargo[resource_id] <= 0: cargo.erase(resource_id)
	cargo_changed.emit(resource_id, cargo.get(resource_id, 0))
	return true

func get_cargo_amount(resource_id: String) -> int:
	return cargo.get(resource_id, 0)

func get_total_cargo_volume() -> int:
	var total = 0
	for res in cargo:
		total += ResourceData.get(res).volume * cargo[res]
	return total

func _get_total_cargo_volume() -> int:
	return get_total_cargo_volume()

func get_free_cargo_space() -> int:
	return max_cargo - get_total_cargo_volume()

func get_cargo_used_percent() -> float:
	return float(get_total_cargo_volume()) / float(max_cargo) if max_cargo > 0 else 0.0
