extends ShipBase
class_name PlayerShip

signal target_selected(target: Node3D)
signal travel_mode_changed(active: bool)

var mouse_sensitivity: float = 0.003
var invert_y: bool = false
var is_in_menu: bool = false

var target_object: Node3D = null
var targeted_ship: ShipBase = null
var targeted_station_id: String = ""

var scan_range: float = 500.0

var weapon_system: WeaponSystem

func _ready():
	is_player_ship = true
	set_process_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	weapon_system = WeaponSystem.new()
	add_child(weapon_system)
	weapon_system.add_weapon("laser_mk1")
	weapon_system.add_weapon("laser_mk1")

func _input(event):
	if is_in_menu: return

	if event is InputEventMouseMotion:
		input_yaw = -event.relative.x * mouse_sensitivity
		input_pitch = event.relative.y * mouse_sensitivity * (-1.0 if invert_y else 1.0)
	elif event is InputEventKey:
		match event.keycode:
			KEY_W: input_throttle = 1.0 if event.pressed else 0.0
			KEY_S: input_throttle = -0.5 if event.pressed else 0.0
			KEY_A: input_strafe_h = -1.0 if event.pressed else 0.0
			KEY_D: input_strafe_h = 1.0 if event.pressed else 0.0
			KEY_Q: input_roll = -1.0 if event.pressed else 0.0
			KEY_E: input_roll = 1.0 if event.pressed else 0.0
			KEY_SPACE: input_strafe_v = 1.0 if event.pressed else 0.0
			KEY_SHIFT: input_strafe_v = -1.0 if event.pressed else 0.0
			KEY_TAB: if event.pressed: _toggle_travel_mode()
			KEY_F: if event.pressed: _interact()
			KEY_R: if event.pressed: _cycle_targets()
			KEY_T: if event.pressed: _select_target_ahead()
			KEY_M: if event.pressed: _toggle_map()
			KEY_1: if event.pressed and weapon_system: weapon_system.switch_weapon(-1)
			KEY_2: if event.pressed and weapon_system: weapon_system.switch_weapon(1)
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if weapon_system: weapon_system.set_firing(event.pressed)

func _toggle_travel_mode():
	if travel_active:
		deactivate_travel_mode()
	else:
		activate_travel_mode()
	travel_mode_changed.emit(travel_active)

func _interact():
	var dockable = []
	var all_stations = get_tree().get_nodes_in_group("stations")
	for child in all_stations:
		if child is Station and child.faction_id != "xenon":
			var dist = global_position.distance_to(child.global_position)
			if dist < 5000.0:
				dockable.append({ "node": child, "dist": dist })
	if dockable.size() > 0:
		dockable.sort_custom(func(a, b): return a.dist < b.dist)
		var nearest = dockable[0].node
		if is_docked:
			undock()
		else:
			dock_at(nearest.station_id)
			nearest.handle_dock(self)
			var trade_ui = get_tree().get_first_node_in_group("trade_menu")
			if trade_ui:
				trade_ui.open(nearest.station_id, self)

func _cycle_targets():
	var space = get_parent()
	if not space: return
	var ships = get_tree().get_nodes_in_group("ships")
	var visible = []
	for s in ships:
		if s == self: continue
		var dist = global_position.distance_to(s.global_position)
		if dist < scan_range:
			visible.append(s)
	if visible.size() > 0:
		var idx = 0
		if target_object and target_object in visible:
			idx = (visible.find(target_object) + 1) % visible.size()
		target_object = visible[idx]
		if target_object is ShipBase:
			targeted_ship = target_object
		target_selected.emit(target_object)

func _select_target_ahead():
	var space = get_parent()
	if not space: return
	var forward = -global_transform.basis.z
	var best: Node3D = null
	var best_angle = 999.0
	var ships = get_tree().get_nodes_in_group("ships")
	for s in ships:
		if s == self: continue
		var dir_to = (s.global_position - global_position).normalized()
		var angle = forward.angle_to(dir_to)
		if angle < best_angle and angle < 0.3:
			best_angle = angle
			best = s
	if best:
		target_object = best
		if best is ShipBase:
			targeted_ship = best
		target_selected.emit(best)
	else:
		var stations = get_tree().get_nodes_in_group("stations")
		for s in stations:
			var dir_to = (s.global_position - global_position).normalized()
			var angle = forward.angle_to(dir_to)
			if angle < best_angle and angle < 0.3:
				best_angle = angle
				best = s
		if best:
			target_object = best
			target_selected.emit(best)

func _toggle_map():
	is_in_menu = not is_in_menu
	if is_in_menu:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var map_ui = get_tree().get_first_node_in_group("map_view")
	if map_ui:
		map_ui.visible = is_in_menu

func get_target_distance() -> float:
	if target_object:
		return global_position.distance_to(target_object.global_position)
	return 0.0

func get_target_info() -> String:
	if not target_object: return "No target"
	var info = ""
	if target_object is ShipBase:
		var ts = target_object as ShipBase
		var sd = ShipData.get(ts.ship_id)
		var faction_name = FactionData.get(ts.faction_id).get("name", ts.faction_id)
		info = "%s (%s) - %s" % [sd.get("name", "Unknown"), ShipData.get_class_name(sd.get("class", ShipData.ShipClass.S)), faction_name]
		info += "\nHull: %d/%d  Shield: %d/%d" % [ts.current_hull, ts.max_hull, ts.current_shield, ts.max_shield]
		info += "\nDistance: %d m" % get_target_distance()
	elif target_object is Station:
		var st = target_object as Station
		info = st.get_station_info()
	return info

func die():
	if current_hull <= 0:
		ship_destroyed.emit(ship_id)
