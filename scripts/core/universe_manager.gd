extends Node

signal sector_entered(sector_id: String)
signal sector_left(sector_id: String)
signal gate_used(from_sector: String, to_sector: String)

const SECTOR_SIZE: float = 100000.0
const GATE_RADIUS: float = 500.0

var sectors: Dictionary = {}
var gates: Dictionary = {}
var active_sectors: Dictionary = {}
var current_player_sector: String = ""

var sector_seed: int = 42

func _ready():
	_generate_universe()

func _generate_universe():
	var rng = RandomNumberGenerator.new()
	rng.seed = sector_seed

	var faction_list = FactionData.get_all()
	var sector_names = [
		"argon_prime", "the_hole", "black_hole_sun", "ceo_doubt",
		"profit_center_alpha", "grand_exchange", "holy_vision",
		"sacred_relic", "trinity_vii", "xenon_space_1", "xenon_space_2",
		"unknown_alpha", "unknown_beta", "unknown_gamma",
		"eighteen_billion", "hatikvah_choice", "matrix_598",
		"silicon_eddy", "wretched_skies", "tides_of_despair"
	]

	for i in range(sector_names.size()):
		var sid = sector_names[i]
		var x = rng.randf_range(-500.0, 500.0)
		var y = rng.randf_range(-500.0, 500.0)
		var owner: String = "neutral"

		for fid in faction_list:
			var fd = faction_list[fid]
			if fd.has("starting_sectors") and sid in fd["starting_sectors"]:
				owner = fid
				break

		var sec = {
			"id": sid,
			"name": sid.replace("_", " ").capitalize(),
			"galaxy_x": x,
			"galaxy_y": y,
			"owner": owner,
			"security_level": rng.randf_range(0.3, 1.0),
			"sunlight": rng.randf_range(0.3, 1.5),
			"zones": [],
			"stations": [],
			"asteroid_density": rng.randf_range(0.2, 1.0),
			"gate_connections": []
		}
		sectors[sid] = sec

	for sid in sectors:
		var candidates = []
		var sp = sectors[sid]
		for other in sectors:
			if other == sid: continue
			var op = sectors[other]
			var dist = Vector2(sp["galaxy_x"], sp["galaxy_y"]).distance_to(Vector2(op["galaxy_x"], op["galaxy_y"]))
			if dist < 300.0 and rng.randf() < 0.5:
				candidates.append(other)
		var num_gates = clampi(candidates.size(), 1, 3)
		candidates.shuffle()
		for i in range(min(num_gates, candidates.size())):
			var target = candidates[i]
			var gid = "gate_%s_to_%s" % [sid, target]
			sp["gate_connections"].append(target)
			if not gates.has(gid):
				gates[gid] = { "id": gid, "sector_a": sid, "sector_b": target, "position_a": Vector3.ZERO, "position_b": Vector3.ZERO }

func get_sector(sector_id: String) -> Dictionary:
	return sectors.get(sector_id, {})

func get_gate(gate_id: String) -> Dictionary:
	return gates.get(gate_id, {})

func get_gate_between(from_sector: String, to_sector: String) -> String:
	for gid in gates:
		var g = gates[gid]
		if (g.sector_a == from_sector and g.sector_b == to_sector) or (g.sector_a == to_sector and g.sector_b == from_sector):
			return gid
	return ""

func get_connected_sectors(sector_id: String) -> Array:
	var s = sectors.get(sector_id, {})
	return s.get("gate_connections", [])

func get_all_sectors() -> Dictionary:
	return sectors

func get_sectors_owned_by(faction_id: String) -> Array:
	var owned = []
	for sid in sectors:
		if sectors[sid]["owner"] == faction_id:
			owned.append(sid)
	return owned

func get_neighbors(sector_id: String, max_jumps: int = 1) -> Dictionary:
	var result = {}
	var visited = {}
	var queue = [[sector_id, 0]]
	while queue.size() > 0:
		var current = queue.pop_front()
		var sid = current[0]
		var dist = current[1]
		if visited.has(sid): continue
		visited[sid] = true
		if dist > 0:
			result[sid] = dist
		if dist >= max_jumps: continue
		var conn = get_connected_sectors(sid)
		for c in conn:
			if not visited.has(c):
				queue.append([c, dist + 1])
	return result

func enter_sector(sector_id: String):
	if current_player_sector == sector_id: return
	var prev = current_player_sector
	current_player_sector = sector_id
	if prev != "":
		sector_left.emit(prev)
	sector_entered.emit(sector_id)

func find_safe_position_in_sector(sector_id: String) -> Vector3:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var x = rng.randf_range(-SECTOR_SIZE * 0.4, SECTOR_SIZE * 0.4)
	var y = rng.randf_range(-SECTOR_SIZE * 0.4, SECTOR_SIZE * 0.4)
	var z = rng.randf_range(-SECTOR_SIZE * 0.4, SECTOR_SIZE * 0.4)
	return Vector3(x, y, z)

func get_gate_positions_in_sector(sector_id: String) -> Array:
	var positions = []
	for gid in gates:
		var g = gates[gid]
		if g.sector_a == sector_id:
			positions.append({ "gate_id": gid, "position": g.position_a, "target_sector": g.sector_b })
		elif g.sector_b == sector_id:
			positions.append({ "gate_id": gid, "position": g.position_b, "target_sector": g.sector_a })
	return positions

func get_display_name(sector_id: String) -> String:
	var s = sectors.get(sector_id, {})
	return s.get("name", sector_id)
