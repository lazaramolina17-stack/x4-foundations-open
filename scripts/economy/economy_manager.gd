extends Node
class_name EconomyManager

signal price_changed(resource_id: String, station_id: String, price: float)
signal station_produced(station_id: String, resource_id: String, amount: int)
signal trade_completed(buyer_id: String, seller_id: String, resource_id: String, amount: int, price: float)

var stations: Dictionary = {}
var trade_routes: Array = []
var production_queue: Dictionary = {}

func register_station(station_id: String, station_data: Dictionary):
	stations[station_id] = station_data
	stations[station_id]["storage"] = {}
	stations[station_id]["production_progress"] = 0.0
	stations[station_id]["active"] = true

func unregister_station(station_id: String):
	stations.erase(station_id)

func get_station(station_id: String) -> Dictionary:
	return stations.get(station_id, {})

func get_stations_in_sector(sector_id: String) -> Dictionary:
	var result = {}
	for sid in stations:
		if stations[sid]["sector"] == sector_id:
			result[sid] = stations[sid]
	return result

func get_stations_owned_by(faction_id: String) -> Dictionary:
	var result = {}
	for sid in stations:
		if stations[sid]["faction"] == faction_id:
			result[sid] = stations[sid]
	return result

func update_economy(delta: float):
	for sid in stations:
		var s = stations[sid]
		if not s["active"]: continue
		_process_station_production(sid, s, delta)
		_update_prices(sid, s)

func _process_station_production(station_id: String, s: Dictionary, delta: float):
	var station_type = ResourceData.get_station_types().get(s["station_type"])
	if not station_type: return

	s["production_progress"] += delta * s.get("production_speed", 1.0)

	var cycle_time = station_type["cycle_time"]
	if s["production_progress"] >= cycle_time:
		s["production_progress"] -= cycle_time

		var can_produce = true
		if station_type.has("inputs"):
			for input_res in station_type["inputs"]:
				var needed = station_type["inputs"][input_res]
				if s["storage"].get(input_res, 0) < needed:
					can_produce = false
					break

		if can_produce:
			if station_type.has("inputs"):
				for input_res in station_type["inputs"]:
					var needed = station_type["inputs"][input_res]
					s["storage"][input_res] = s["storage"].get(input_res, 0) - needed

			var output = station_type.get("produces", "")
			if output is Array:
				for res in output:
					var amount = station_type.get("amount_per_cycle", 10)
					s["storage"][res] = s["storage"].get(res, 0) + amount
					station_produced.emit(station_id, res, amount)
			elif output != "":
				var amount = station_type.get("amount_per_cycle", 10)
				s["storage"][output] = s["storage"].get(output, 0) + amount
				station_produced.emit(station_id, output, amount)

func _update_prices(station_id: String, s: Dictionary):
	var station_type = ResourceData.get_station_types().get(s["station_type"], {})
	if station_type.has("inputs"):
		for res in station_type["inputs"]:
			var data = ResourceData.get(res)
			var stored = s["storage"].get(res, 0)
			var capacity = station_type.get("storage", 10000)
			var fill_ratio = float(stored) / float(capacity) if capacity > 0 else 0.0
			var price = lerpf(data["price_max"], data["price_min"], fill_ratio)
			price = snapped(price, 1.0)
			var old = s.get("buy_prices", {}).get(res, 0)
			if not s.has("buy_prices"): s["buy_prices"] = {}
			s["buy_prices"][res] = price
			if old != price:
				price_changed.emit(res, station_id, price)

	if station_type.has("produces"):
		var outputs = station_type["produces"]
		if outputs is String: outputs = [outputs]
		for res in outputs:
			var data = ResourceData.get(res)
			var stored = s["storage"].get(res, 0)
			var capacity = station_type.get("storage", 10000)
			var fill_ratio = float(stored) / float(capacity) if capacity > 0 else 0.0
			var price = lerpf(data["price_min"], data["price_max"], fill_ratio)
			price = snapped(price, 1.0)
			var old = s.get("sell_prices", {}).get(res, 0)
			if not s.has("sell_prices"): s["sell_prices"] = {}
			s["sell_prices"][res] = price
			if old != price:
				price_changed.emit(res, station_id, price)

func get_buy_price(station_id: String, resource_id: String) -> float:
	var s = stations.get(station_id, {})
	return s.get("buy_prices", {}).get(resource_id, ResourceData.get(resource_id)["price_max"])

func get_sell_price(station_id: String, resource_id: String) -> float:
	var s = stations.get(station_id, {})
	return s.get("sell_prices", {}).get(resource_id, ResourceData.get(resource_id)["price_max"])

func get_station_storage(station_id: String, resource_id: String) -> int:
	var s = stations.get(station_id, {})
	return s.get("storage", {}).get(resource_id, 0)

func add_to_storage(station_id: String, resource_id: String, amount: int):
	var s = stations.get(station_id)
	if not s: return
	s["storage"][resource_id] = s["storage"].get(resource_id, 0) + amount

func remove_from_storage(station_id: String, resource_id: String, amount: int) -> bool:
	var s = stations.get(station_id)
	if not s: return false
	var current = s["storage"].get(resource_id, 0)
	if current < amount: return false
	s["storage"][resource_id] = current - amount
	return true

func find_buy_offers(resource_id: String, sector_id: String = "") -> Array:
	var offers = []
	for sid in stations:
		var s = stations[sid]
		if sector_id != "" and s["sector"] != sector_id: continue
		var station_type = ResourceData.get_station_types().get(s["station_type"], {})
		if station_type.has("inputs") and station_type["inputs"].has(resource_id):
			var price = get_buy_price(sid, resource_id)
			var stored = get_station_storage(sid, resource_id)
			var max_storage = station_type.get("storage", 10000)
			var needed = max_storage - stored
			if needed > 0:
				offers.append({ "station_id": sid, "resource": resource_id, "price": price, "amount": needed, "type": "buy" })
	return offers

func find_sell_offers(resource_id: String, sector_id: String = "") -> Array:
	var offers = []
	for sid in stations:
		var s = stations[sid]
		if sector_id != "" and s["sector"] != sector_id: continue
		var station_type = ResourceData.get_station_types().get(s["station_type"], {})
		var output = station_type.get("produces", [])
		if output is String: output = [output]
		if resource_id in output:
			var price = get_sell_price(sid, resource_id)
			var stored = get_station_storage(sid, resource_id)
			if stored > 0:
				offers.append({ "station_id": sid, "resource": resource_id, "price": price, "amount": stored, "type": "sell" })
	return offers

func execute_trade(buyer_id: String, seller_id: String, resource_id: String, amount: int) -> bool:
	if not stations.has(buyer_id) or not stations.has(seller_id): return false
	var buy_price = get_buy_price(buyer_id, resource_id)
	var sell_price = get_sell_price(seller_id, resource_id)
	if sell_price <= 0 or buy_price <= 0: return false
	if remove_from_storage(seller_id, resource_id, amount):
		add_to_storage(buyer_id, resource_id, amount)
		var trade_price = (buy_price + sell_price) / 2.0
		trade_completed.emit(buyer_id, seller_id, resource_id, amount, trade_price)
		return true
	return false
