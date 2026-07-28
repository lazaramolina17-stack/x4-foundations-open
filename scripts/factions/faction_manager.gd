extends Node
class_name FactionManager

signal relation_changed(faction_a: String, faction_b: String, new_standing: float)
signal war_declared(attacker: String, defender: String)
signal peace_declared(faction_a: String, faction_b: String)
signal faction_fleet_destroyed(faction_id: String, fleet_size: int)

var factions: Dictionary = {}
var relations: Dictionary = {}

func _ready():
	_init_factions()

func _init_factions():
	var all_data = FactionData.get_all()
	for fid in all_data:
		var data = all_data[fid].duplicate(true)
		data["money"] = 1000000
		data["fleet_strength"] = 50
		data["station_count"] = 0
		data["active"] = true
		data["aggression"] = data.get("aggression", 0.5)
		factions[fid] = data

		if data.has("starting_relations"):
			for other in data["starting_relations"]:
				var key = _rel_key(fid, other)
				relations[key] = data["starting_relations"][other]

	for fid in factions:
		for other in factions:
			if fid == other: continue
			var key = _rel_key(fid, other)
			if not relations.has(key):
				relations[key] = 0.0

func _rel_key(a: String, b: String) -> String:
	return a + "_" + b if a < b else b + "_" + a

func get_relation(faction_a: String, faction_b: String) -> float:
	return relations.get(_rel_key(faction_a, faction_b), 0.0)

func modify_relation(faction_a: String, faction_b: String, delta: float):
	var key = _rel_key(faction_a, faction_b)
	var current = relations.get(key, 0.0)
	var new_val = clampf(current + delta, -1.0, 1.0)
	relations[key] = new_val
	relation_changed.emit(faction_a, faction_b, new_val)

func get_faction(faction_id: String) -> Dictionary:
	return factions.get(faction_id, {})

func get_all_factions() -> Dictionary:
	return factions

func get_standing_label(faction_a: String, faction_b: String) -> String:
	return FactionData.get_relation_threshold(get_relation(faction_a, faction_b))

func is_hostile(faction_a: String, faction_b: String) -> bool:
	return get_relation(faction_a, faction_b) < -0.5

func is_allied(faction_a: String, faction_b: String) -> bool:
	return get_relation(faction_a, faction_b) > 0.6

func get_enemies(faction_id: String) -> Array:
	var enemies = []
	for other in factions:
		if other == faction_id: continue
		if is_hostile(faction_id, other):
			enemies.append(other)
	return enemies

func get_allies(faction_id: String) -> Array:
	var allies = []
	for other in factions:
		if other == faction_id: continue
		if is_allied(faction_id, other):
			allies.append(other)
	return allies

func get_relation_weighted(faction_id: String) -> Dictionary:
	var result = {}
	for other in factions:
		if other == faction_id: continue
		var rel = get_relation(faction_id, other)
		result[other] = rel
	return result

func update_factions(delta: float, universe: UniverseManager, economy: EconomyManager):
	for fid in factions:
		var f = factions[fid]
		if not f["active"]: continue
		if f["personality"] == "player": continue

		f["money"] += delta * 100.0 * f["economy_focus"]

		var enemies = get_enemies(fid)
		var allies = get_allies(fid)

		if enemies.size() > 0 and f["aggression"] > 0.6:
			var target = enemies[0]
			var target_sectors = universe.get_sectors_owned_by(target)
			if target_sectors.size() > 0 and randf() < 0.001 * delta * f["aggression"]:
				var fleet_size = randi_range(1, 3)
				war_declared.emit(fid, target)

		var owned_sectors = universe.get_sectors_owned_by(fid)
		for sid in owned_sectors:
			var sector = universe.get_sector(sid)
			if sector.is_empty(): continue
			var stations_in_sector = economy.get_stations_in_sector(sid)
			var station_count = stations_in_sector.size()
			if station_count < 2 and f["money"] > 500000:
				f["money"] -= 300000
				f["station_count"] += 1
				var station_type = ["solar_plant", "mine", "farm"].pick_random()
				var station_id = "%s_%s_%d" % [fid, station_type, f["station_count"]]
				economy.register_station(station_id, {
					"id": station_id, "station_type": station_type,
					"faction": fid, "sector": sid,
					"production_speed": 1.0,
					"position": universe.find_safe_position_in_sector(sid)
				})

func get_faction_color(faction_id: String) -> Color:
	var f = factions.get(faction_id, {})
	return f.get("color", Color.WHITE)

func declare_war(attacker: String, defender: String):
	modify_relation(attacker, defender, -0.5)
	modify_relation(defender, attacker, -0.5)
	war_declared.emit(attacker, defender)

func make_peace(faction_a: String, faction_b: String):
	modify_relation(faction_a, faction_b, 0.3)
	modify_relation(faction_b, faction_a, 0.3)
	peace_declared.emit(faction_a, faction_b)
