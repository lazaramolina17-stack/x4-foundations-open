extends RefCounted
class_name WeaponData

enum WeaponType { LASER, PLASMA, RAILGUN, MISSILE, BEAM, ION, FLAK }
enum Size { S, M, L }

static func get_all() -> Dictionary:
	return {
		"laser_mk1": {
			"name": "Laser Mk1", "type": WeaponType.LASER, "size": Size.S,
			"damage": 15, "fire_rate": 0.15, "range": 800, "speed": 800,
			"energy_cost": 2, "heat_per_shot": 5,
			"color": Color(1, 0.2, 0.2), "piercing": false
		},
		"laser_mk2": {
			"name": "Laser Mk2", "type": WeaponType.LASER, "size": Size.S,
			"damage": 25, "fire_rate": 0.12, "range": 900, "speed": 900,
			"energy_cost": 3, "heat_per_shot": 6,
			"color": Color(1, 0.3, 0.3), "piercing": false
		},
		"plasma_cannon": {
			"name": "Plasma Cannon", "type": WeaponType.PLASMA, "size": Size.M,
			"damage": 80, "fire_rate": 0.8, "range": 1200, "speed": 500,
			"energy_cost": 15, "heat_per_shot": 20,
			"color": Color(0.2, 0.8, 1), "aoe_radius": 5.0
		},
		"railgun": {
			"name": "Railgun", "type": WeaponType.RAILGUN, "size": Size.L,
			"damage": 200, "fire_rate": 2.0, "range": 3000, "speed": 3000,
			"energy_cost": 40, "heat_per_shot": 40,
			"color": Color(1, 1, 0.5), "piercing": true, "penetration": 3
		},
		"missile_launcher": {
			"name": "Missile Launcher", "type": WeaponType.MISSILE, "size": Size.M,
			"damage": 150, "fire_rate": 3.0, "range": 5000, "speed": 400,
			"energy_cost": 0, "heat_per_shot": 10, "ammo_per_shot": 1,
			"color": Color(1, 0.6, 0), "tracking": true, "turn_rate": 2.0
		},
		"beam_laser": {
			"name": "Beam Laser", "type": WeaponType.BEAM, "size": Size.M,
			"damage": 40, "fire_rate": 0.05, "range": 600, "speed": 0,
			"energy_cost": 25, "heat_per_shot": 3,
			"color": Color(1, 0, 1), "continuous": true
		},
		"ion_cannon": {
			"name": "Ion Cannon", "type": WeaponType.ION, "size": Size.M,
			"damage": 30, "fire_rate": 0.6, "range": 1000, "speed": 700,
			"energy_cost": 18, "heat_per_shot": 15,
			"color": Color(0, 1, 1), "shield_damage_mult": 2.5
		},
		"flak_cannon": {
			"name": "Flak Cannon", "type": WeaponType.FLAK, "size": Size.M,
			"damage": 35, "fire_rate": 0.5, "range": 800, "speed": 600,
			"energy_cost": 12, "heat_per_shot": 12,
			"color": Color(1, 0.8, 0.2), "explosion_radius": 8.0, "proximity_fuse": true
		}
	}

static func get(id: String) -> Dictionary:
	return get_all().get(id, get_all()["laser_mk1"])

static func get_size_name(s: Size) -> String:
	match s:
		Size.S: return "S"
		Size.M: return "M"
		Size.L: return "L"
	return "?"
