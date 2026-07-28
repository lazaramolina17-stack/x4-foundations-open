extends Control
class_name ShopMenu

@onready var ship_list: ItemList = $VBoxContainer/MarginContainer/HBoxContainer/ShipPanel/ShipList
@onready var weapon_list: ItemList = $VBoxContainer/MarginContainer/HBoxContainer/WeaponPanel/WeaponList
@onready var upgrade_panel: Panel = $VBoxContainer/MarginContainer/HBoxContainer/UpgradePanel
@onready var close_button: Button = $VBoxContainer/CloseButton
@onready var credits_label: Label = $VBoxContainer/CreditsLabel
@onready var description_label: Label = $VBoxContainer/MarginContainer/HBoxContainer/InfoPanel/DescriptionLabel
@onready var price_label: Label = $VBoxContainer/MarginContainer/HBoxContainer/InfoPanel/PriceLabel
@onready var buy_button: Button = $VBoxContainer/MarginContainer/HBoxContainer/InfoPanel/BuyButton
@onready var equip_button: Button = $VBoxContainer/MarginContainer/HBoxContainer/InfoPanel/EquipButton

var selected_item: String = ""
var selected_category: String = "ship"

var ships_data: Dictionary = {
	"fighter_basic": {"name": "Basic Fighter", "desc": "Standard fighter ship. Good balance of speed and armor.", "cost": 0, "unlocked_by_default": true},
	"fighter_advanced": {"name": "Advanced Fighter", "desc": "Improved fighter with better weapons and armor.", "cost": 2000, "unlocked_by_default": false},
	"interceptor": {"name": "Interceptor", "desc": "Fast but fragile. Excellent for hit-and-run tactics.", "cost": 3000, "unlocked_by_default": false},
	"bomber": {"name": "Bomber", "desc": "Heavy ship with massive firepower but slow speed.", "cost": 5000, "unlocked_by_default": false},
	"stealth_fighter": {"name": "Stealth Fighter", "desc": "Advanced ship with cloaking technology.", "cost": 8000, "unlocked_by_default": false}
}

var weapons_data: Dictionary = {
	"laser_basic": {"name": "Basic Laser", "desc": "Standard laser weapon. Fast fire rate, low damage.", "cost": 0, "unlocked_by_default": true},
	"laser_dual": {"name": "Dual Laser", "desc": "Fires two lasers at once. Double the fire rate.", "cost": 1500, "unlocked_by_default": false},
	"plasma_cannon": {"name": "Plasma Cannon", "desc": "Slow but powerful plasma rounds with splash damage.", "cost": 3000, "unlocked_by_default": false},
	"missile_launcher": {"name": "Missile Launcher", "desc": "Homing missiles with high damage.", "cost": 5000, "unlocked_by_default": false},
	"railgun": {"name": "Railgun", "desc": "Ultra-fast kinetic projectile. Pierces enemies.", "cost": 8000, "unlocked_by_default": false},
	"flak_cannon": {"name": "Flak Cannon", "desc": "Proximity-fuse explosive rounds. Great against groups.", "cost": 4000, "unlocked_by_default": false},
	"beam_laser": {"name": "Beam Laser", "desc": "Continuous beam weapon. High damage but drains energy.", "cost": 6000, "unlocked_by_default": false},
	"ion_cannon": {"name": "Ion Cannon", "desc": "Deals extra shield damage. Can disable enemies.", "cost": 7000, "unlocked_by_default": false}
}

func _ready() -> void:
	_setup_signals()
	_populate_ship_list()
	_populate_weapon_list()

func _setup_signals() -> void:
	close_button.pressed.connect(close)
	ship_list.item_selected.connect(_on_ship_selected)
	weapon_list.item_selected.connect(_on_weapon_selected)
	buy_button.pressed.connect(_on_buy_pressed)
	equip_button.pressed.connect(_on_equip_pressed)
	GameManager.credits_changed.connect(_update_credits)

func _populate_ship_list() -> void:
	ship_list.clear()
	for ship_id in ships_data.keys():
		var data = ships_data[ship_id]
		var is_unlocked = ship_id in PlayerData.unlocked_ships
		var is_equipped = ship_id == PlayerData.current_ship
		
		var text = data["name"]
		if is_unlocked:
			text += " [OWNED]"
		if is_equipped:
			text += " [EQUIPPED]"
		
		var color = Color(1, 1, 1)
		if is_equipped:
			color = Color(0.3, 1, 0.3)
		elif not is_unlocked:
			color = Color(0.7, 0.7, 0.7)
		
		ship_list.add_item(text, null, false)
		ship_list.set_item_text(ship_list.get_item_count() - 1, text)

func _populate_weapon_list() -> void:
	weapon_list.clear()
	for weapon_id in weapons_data.keys():
		var data = weapons_data[weapon_id]
		var is_unlocked = weapon_id in PlayerData.unlocked_weapons
		var is_equipped = weapon_id in PlayerData.equipped_weapons
		
		var text = data["name"]
		if is_unlocked:
			text += " [OWNED]"
		if is_equipped:
			text += " [EQUIPPED]"
		
		var color = Color(1, 1, 1)
		if is_equipped:
			color = Color(0.3, 1, 0.3)
		elif not is_unlocked:
			color = Color(0.7, 0.7, 0.7)
		
		weapon_list.add_item(text, null, false)
		weapon_list.set_item_text(weapon_list.get_item_count() - 1, text)

func _on_ship_selected(index: int) -> void:
	selected_category = "ship"
	var ship_ids = ships_data.keys()
	selected_item = ship_ids[index]
	_show_item_info(selected_item, "ship")

func _on_weapon_selected(index: int) -> void:
	selected_category = "weapon"
	var weapon_ids = weapons_data.keys()
	selected_item = weapon_ids[index]
	_show_item_info(selected_item, "weapon")

func _show_item_info(item_id: String, category: String) -> void:
	var data = {}
	var is_unlocked = false
	var is_equipped = false
	
	if category == "ship":
		data = ships_data[item_id]
		is_unlocked = item_id in PlayerData.unlocked_ships
		is_equipped = item_id == PlayerData.current_ship
	else:
		data = weapons_data[item_id]
		is_unlocked = item_id in PlayerData.unlocked_weapons
		is_equipped = item_id in PlayerData.equipped_weapons
	
	description_label.text = data["desc"]
	
	if is_unlocked:
		price_label.text = "OWNED"
		buy_button.visible = false
		equip_button.visible = is_equipped == false and category == "ship"
	else:
		price_label.text = "Cost: %d credits" % data["cost"]
		buy_button.visible = true
		equip_button.visible = false
	
	buy_button.disabled = is_unlocked or PlayerData.credits < data["cost"]

func _on_buy_pressed() -> void:
	var data = {}
	var cost = 0
	var success = false
	
	if selected_category == "ship":
		data = ships_data[selected_item]
		cost = data["cost"]
		success = GameManager.purchase_ship(selected_item, cost)
	else:
		data = weapons_data[selected_item]
		cost = data["cost"]
		success = GameManager.purchase_weapon(selected_item, cost)
	
	if success:
		if AudioManager:
			AudioManager.play_ui_sound("purchase")
		_populate_ship_list()
		_populate_weapon_list()
		_show_item_info(selected_item, selected_category)
	else:
		if AudioManager:
			AudioManager.play_ui_sound("error")

func _on_equip_pressed() -> void:
	if selected_category == "ship" and selected_item in PlayerData.unlocked_ships:
		GameManager.equip_ship(selected_item)
		_populate_ship_list()
		
		if AudioManager:
			AudioManager.play_ui_sound("select")

func _update_credits(amount: int) -> void:
	var total = PlayerData.credits
	credits_label.text = "Credits: %d" % total

func open() -> void:
	_populate_ship_list()
	_populate_weapon_list()
	_update_credits(0)
	visible = true

func close() -> void:
	visible = false
	if AudioManager:
		AudioManager.play_ui_sound("click")

func _on_close_button_pressed() -> void:
	close()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		close()