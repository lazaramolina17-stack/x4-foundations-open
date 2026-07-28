extends Node

var sector_scene: SectorScene = null
var map_view: MapView
var trade_menu: TradeMenu
var mission_mgr

func _ready():
	map_view = $MapView
	trade_menu = $TradeMenu
	mission_mgr = get_tree().root.find_child("MissionManager", true, false)

	map_view.travel_requested.connect(_on_travel_requested)
	map_view.sector_selected.connect(_on_sector_selected)
	$MapView/TravelButton.pressed.connect(_on_travel_button)
	$MapView/CloseMap.pressed.connect(_on_close_map)
	$TradeMenu/CloseTrade.pressed.connect(_on_close_trade)
	trade_menu.menu_closed.connect(_on_trade_closed)

	GameManager.sector_changed.connect(_on_sector_changed)
	TimeManager.time_tick.connect(_on_time_tick)
	GameManager.player_credits_changed.connect(_on_credits_changed)

	_load_sector(GameManager.current_sector_id)

	if mission_mgr:
		mission_mgr.generate_missions(3)

func _load_sector(sector_id: String):
	if sector_scene:
		sector_scene.queue_free()
	sector_scene = preload("res://scenes/sector.tscn").instantiate()
	sector_scene.init(sector_id)
	$SectorContainer.add_child(sector_scene)
	_update_hud_sector(sector_id)

func _on_sector_changed(sector_id: String):
	_load_sector(sector_id)

func _process(delta):
	_update_hud()
	if mission_mgr:
		mission_mgr.update_missions(delta)

func _update_hud():
	var ship = GameManager.player_ship
	if not ship: return
	$HUD/SpeedLabel.text = "Speed: %s" % ship.get_speed_string()
	$HUD/ShieldLabel.text = "Shield: %d%%" % (ship.get_shield_percent() * 100)
	$HUD/HullLabel.text = "Hull: %d%%" % (ship.get_hull_percent() * 100)
	$HUD/CreditsLabel.text = "Credits: %d cr" % GameManager.player_credits

	var target_text = ""
	if ship.target_object and is_instance_valid(ship.target_object):
		target_text = ship.get_target_info()
	$HUD/TargetInfo.text = target_text

func _update_hud_sector(sector_id: String):
	$HUD/SectorLabel.text = "Sector: %s" % UniverseManager.get_display_name(sector_id)

func _on_time_tick(day: int, hour: int, minute: int):
	$HUD/TimeLabel.text = "Day %d, %02d:%02d" % [day, hour, minute]

func _on_credits_changed(amount: int):
	$HUD/CreditsLabel.text = "Credits: %d cr" % amount

func _on_sector_selected(sector_id: String):
	pass

func _on_travel_requested(sector_id: String):
	GameManager.travel_to_sector(sector_id)

func _on_travel_button():
	if map_view:
		map_view.request_travel()

func _on_close_map():
	var ship = GameManager.player_ship
	if ship:
		ship.is_in_menu = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	map_view.visible = false

func _on_close_trade():
	trade_menu.close()
	var ship = GameManager.player_ship
	if ship:
		ship.is_in_menu = false
		ship.undock()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_trade_closed():
	var ship = GameManager.player_ship
	if ship:
		ship.is_in_menu = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event.is_action_pressed("pause"):
		TimeManager.toggle_pause()
