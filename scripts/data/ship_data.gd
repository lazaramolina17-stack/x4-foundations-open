extends RefCounted
class_name ShipData

enum ShipClass { S, M, L, XL }
enum Role { FIGHTER, INTERCEPTOR, BOMBER, CORVETTE, FRIGATE, DESTROYER, CARRIER, TRADER, MINER, TRANSPORT }

static func get_all() -> Dictionary:
	return {
		"discoverer": {
			"name": "Discoverer",
			"class": ShipClass.S,
			"role": Role.FIGHTER,
			"speed": 45.0, "acceleration": 20.0, "boost_speed": 90.0, "travel_speed": 450.0,
			"yaw_rate": 3.5, "pitch_rate": 3.0, "roll_rate": 4.0,
			"shield": 80, "hull": 120,
			"cargo": 50, "crew": 1,
			"weapon_slots": 1, "turret_slots": 0, "shield_slots": 1,
			"cost": 50000, "faction": ["argon", "teladi"],
			"description": "Light scout fighter, fast and maneuverable."
		},
		"nova": {
			"name": "Nova",
			"class": ShipClass.S,
			"role": Role.FIGHTER,
			"speed": 38.0, "acceleration": 16.0, "boost_speed": 76.0, "travel_speed": 380.0,
			"yaw_rate": 3.0, "pitch_rate": 2.5, "roll_rate": 3.5,
			"shield": 200, "hull": 300,
			"cargo": 80, "crew": 1,
			"weapon_slots": 2, "turret_slots": 0, "shield_slots": 2,
			"cost": 120000, "faction": ["argon"],
			"description": "Heavy fighter with strong shields."
		},
		"buzzard": {
			"name": "Buzzard",
			"class": ShipClass.S,
			"role": Role.INTERCEPTOR,
			"speed": 52.0, "acceleration": 22.0, "boost_speed": 104.0, "travel_speed": 520.0,
			"yaw_rate": 4.0, "pitch_rate": 3.8, "roll_rate": 4.5,
			"shield": 120, "hull": 180,
			"cargo": 60, "crew": 1,
			"weapon_slots": 2, "turret_slots": 0, "shield_slots": 1,
			"cost": 85000, "faction": ["teladi"],
			"description": "Fast interceptor. Excellent speed."
		},
		"vulture": {
			"name": "Vulture",
			"class": ShipClass.M,
			"role": Role.MINER,
			"speed": 22.0, "acceleration": 8.0, "boost_speed": 44.0, "travel_speed": 220.0,
			"yaw_rate": 1.5, "pitch_rate": 1.2, "roll_rate": 2.0,
			"shield": 600, "hull": 1500,
			"cargo": 3000, "crew": 2,
			"weapon_slots": 1, "turret_slots": 2, "shield_slots": 3,
			"cost": 350000, "faction": ["teladi", "argon"],
			"description": "Medium miner with large cargo hold."
		},
		"mercury": {
			"name": "Mercury",
			"class": ShipClass.M,
			"role": Role.TRADER,
			"speed": 25.0, "acceleration": 10.0, "boost_speed": 50.0, "travel_speed": 250.0,
			"yaw_rate": 1.8, "pitch_rate": 1.5, "roll_rate": 2.2,
			"shield": 400, "hull": 1200,
			"cargo": 5000, "crew": 2,
			"weapon_slots": 1, "turret_slots": 1, "shield_slots": 2,
			"cost": 280000, "faction": ["argon"],
			"description": "Reliable medium freighter."
		},
		"cerberus": {
			"name": "Cerberus",
			"class": ShipClass.M,
			"role": Role.CORVETTE,
			"speed": 30.0, "acceleration": 12.0, "boost_speed": 60.0, "travel_speed": 300.0,
			"yaw_rate": 2.2, "pitch_rate": 2.0, "roll_rate": 2.5,
			"shield": 800, "hull": 2000,
			"cargo": 500, "crew": 6,
			"weapon_slots": 3, "turret_slots": 2, "shield_slots": 3,
			"cost": 800000, "faction": ["argon"],
			"description": "Heavy corvette. Gunship role."
		},
		"behemoth": {
			"name": "Behemoth",
			"class": ShipClass.L,
			"role": Role.DESTROYER,
			"speed": 12.0, "acceleration": 4.0, "boost_speed": 24.0, "travel_speed": 120.0,
			"yaw_rate": 0.8, "pitch_rate": 0.6, "roll_rate": 1.0,
			"shield": 5000, "hull": 20000,
			"cargo": 2000, "crew": 50,
			"weapon_slots": 4, "turret_slots": 8, "shield_slots": 4,
			"cost": 6000000, "faction": ["argon"],
			"description": "Main battle destroyer. Heavy artillery."
		},
		"colossus": {
			"name": "Colossus",
			"class": ShipClass.XL,
			"role": Role.CARRIER,
			"speed": 8.0, "acceleration": 2.0, "boost_speed": 16.0, "travel_speed": 80.0,
			"yaw_rate": 0.4, "pitch_rate": 0.3, "roll_rate": 0.5,
			"shield": 15000, "hull": 60000,
			"cargo": 10000, "crew": 200,
			"weapon_slots": 6, "turret_slots": 12, "shield_slots": 6,
			"cost": 25000000, "faction": ["argon"],
			"description": "Aircraft carrier. Fleet command ship."
		}
	}

static func get(id: String) -> Dictionary:
	var all = get_all()
	return all.get(id, all["discoverer"])

static func get_class_name(c: ShipClass) -> String:
	match c:
		ShipClass.S: return "S"
		ShipClass.M: return "M"
		ShipClass.L: return "L"
		ShipClass.XL: return "XL"
	return "?"

static func get_role_name(r: Role) -> String:
	match r:
		Role.FIGHTER: return "Fighter"
		Role.INTERCEPTOR: return "Interceptor"
		Role.BOMBER: return "Bomber"
		Role.CORVETTE: return "Corvette"
		Role.FRIGATE: return "Frigate"
		Role.DESTROYER: return "Destroyer"
		Role.CARRIER: return "Carrier"
		Role.TRADER: return "Trader"
		Role.MINER: return "Miner"
		Role.TRANSPORT: return "Transport"
	return "?"
