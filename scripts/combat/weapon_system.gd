extends Node
class_name WeaponSystem

signal weapon_fired(weapon_index: int, weapon_id: String)

var ship: ShipBase
var equipped_weapons: Array[Dictionary] = []
var weapon_cooldowns: Array[float] = []
var weapon_heat: Array[float] = []
var current_weapon_index: int = 0
var max_heat: float = 100.0
var heat_cooldown_rate: float = 15.0
var is_firing: bool = false

func _ready():
	ship = get_parent() as ShipBase

func add_weapon(weapon_id: String):
	var data = WeaponData.get(weapon_id)
	equipped_weapons.append(data.duplicate())
	weapon_cooldowns.append(0.0)
	weapon_heat.append(0.0)

func remove_weapon(index: int):
	if index >= 0 and index < equipped_weapons.size():
		equipped_weapons.remove_at(index)
		weapon_cooldowns.remove_at(index)
		weapon_heat.remove_at(index)

func _process(delta):
	for i in range(weapon_cooldowns.size()):
		if weapon_cooldowns[i] > 0:
			weapon_cooldowns[i] -= delta
		if weapon_heat[i] > 0:
			weapon_heat[i] = max(0, weapon_heat[i] - heat_cooldown_rate * delta)

	if is_firing and current_weapon_index < equipped_weapons.size():
		_try_fire()

func _try_fire():
	var idx = current_weapon_index
	if idx >= equipped_weapons.size():
		idx = 0
		current_weapon_index = 0
	if equipped_weapons.is_empty(): return

	var weapon = equipped_weapons[idx]
	var cd = weapon_cooldowns[idx]
	if cd > 0: return
	if weapon_heat[idx] >= max_heat: return

	var energy_cost = weapon.get("energy_cost", 0)
	if ship and ship.has_method("current_energy"):
		if ship.current_energy < energy_cost: return

	var projectile_scene = preload("res://scenes/weapons/projectile.tscn")
	if not projectile_scene: return

	var muzzle = ship.get_node_or_null("Muzzle")
	var origin = muzzle.global_position if muzzle else ship.global_position
	var forward = -ship.global_transform.basis.z

	var proj = projectile_scene.instantiate()
	proj.init(weapon, ship.faction_id, ship)
	get_tree().current_scene.add_child(proj)
	proj.global_position = origin + forward * 2.0
	proj.global_transform.basis = ship.global_transform.basis

	weapon_cooldowns[idx] = weapon.get("fire_rate", 0.5)
	weapon_heat[idx] = min(max_heat, weapon_heat[idx] + weapon.get("heat_per_shot", 5))
	weapon_fired.emit(idx, weapon.get("id", "unknown"))

func switch_weapon(direction: int):
	if equipped_weapons.is_empty(): return
	current_weapon_index = (current_weapon_index + direction) % equipped_weapons.size()

func set_firing(firing: bool):
	is_firing = firing

func get_current_weapon_name() -> String:
	if current_weapon_index < equipped_weapons.size():
		return equipped_weapons[current_weapon_index].get("name", "Unknown")
	return "No Weapon"

func get_heat_percent() -> float:
	if equipped_weapons.is_empty(): return 0.0
	var total = 0.0
	for h in weapon_heat:
		total += h
	return total / (max_heat * equipped_weapons.size())
