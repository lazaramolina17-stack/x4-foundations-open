extends RefCounted
class_name FactionData

static func get_all() -> Dictionary:
	return {
		"argon": {
			"name": "Argon Federation",
			"color": Color(0.2, 0.4, 0.9),
			"description": "The Argon Federation is a democratic human faction.",
			"home_sector": "argon_prime",
			"personality": "expansionist",
			"aggression": 0.5,
			"economy_focus": 0.6,
			"starting_relations": { "teladi": 0.2, "paranid": -0.3, "xenon": -0.9 },
			"ship_preferences": ["nova", "discoverer", "mercury", "cerberus", "behemoth", "colossus"],
			"starting_sectors": ["argon_prime", "the_hole", "black_hole_sun"],
			"color_hsb": { "h": 0.6, "s": 0.7, "b": 0.8 }
		},
		"teladi": {
			"name": "Teladi Company",
			"color": Color(0.2, 0.8, 0.3),
			"description": "Profit-oriented reptilian merchants.",
			"home_sector": "ceo_doubt",
			"personality": "mercantile",
			"aggression": 0.3,
			"economy_focus": 0.9,
			"starting_relations": { "argon": 0.2, "paranid": 0.0, "xenon": -0.8 },
			"ship_preferences": ["buzzard", "vulture", "mercury", "behemoth"],
			"starting_sectors": ["ceo_doubt", "profit_center_alpha", "grand_exchange"],
			"color_hsb": { "h": 0.33, "s": 0.7, "b": 0.7 }
		},
		"paranid": {
			"name": "Paranid Empire",
			"color": Color(0.8, 0.2, 0.2),
			"description": "Religious warrior race seeking purity.",
			"home_sector": "holy_vision",
			"personality": "aggressive",
			"aggression": 0.8,
			"economy_focus": 0.4,
			"starting_relations": { "argon": -0.3, "teladi": 0.0, "xenon": -0.9 },
			"ship_preferences": ["nova", "cerberus", "behemoth", "colossus"],
			"starting_sectors": ["holy_vision", "sacred_relic", "trinity_vii"],
			"color_hsb": { "h": 0.0, "s": 0.7, "b": 0.7 }
		},
		"xenon": {
			"name": "Xenon Collective",
			"color": Color(0.0, 0.9, 0.1),
			"description": "Hostile machine intelligence.",
			"home_sector": "xenon_space_1",
			"personality": "destroyer",
			"aggression": 1.0,
			"economy_focus": 0.2,
			"starting_relations": { "argon": -0.9, "teladi": -0.8, "paranid": -0.9 },
			"ship_preferences": ["xenon_fighter", "xenon_destroyer", "xenon_carrier"],
			"starting_sectors": ["xenon_space_1", "xenon_space_2"],
			"color_hsb": { "h": 0.3, "s": 0.8, "b": 0.8 }
		},
		"player": {
			"name": "Player",
			"color": Color(1.0, 0.8, 0.0),
			"description": "Your own faction.",
			"home_sector": "unknown_alpha",
			"personality": "player",
			"aggression": 0.5,
			"economy_focus": 0.5,
			"starting_relations": { "argon": 0.0, "teladi": 0.0, "paranid": 0.0, "xenon": -0.5 },
			"ship_preferences": ["discoverer"],
			"starting_sectors": [],
			"color_hsb": { "h": 0.12, "s": 0.9, "b": 0.9 }
		}
	}

static func get(id: String) -> Dictionary:
	return get_all().get(id, get_all()["argon"])

static func get_relation_threshold(standing: float) -> String:
	if standing >= 0.9: return "Ally"
	elif standing >= 0.6: return "Friend"
	elif standing >= 0.2: return "Acquaintance"
	elif standing >= -0.2: return "Neutral"
	elif standing >= -0.6: return "Enemy"
	else: return "Nemesis"

static func relation_mod_for_action(action: String) -> float:
	match action:
		"trade_large": return 0.005
		"trade_small": return 0.001
		"kill_pirate": return 0.02
		"kill_enemy": return 0.05
		"build_station": return 0.01
		"complete_mission": return 0.03
		"attack_fleet": return -0.1
		"destroy_ship": return -0.02
		"destroy_station": return -0.3
		"illegal_trade": return -0.01
		"pirate_act": return -0.05
	return 0.0
