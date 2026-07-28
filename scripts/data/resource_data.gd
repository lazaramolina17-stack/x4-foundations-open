extends RefCounted
class_name ResourceData

enum Tier { RAW, INTERMEDIATE, ADVANCED, FINAL, CONSUMABLE }

static func get_all() -> Dictionary:
	return {
		"energy_cells": {
			"name": "Energy Cells", "tier": Tier.RAW, "volume": 1,
			"price_min": 4, "price_max": 12, "produced_by": ["solar_plant"],
			"consumed_by": ["refinery", "factory", "wharf", "shipyard"],
			"description": "Basic energy cells from solar plants."
		},
		"ore": {
			"name": "Ore", "tier": Tier.RAW, "volume": 3,
			"price_min": 15, "price_max": 40, "produced_by": ["mine"],
			"consumed_by": ["refinery"],
			"description": "Raw ore from asteroid mining."
		},
		"silicon": {
			"name": "Silicon", "tier": Tier.RAW, "volume": 3,
			"price_min": 20, "price_max": 55, "produced_by": ["mine"],
			"consumed_by": ["refinery"],
			"description": "Raw silicon from asteroid mining."
		},
		"nividium": {
			"name": "Nividium", "tier": Tier.RAW, "volume": 4,
			"price_min": 80, "price_max": 200, "produced_by": ["mine"],
			"consumed_by": ["refinery", "research_lab"],
			"description": "Rare mineral for advanced tech."
		},
		"refined_metals": {
			"name": "Refined Metals", "tier": Tier.INTERMEDIATE, "volume": 2,
			"price_min": 60, "price_max": 150, "produced_by": ["refinery"],
			"consumed_by": ["factory", "shipyard", "wharf"],
			"description": "Processed metals from ore."
		},
		"refined_silicon": {
			"name": "Refined Silicon", "tier": Tier.INTERMEDIATE, "volume": 2,
			"price_min": 80, "price_max": 190, "produced_by": ["refinery"],
			"consumed_by": ["factory", "shipyard", "wharf"],
			"description": "Processed silicon wafers."
		},
		"plasma_conductors": {
			"name": "Plasma Conductors", "tier": Tier.ADVANCED, "volume": 2,
			"price_min": 200, "price_max": 500, "produced_by": ["factory"],
			"consumed_by": ["shipyard", "wharf", "equipment_dock"],
			"description": "Advanced electronic components."
		},
		"shield_components": {
			"name": "Shield Components", "tier": Tier.ADVANCED, "volume": 3,
			"price_min": 300, "price_max": 700, "produced_by": ["factory"],
			"consumed_by": ["shipyard", "wharf"],
			"description": "Components for shield generators."
		},
		"weapon_components": {
			"name": "Weapon Components", "tier": Tier.ADVANCED, "volume": 3,
			"price_min": 350, "price_max": 800, "produced_by": ["factory"],
			"consumed_by": ["shipyard", "wharf", "equipment_dock"],
			"description": "Components for weapons."
		},
		"engine_parts": {
			"name": "Engine Parts", "tier": Tier.ADVANCED, "volume": 3,
			"price_min": 250, "price_max": 600, "produced_by": ["factory"],
			"consumed_by": ["shipyard", "wharf"],
			"description": "Parts for ship engines."
		},
		"hull_parts": {
			"name": "Hull Parts", "tier": Tier.ADVANCED, "volume": 3,
			"price_min": 220, "price_max": 550, "produced_by": ["factory"],
			"consumed_by": ["shipyard", "wharf"],
			"description": "Reinforced hull plating."
		},
		"medical_supplies": {
			"name": "Medical Supplies", "tier": Tier.CONSUMABLE, "volume": 1,
			"price_min": 40, "price_max": 100, "produced_by": ["factory"],
			"consumed_by": ["station", "ship"],
			"description": "Medical supplies for crew."
		},
		"food_rations": {
			"name": "Food Rations", "tier": Tier.CONSUMABLE, "volume": 1,
			"price_min": 12, "price_max": 30, "produced_by": ["farm"],
			"consumed_by": ["station", "ship"],
			"description": "Basic food for crew."
		},
		"microchips": {
			"name": "Microchips", "tier": Tier.ADVANCED, "volume": 1,
			"price_min": 150, "price_max": 400, "produced_by": ["factory"],
			"consumed_by": ["shipyard", "equipment_dock", "research_lab"],
			"description": "Advanced microchips for electronics."
		},
		"turret_components": {
			"name": "Turret Components", "tier": Tier.ADVANCED, "volume": 3,
			"price_min": 400, "price_max": 900, "produced_by": ["factory"],
			"consumed_by": ["shipyard", "wharf"],
			"description": "Components for ship turrets."
		},
		"missile_components": {
			"name": "Missile Components", "tier": Tier.INTERMEDIATE, "volume": 2,
			"price_min": 180, "price_max": 450, "produced_by": ["factory"],
			"consumed_by": ["equipment_dock"],
			"description": "Components for missile production."
		},
		"telescopic_lenses": {
			"name": "Telescopic Lenses", "tier": Tier.INTERMEDIATE, "volume": 1,
			"price_min": 100, "price_max": 250, "produced_by": ["factory"],
			"consumed_by": ["research_lab", "equipment_dock"],
			"description": "Precision optics for scanners."
		},
		"antimatter_cells": {
			"name": "Antimatter Cells", "tier": Tier.ADVANCED, "volume": 2,
			"price_min": 500, "price_max": 1200, "produced_by": ["refinery"],
			"consumed_by": ["shipyard", "factory", "research_lab"],
			"description": "Antimatter for high-energy systems."
		},
		"clothing": {
			"name": "Clothing", "tier": Tier.CONSUMABLE, "volume": 1,
			"price_min": 8, "price_max": 20, "produced_by": ["farm"],
			"consumed_by": ["station", "ship"],
			"description": "Basic clothing for civilians."
		},
		"scrap": {
			"name": "Scrap Metal", "tier": Tier.RAW, "volume": 4,
			"price_min": 5, "price_max": 15, "produced_by": ["scrap_yard"],
			"consumed_by": ["refinery"],
			"description": "Recycled scrap from destroyed ships."
		}
	}

static func get(id: String) -> Dictionary:
	return get_all().get(id, get_all()["energy_cells"])

static func get_tier_name(t: Tier) -> String:
	match t:
		Tier.RAW: return "Raw"
		Tier.INTERMEDIATE: return "Intermediate"
		Tier.ADVANCED: return "Advanced"
		Tier.FINAL: return "Final"
		Tier.CONSUMABLE: return "Consumable"
	return "?"

static func get_station_types() -> Dictionary:
	return {
		"solar_plant": { "name": "Solar Plant", "produces": "energy_cells", "amount_per_cycle": 200, "cycle_time": 60, "cost": 80000, "storage": 5000 },
		"mine": { "name": "Mine", "produces": ["ore", "silicon", "nividium"], "amount_per_cycle": 50, "cycle_time": 120, "cost": 150000, "storage": 10000 },
		"refinery": { "name": "Refinery", "inputs": {"ore": 10, "energy_cells": 20}, "produces": "refined_metals", "amount_per_cycle": 15, "cycle_time": 90, "cost": 350000, "storage": 8000 },
		"factory": { "name": "Factory", "inputs": {"refined_metals": 5, "refined_silicon": 3, "energy_cells": 30}, "cycle_time": 180, "cost": 800000, "storage": 10000 },
		"farm": { "name": "Farm", "produces": ["food_rations", "clothing"], "amount_per_cycle": 50, "cycle_time": 120, "cost": 120000, "storage": 6000 },
		"wharf": { "name": "Wharf", "inputs": {"hull_parts": 20, "engine_parts": 10, "shield_components": 8, "weapon_components": 5, "energy_cells": 100}, "produces": "ships_s", "cycle_time": 300, "cost": 5000000, "storage": 50000 },
		"shipyard": { "name": "Shipyard", "inputs": {"hull_parts": 100, "engine_parts": 50, "shield_components": 40, "weapon_components": 30, "turret_components": 20, "energy_cells": 500}, "produces": "ships_all", "cycle_time": 600, "cost": 20000000, "storage": 200000 },
		"equipment_dock": { "name": "Equipment Dock", "inputs": {"weapon_components": 10, "shield_components": 10, "missile_components": 5, "microchips": 5}, "cycle_time": 120, "cost": 2000000, "storage": 30000 },
		"research_lab": { "name": "Research Lab", "inputs": {"microchips": 10, "antimatter_cells": 5, "telescopic_lenses": 5, "nividium": 2}, "cycle_time": 600, "cost": 5000000, "storage": 15000 },
		"scrap_yard": { "name": "Scrap Yard", "inputs": {"scrap": 20, "energy_cells": 10}, "produces": "refined_metals", "amount_per_cycle": 8, "cycle_time": 60, "cost": 200000, "storage": 20000 }
	}
