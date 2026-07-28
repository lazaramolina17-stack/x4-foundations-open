extends Node3D
class_name Station

signal player_docked(ship: ShipBase)
signal docking_request(ship: ShipBase)

var station_id: String = ""
var station_type: String = "solar_plant"
var faction_id: String = "argon"
var sector_id: String = ""

var station_data: Dictionary = {}
var docked_ships: Array = []
var max_dock_slots: int = 5
var is_hostile: bool = false

var economy_manager: EconomyManager
var faction_manager: FactionManager

func _ready():
	add_to_group("stations")
	economy_manager = get_tree().root.find_child("EconomyManager", true, false)
	faction_manager = get_tree().root.find_child("FactionManager", true, false)

func init(id: String, type_name: String, faction: String, sector: String):
	station_id = id
	station_type = type_name
	faction_id = faction
	sector_id = sector
	station_data = ResourceData.get_station_types().get(type_name, {})
	if economy_manager and not economy_manager.get_station(id).has("id"):
		economy_manager.register_station(station_id, {
			"id": station_id,
			"station_type": station_type,
			"faction": faction_id,
			"sector": sector,
			"production_speed": 1.0,
			"position": global_position
		})

func handle_dock(ship: ShipBase):
	if docked_ships.size() >= max_dock_slots:
		return false
	if ship.faction_id != faction_id and faction_manager:
		var rel = faction_manager.get_relation(ship.faction_id, faction_id)
		if rel < -0.3:
			return false
	docked_ships.append(ship)
	docking_request.emit(ship)
	if ship.is_player_ship:
		player_docked.emit(ship)
	return true

func handle_undock(ship: ShipBase):
	docked_ships.erase(ship)

func get_station_info() -> String:
	var type_info = station_data
	var info = "%s\nType: %s\nFaction: %s\n" % [station_id, type_info.get("name", "Unknown"), FactionData.get(faction_id).get("name", faction_id)]
	if economy_manager:
		var e = economy_manager.get_station(station_id)
		if not e.is_empty():
			info += "\nStorage:\n"
			for res in e.get("storage", {}):
				var amount = e["storage"][res]
				var res_name = ResourceData.get(res).get("name", res)
				info += "  %s: %d\n" % [res_name, amount]
			info += "\nBuying:\n"
			for res in e.get("buy_prices", {}):
				info += "  %s: %d cr\n" % [ResourceData.get(res).get("name", res), e["buy_prices"][res]]
			info += "\nSelling:\n"
			for res in e.get("sell_prices", {}):
				info += "  %s: %d cr\n" % [ResourceData.get(res).get("name", res), e["sell_prices"][res]]
	return info

func get_trade_offers() -> Dictionary:
	var result = { "buy": [], "sell": [] }
	if not economy_manager: return result
	var e = economy_manager.get_station(station_id)
	if e.is_empty(): return result
	for res in e.get("buy_prices", {}):
		var stored = economy_manager.get_station_storage(station_id, res)
		var max_storage = station_data.get("storage", 10000)
		if stored < max_storage:
			result["buy"].append({ "resource": res, "price": e["buy_prices"][res], "demand": max_storage - stored })
	for res in e.get("sell_prices", {}):
		var stored = economy_manager.get_station_storage(station_id, res)
		if stored > 0:
			result["sell"].append({ "resource": res, "price": e["sell_prices"][res], "available": stored })
	return result

func get_display_name() -> String:
	return station_data.get("name", station_type)

func _on_ship_entered_range(ship: ShipBase, range_dist: float):
	if ship.is_player_ship:
		pass
