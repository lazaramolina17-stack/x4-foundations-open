extends Node
class_name ShipAI

enum AIState { IDLE, PATROL, TRADE, MINE, COMBAT, DOCK, TRAVEL, FLEE, FOLLOW }
enum Personality { PASSIVE, DEFENSIVE, AGRESSIVE, MERCANTILE, MINER }

@export var ship: ShipBase
@export var personality: Personality = Personality.DEFENSIVE

var current_state: AIState = AIState.IDLE
var target_sector: String = ""
var target_station_id: String = ""
var target_ship: ShipBase = null
var patrol_points: Array = []
var patrol_index: int = 0
var command_queue: Array = []
var home_sector: String = ""
var aggro_range: float = 3000.0
var update_interval: float = 2.0
var update_timer: float = 0.0

var universe
var economy
var faction_mgr

func _ready():
	universe = get_tree().root.find_child("UniverseManager", true, false)
	economy = get_tree().root.find_child("EconomyManager", true, false)
	faction_mgr = get_tree().root.find_child("FactionManager", true, false)

func _process(delta):
	if not ship or ship.is_docked: return
	update_timer += delta
	if update_timer >= update_interval:
		update_timer = 0.0
		_update_ai(delta)

func _update_ai(delta):
	match current_state:
		AIState.IDLE:
			_idle_behavior()
		AIState.PATROL:
			_patrol_behavior(delta)
		AIState.TRADE:
			_trade_behavior(delta)
		AIState.MINE:
			_mine_behavior(delta)
		AIState.COMBAT:
			_combat_behavior(delta)
		AIState.DOCK:
			_dock_behavior(delta)
		AIState.TRAVEL:
			_travel_behavior(delta)
		AIState.FLEE:
			_flee_behavior(delta)
		AIState.FOLLOW:
			_follow_behavior(delta)
	_check_threats()

func _idle_behavior():
	if personality == Personality.MERCANTILE:
		set_state(AIState.TRADE)
	elif personality == Personality.MINER:
		set_state(AIState.MINE)
	elif personality == Personality.AGRESSIVE:
		set_state(AIState.PATROL)
	else:
		set_state(AIState.PATROL)

func _patrol_behavior(delta):
	if patrol_points.is_empty():
		_generate_patrol_points()
	if patrol_points.size() > 0:
		var target = patrol_points[patrol_index]
		var dist = ship.global_position.distance_to(target)
		if dist < 500.0:
			patrol_index = (patrol_index + 1) % patrol_points.size()
		else:
			_fly_towards(target, delta)

func _trade_behavior(delta):
	if not economy or not universe: return
	var faction = faction_mgr.get_faction(ship.faction_id)
	var cargo_free = ship.get_free_cargo_space()
	if cargo_free <= 0:
		var res = ship.cargo.keys().pick_random()
		if res:
			var buy_offers = economy.find_buy_offers(res, home_sector)
			if buy_offers.size() > 0:
				var best = buy_offers[0]
				target_station_id = best.station_id
				set_state(AIState.DOCK)
		return

	var all_resources = ResourceData.get_all()
	var candidates = []
	for rid in all_resources:
		var sell_offers = economy.find_sell_offers(rid, home_sector)
		if sell_offers.size() > 0:
			var buy_offers = economy.find_buy_offers(rid, home_sector)
			if buy_offers.size() > 0:
				var cheapest = sell_offers[0]
				var dearest = buy_offers[0]
				if dearest.price > cheapest.price * 1.1:
					candidates.append({ "resource": rid, "buy_at": cheapest.station_id, "sell_at": dearest.station_id, "profit": dearest.price - cheapest.price })
	if candidates.size() > 0:
		candidates.sort_custom(func(a, b): return a.profit > b.profit)
		var best = candidates[0]
		target_station_id = best.buy_at
		set_state(AIState.DOCK)

func _mine_behavior(delta):
	var mineral = "ore"
	var sell_offers = economy.find_buy_offers(mineral, home_sector) if economy else []
	if ship.get_free_cargo_space() <= 0 and sell_offers.size() > 0:
		target_station_id = sell_offers[0].station_id
		set_state(AIState.DOCK)

func _combat_behavior(delta):
	if target_ship and is_instance_valid(target_ship):
		var dist = ship.global_position.distance_to(target_ship.global_position)
		if dist < 1000.0:
			_fly_towards(target_ship.global_position, delta)
			ship.set_throttle(0.5)
		else:
			_fly_towards(target_ship.global_position, delta)
	else:
		set_state(AIState.PATROL)

func _dock_behavior(delta):
	if target_station_id == "": return
	var station = economy.get_station(target_station_id)
	if station.is_empty(): return
	var station_pos: Vector3 = station.get("position", Vector3.ZERO)
	var dist = ship.global_position.distance_to(station_pos)
	if dist < 2000.0:
		_fly_towards(station_pos, delta)
		if dist < 500.0:
			ship.dock_at(target_station_id)
			set_state(AIState.IDLE)
	else:
		set_state(AIState.TRAVEL)

func _travel_behavior(delta):
	if target_sector == "": return
	var target_pos = Vector3.ZERO
	if target_station_id != "":
		var station = economy.get_station(target_station_id)
		if not station.is_empty():
			target_pos = station.get("position", Vector3.ZERO)
	var dist = ship.global_position.distance_to(target_pos)
	if dist < 5000.0:
		set_state(AIState.DOCK)
	else:
		_fly_towards(target_pos, delta)
		ship.activate_travel_mode()

func _flee_behavior(delta):
	var flee_dir = -ship.global_transform.basis.z
	var target_pos = ship.global_position + flee_dir * 10000.0
	_fly_towards(target_pos, delta)

func _follow_behavior(delta):
	if target_ship and is_instance_valid(target_ship):
		var follow_dist = 500.0
		var dist = ship.global_position.distance_to(target_ship.global_position)
		if dist > follow_dist * 2:
			_fly_towards(target_ship.global_position, delta)
		elif dist < follow_dist * 0.5:
			ship.set_throttle(0.0)
		else:
			ship.set_throttle(0.3)
	else:
		set_state(AIState.IDLE)

func _fly_towards(target: Vector3, delta: float):
	var dir = (target - ship.global_position).normalized()
	var forward = -ship.global_transform.basis.z
	var angle = forward.angle_to(dir)
	if angle > 0.05:
		var cross = forward.cross(dir)
		var yaw = cross.y * 2.0
		var pitch = -cross.x * 2.0
		var roll = -cross.z * 0.5
		ship.set_rotation(clampf(yaw, -1, 1), clampf(pitch, -1, 1), clampf(roll, -1, 1))
	ship.set_throttle(1.0)

func _check_threats():
	var space = ship.get_parent()
	if not space: return
	var enemies = get_tree().get_nodes_in_group("ships")
	for e in enemies:
		if e == ship: continue
		if e is ShipBase:
			var es = e as ShipBase
			if faction_mgr and faction_mgr.is_hostile(es.faction_id, ship.faction_id):
				var dist = ship.global_position.distance_to(es.global_position)
				if dist < aggro_range:
					target_ship = es
					if personality == Personality.AGRESSIVE or personality == Personality.DEFENSIVE:
						set_state(AIState.COMBAT)
					else:
						set_state(AIState.FLEE)
					return

func _generate_patrol_points():
	if not home_sector or home_sector == "": return
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(3):
		var x = rng.randf_range(-5000.0, 5000.0)
		var y = rng.randf_range(-5000.0, 5000.0)
		var z = rng.randf_range(-5000.0, 5000.0)
		patrol_points.append(ship.global_position + Vector3(x, y, z))

func set_state(new_state: AIState):
	if current_state != new_state:
		current_state = new_state
		if new_state == AIState.IDLE:
			ship.set_throttle(0.0)
		elif new_state == AIState.TRAVEL:
			ship.activate_travel_mode()
		else:
			ship.deactivate_travel_mode()

func queue_command(command_type: String, target: String):
	command_queue.append({ "type": command_type, "target": target })

func process_command_queue():
	if command_queue.is_empty(): return
	var cmd = command_queue.pop_front()
	match cmd.type:
		"patrol":
			target_sector = cmd.target
			set_state(AIState.PATROL)
		"trade":
			target_station_id = cmd.target
			set_state(AIState.TRADE)
		"attack":
			target_sector = cmd.target
			set_state(AIState.COMBAT)
		"dock":
			target_station_id = cmd.target
			set_state(AIState.DOCK)
