extends Node
class_name GameManager

signal game_loaded
signal game_saved
signal sector_changed(sector_id: String)
signal player_credits_changed(amount: int)
signal notification(message: String, type: String)

var universe: UniverseManager
var economy: EconomyManager
var faction_mgr: FactionManager
var time_mgr: TimeManager

var player_ship: PlayerShip = null
var player_faction_id: String = "player"
var player_credits: int = 50000
var player_reputation: Dictionary = {}

var current_sector_id: String = "argon_prime"
var game_time: float = 0.0
var is_loaded: bool = false

var notification_history: Array = []

func _ready():
	universe = UniverseManager.new()
	economy = EconomyManager.new()
	faction_mgr = FactionManager.new()
	time_mgr = TimeManager.new()

	add_child(universe)
	add_child(economy)
	add_child(faction_mgr)
	add_child(time_mgr)

	for fid in FactionData.get_all():
		player_reputation[fid] = 0.0

	add_to_group("game_manager")
	Engine.max_fps = 60

func _process(delta):
	if not is_loaded: return
	game_time += delta
	economy.update_economy(delta * 10.0)
	faction_mgr.update_factions(delta, universe, economy)

func start_new_game():
	var start_sector = "argon_prime"
	current_sector_id = start_sector
	universe.enter_sector(start_sector)
	_spawn_initial_stations()
	is_loaded = true
	game_loaded.emit()
	add_notification("Game started in %s" % universe.get_display_name(start_sector), "info")

func _spawn_initial_stations():
	for fid in FactionData.get_all():
		var f = FactionData.get(fid)
		if f.has("starting_sectors"):
			for sector in f["starting_sectors"]:
				var num_stations = randi_range(2, 4)
				for i in range(num_stations):
					var types = ["solar_plant", "mine", "farm", "refinery", "factory"]
					var stype = types[randi() % types.size()]
					var sid = "%s_%s_%d" % [fid, stype, i]
					economy.register_station(sid, {
						"id": sid, "station_type": stype,
						"faction": fid, "sector": sector,
						"production_speed": 1.0 + randf() * 0.5,
						"position": universe.find_safe_position_in_sector(sector)
					})

func change_credits(amount: int):
	player_credits += amount
	player_credits_changed.emit(player_credits)

func can_afford(amount: int) -> bool:
	return player_credits >= amount

func add_notification(message: String, type: String = "info"):
	notification_history.append({ "message": message, "type": type, "time": game_time })
	notification.emit(message, type)

func get_reputation(faction_id: String) -> float:
	return player_reputation.get(faction_id, 0.0)

func modify_reputation(faction_id: String, delta: float):
	var current = player_reputation.get(faction_id, 0.0)
	player_reputation[faction_id] = clampf(current + delta, -1.0, 1.0)
	var label = FactionData.get_relation_threshold(player_reputation[faction_id])
	add_notification("Reputation with %s: %s" % [FactionData.get(faction_id).get("name", faction_id), label], "reputation")

func save_game(slot: int = 0):
	var data = {
		"credits": player_credits,
		"sector": current_sector_id,
		"time": game_time,
		"reputation": player_reputation,
		"version": 1
	}
	var file = FileAccess.open("user://save_%d.sav" % slot, FileAccess.WRITE)
	if file:
		file.store_var(data)
		file.close()
		add_notification("Game saved to slot %d" % slot, "info")

func load_game(slot: int = 0) -> bool:
	var file = FileAccess.open("user://save_%d.sav" % slot, FileAccess.READ)
	if not file: return false
	var data = file.get_var()
	file.close()
	if not data: return false
	player_credits = data.get("credits", 50000)
	current_sector_id = data.get("sector", "argon_prime")
	game_time = data.get("time", 0.0)
	player_reputation = data.get("reputation", {})
	is_loaded = true
	game_loaded.emit()
	add_notification("Game loaded from slot %d" % slot, "info")
	return true

func travel_to_sector(sector_id: String):
	if universe.get_sector(sector_id).is_empty():
		add_notification("Sector %s not found!" % sector_id, "error")
		return
	current_sector_id = sector_id
	universe.enter_sector(sector_id)
	sector_changed.emit(sector_id)
	add_notification("Entering %s" % universe.get_display_name(sector_id), "info")
