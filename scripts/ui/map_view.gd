extends Control
class_name MapView

signal sector_selected(sector_id: String)
signal travel_requested(sector_id: String)

var zoom_level: float = 1.0
var pan_offset: Vector2 = Vector2.ZERO
var selected_sector: String = ""
var known_sectors: Array = []
var player_sector: String = ""

var universe: UniverseManager
var faction_mgr: FactionManager

func _ready():
	universe = get_tree().root.find_child("UniverseManager", true, false)
	faction_mgr = get_tree().root.find_child("FactionManager", true, false)
	player_sector = GameManager.current_sector_id
	known_sectors = universe.get_all_sectors().keys()
	add_to_group("map_view")

func _draw():
	if not universe: return
	var sectors = universe.get_all_sectors()
	var center = Vector2(size.x / 2, size.y / 2)
	var scale_factor = min(size.x, size.y) / 1200.0 * zoom_level

	for sid in sectors:
		var s = sectors[sid]
		var pos = Vector2(s["galaxy_x"], s["galaxy_y"]) * scale_factor + center + pan_offset
		var is_player = (sid == player_sector)
		var is_selected = (sid == selected_sector)
		var radius = 12.0 * (1.5 if is_player else 1.0)

		var color = Color(0.3, 0.3, 0.5)
		if faction_mgr:
			color = faction_mgr.get_faction_color(s["owner"])

		draw_circle(pos, radius + (4 if is_selected else 0), Color(1, 1, 0) if is_selected else Color(0.2, 0.2, 0.3))
		draw_circle(pos, radius, color)

		if is_player:
			draw_circle(pos, radius + 4, Color(1, 0.8, 0), false, 2.0)

		for conn in s.get("gate_connections", []):
			var other = sectors.get(conn)
			if other:
				var other_pos = Vector2(other["galaxy_x"], other["galaxy_y"]) * scale_factor + center + pan_offset
				draw_line(pos, other_pos, Color(0.3, 0.5, 0.8, 0.5), 1.0)

		var label = s.get("name", sid).substr(0, 12)
		draw_string(ThemeDB.fallback_font, pos + Vector2(radius + 4, -4), label, HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color(0.8, 0.8, 0.9))

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_level *= 1.2
			queue_redraw()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_level /= 1.2
			queue_redraw()
		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_handle_click(event.position)
	if event is InputEventMouseMotion and event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
		pan_offset += event.relative * 0.5
		queue_redraw()

func _handle_click(pos: Vector2):
	if not universe: return
	var sectors = universe.get_all_sectors()
	var center = Vector2(size.x / 2, size.y / 2)
	var scale_factor = min(size.x, size.y) / 1200.0 * zoom_level
	var closest = ""
	var closest_dist = 30.0

	for sid in sectors:
		var s = sectors[sid]
		var spos = Vector2(s["galaxy_x"], s["galaxy_y"]) * scale_factor + center + pan_offset
		var dist = pos.distance_to(spos)
		if dist < closest_dist:
			closest_dist = dist
			closest = sid

	if closest != "":
		selected_sector = closest
		sector_selected.emit(closest)
		queue_redraw()

func request_travel():
	if selected_sector != "" and selected_sector != player_sector:
		travel_requested.emit(selected_sector)
		player_sector = selected_sector
		GameManager.travel_to_sector(selected_sector)
		queue_redraw()

func show():
	visible = true
	queue_redraw()

func hide():
	visible = false
