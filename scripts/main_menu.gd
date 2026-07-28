extends Control
class_name MainMenu

@onready var title_label: Label = $TitleLabel
@onready var start_button: Button = $MenuButtons/StartButton
@onready var continue_button: Button = $MenuButtons/ContinueButton
@onready var shop_button: Button = $MenuButtons/ShopButton
@onready var settings_button: Button = $MenuButtons/SettingsButton
@onready var quit_button: Button = $MenuButtons/QuitButton
@onready var version_label: Label = $VersionLabel
@onready var high_score_label: Label = $HighScoreLabel

func _ready():
	_setup_buttons()
	_update_display()

func _setup_buttons():
	start_button.pressed.connect(_on_start_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	shop_button.pressed.connect(_on_shop_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	for button in [start_button, continue_button, shop_button, settings_button, quit_button]:
		button.mouse_entered.connect(_on_button_hover.bind(button))

func _update_display():
	high_score_label.text = "High Score: %d" % PlayerData.high_score
	continue_button.visible = PlayerData.high_score > 0

func _on_start_pressed():
	if AudioManager: AudioManager.play_ui_sound("select")
	SceneManager.switch_to("res://scenes/game.tscn")

func _on_continue_pressed():
	if AudioManager: AudioManager.play_ui_sound("select")
	GameManager.start_game()

func _on_shop_pressed():
	if AudioManager: AudioManager.play_ui_sound("select")

func _on_settings_pressed():
	if AudioManager: AudioManager.play_ui_sound("select")

func _on_quit_pressed():
	if AudioManager: AudioManager.play_ui_sound("select")
	get_tree().quit()

func _on_button_hover(button: Button):
	if AudioManager: AudioManager.play_ui_sound("hover")
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.05, 1.05), 0.1)

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		start_button.emit_signal("pressed")
