extends Node

signal mission_accepted(mission_id: String)
signal mission_completed(mission_id: String)
signal mission_failed(mission_id: String)
signal mission_updated(mission_id: String, status: String)

enum MissionType { DELIVERY, KILL, PATROL, EXPLORE, BUILD, MINING }
enum MissionDifficulty { EASY, MEDIUM, HARD, VERY_HARD }

var active_missions: Dictionary = {}
var completed_missions: Array = []
var available_missions: Array = []
var mission_counter: int = 0

func generate_missions(count: int = 3):
	available_missions.clear()
	for i in range(count):
		var mission = _create_random_mission()
		if not mission.is_empty():
			available_missions.append(mission)

func _create_random_mission() -> Dictionary:
	var types = [MissionType.DELIVERY, MissionType.KILL, MissionType.PATROL, MissionType.EXPLORE]
	var type = types[randi() % types.size()]
	var difficulty = MissionDifficulty.values()[randi() % 3]
	var reward_mult = [1.0, 2.5, 5.0, 10.0][difficulty]

	var faction_ids = []
	for fid in FactionData.get_all():
		if fid != "xenon" and fid != "player":
			faction_ids.append(fid)
	if faction_ids.is_empty(): return {}
	var giver = faction_ids[randi() % faction_ids.size()]

	var sectors = UniverseManager.get_all_sectors().keys()
	if sectors.is_empty(): return {}
	var target_sector = sectors[randi() % sectors.size()]
	var giver_sector = sectors[randi() % sectors.size()]

	var base_reward = randi_range(5000, 15000)
	var reward = int(base_reward * reward_mult)
	var reputation_reward = 0.01 + 0.02 * difficulty
	var time_limit = 600 + randi_range(0, 600) * (difficulty + 1)

	var mid = "mission_%d" % mission_counter
	mission_counter += 1

	var details = ""
	match type:
		MissionType.DELIVERY:
			var res_list = ResourceData.get_all().keys()
			var resource = res_list[randi() % res_list.size()]
			var amount = randi_range(10, 100) * (difficulty + 1)
			details = "Deliver %d %s to %s" % [amount, ResourceData.get(resource).get("name", resource), UniverseManager.get_display_name(target_sector)]
		MissionType.KILL:
			var count = randi_range(2, 10) * (difficulty + 1)
			details = "Destroy %d ships in %s" % [count, UniverseManager.get_display_name(target_sector)]
		MissionType.PATROL:
			var time = randi_range(60, 300) * (difficulty + 1)
			details = "Patrol %s for %d seconds" % [UniverseManager.get_display_name(target_sector), time]
		MissionType.EXPLORE:
			details = "Explore %s and report" % UniverseManager.get_display_name(target_sector)

	return {
		"id": mid,
		"type": type,
		"difficulty": difficulty,
		"giver": giver,
		"giver_sector": giver_sector,
		"target_sector": target_sector,
		"reward_credits": reward,
		"reward_reputation": reputation_reward,
		"time_limit": time_limit,
		"time_remaining": time_limit,
		"details": details,
		"status": "available",
		"progress": 0,
		"progress_max": 1
	}

func accept_mission(mission_id: String) -> bool:
	for i in range(available_missions.size()):
		if available_missions[i]["id"] == mission_id:
			var m = available_missions[i]
			m["status"] = "active"
			m["time_remaining"] = m["time_limit"]
			active_missions[mission_id] = m
			available_missions.remove_at(i)
			mission_accepted.emit(mission_id)
			return true
	return false

func update_missions(delta: float):
	var to_complete = []
	var to_fail = []

	for mid in active_missions:
		var m = active_missions[mid]
		m["time_remaining"] -= delta
		if m["time_remaining"] <= 0:
			to_fail.append(mid)
			continue

		match m["type"]:
			MissionType.PATROL:
				if GameManager.current_sector_id == m["target_sector"]:
					m["progress"] += delta
					if m["progress"] >= m["progress_max"]:
						to_complete.append(mid)

	for mid in to_complete:
		_complete_mission(mid)
	for mid in to_fail:
		_fail_mission(mid)

func _complete_mission(mission_id: String):
	var m = active_missions.get(mission_id)
	if not m: return
	m["status"] = "completed"
	GameManager.change_credits(m["reward_credits"])
	GameManager.modify_reputation(m["giver"], m["reward_reputation"])
	GameManager.add_notification("Mission completed: +%d cr, +%s reputation" % [m["reward_credits"], m["giver"]], "mission")
	completed_missions.append(m)
	active_missions.erase(mission_id)
	mission_completed.emit(mission_id)

func _fail_mission(mission_id: String):
	var m = active_missions.get(mission_id)
	if not m: return
	m["status"] = "failed"
	GameManager.add_notification("Mission failed: %s" % m.get("details", ""), "warning")
	completed_missions.append(m)
	active_missions.erase(mission_id)
	mission_failed.emit(mission_id)

func get_available_missions() -> Array:
	return available_missions

func get_active_missions() -> Dictionary:
	return active_missions

func get_mission_details(mission_id: String) -> Dictionary:
	return active_missions.get(mission_id, {})
