extends Control
class_name TradeMenu

signal trade_executed(resource_id: String, amount: int, total_price: int)
signal menu_closed

var current_station_id: String = ""
var current_ship: ShipBase = null
var economy
var offers: Dictionary = {}

func _ready():
	economy = get_tree().root.find_child("EconomyManager", true, false)

func open(station_id: String, ship: ShipBase):
	current_station_id = station_id
	current_ship = ship
	visible = true
	_refresh_offers()

func close():
	visible = false
	menu_closed.emit()

func _refresh_offers():
	if not economy or current_station_id == "": return
	offers = {}
	var station = economy.get_station(current_station_id)
	if station.is_empty(): return
	var station_type = ResourceData.get_station_types().get(station.get("station_type", ""), {})

	var sell_list = []
	if station_type.has("produces"):
		var outputs = station_type["produces"]
		if outputs is String: outputs = [outputs]
		for res in outputs:
			var stored = economy.get_station_storage(current_station_id, res)
			if stored > 0:
				var price = economy.get_sell_price(current_station_id, res)
				sell_list.append({ "resource": res, "price": price, "available": stored })

	var buy_list = []
	if station_type.has("inputs"):
		for res in station_type["inputs"]:
			var stored = economy.get_station_storage(current_station_id, res)
			var max_storage = station_type.get("storage", 10000)
			var needed = max_storage - stored
			if needed > 0:
				var price = economy.get_buy_price(current_station_id, res)
				buy_list.append({ "resource": res, "price": price, "demand": needed })

	offers["sell"] = sell_list
	offers["buy"] = buy_list

func buy(resource_id: String, amount: int) -> bool:
	if not economy or current_station_id == "" or not current_ship: return false
	var price = economy.get_sell_price(current_station_id, resource_id)
	var total = int(price) * amount
	if total > GameManager.player_credits: return false
	if not economy.remove_from_storage(current_station_id, resource_id, amount): return false
	if not current_ship.add_cargo(resource_id, amount):
		economy.add_to_storage(current_station_id, resource_id, amount)
		return false
	GameManager.change_credits(-total)
	trade_executed.emit(resource_id, amount, total)
	_refresh_offers()
	return true

func sell(resource_id: String, amount: int) -> bool:
	if not economy or current_station_id == "" or not current_ship: return false
	if not current_ship.remove_cargo(resource_id, amount): return false
	var price = economy.get_buy_price(current_station_id, resource_id)
	var total = int(price) * amount
	economy.add_to_storage(current_station_id, resource_id, amount)
	GameManager.change_credits(total))
	trade_executed.emit(resource_id, amount, total)
	_refresh_offers()
	return true

func get_offers() -> Dictionary:
	return offers
