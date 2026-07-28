extends Control
class_name SettingsMenu

@onready var master_slider: HSlider = $GridContainer/MasterVolume/HSlider
@onready var sfx_slider: HSlider = $GridContainer/SFXVolume/HSlider
@onready var music_slider: HSlider = $GridContainer/MusicVolume/HSlider
@onready var sensitivity_slider: HSlider = $GridContainer/Sensitivity/HSlider
@onready var invert_y_checkbox: CheckButton = $GridContainer/InvertY/CheckButton
@onready var vibration_checkbox: CheckButton = $GridContainer/Vibration/CheckButton
@onready var quality_dropdown: OptionButton = $GridContainer/GraphicsQuality/OptionButton
@onready var fps_checkbox: CheckButton = $GridContainer/ShowFPS/CheckButton
@onready var close_button: Button = $CloseButton

func _ready() -> void:
	_load_settings()
	_setup_signals()

func _setup_signals() -> void:
	master_slider.value_changed.connect(_on_master_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)
	music_slider.value_changed.connect(_on_music_changed)
	sensitivity_slider.value_changed.connect(_on_sensitivity_changed)
	invert_y_checkbox.toggled.connect(_on_invert_y_toggled)
	vibration_checkbox.toggled.connect(_on_vibration_toggled)
	quality_dropdown.item_selected.connect(_on_quality_selected)
	fps_checkbox.toggled.connect(_on_fps_toggled)
	close_button.pressed.connect(close)

func _load_settings() -> void:
	var s = PlayerData.settings
	master_slider.value = s["master_volume"]
	sfx_slider.value = s["sfx_volume"]
	music_slider.value = s["music_volume"]
	sensitivity_slider.value = s["sensitivity"]
	invert_y_checkbox.button_pressed = s["invert_y"]
	vibration_checkbox.button_pressed = s["vibration"]
	fps_checkbox.button_pressed = s["show_fps"]
	
	var quality_names = ["low", "medium", "high", "ultra"]
	var quality_index = quality_names.find(s["graphics_quality"])
	if quality_index >= 0:
		quality_dropdown.selected = quality_index

func _on_master_changed(value: float) -> void:
	PlayerData.settings["master_volume"] = value
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

func _on_sfx_changed(value: float) -> void:
	PlayerData.settings["sfx_volume"] = value
	AudioServer.set_bus_volume_db(1, linear_to_db(value))

func _on_music_changed(value: float) -> void:
	PlayerData.settings["music_volume"] = value
	AudioServer.set_bus_volume_db(2, linear_to_db(value))

func _on_sensitivity_changed(value: float) -> void:
	PlayerData.settings["sensitivity"] = value

func _on_invert_y_toggled(toggled: bool) -> void:
	PlayerData.settings["invert_y"] = toggled

func _on_vibration_toggled(toggled: bool) -> void:
	PlayerData.settings["vibration"] = toggled

func _on_quality_selected(index: int) -> void:
	var qualities = ["low", "medium", "high", "ultra"]
	PlayerData.settings["graphics_quality"] = qualities[index]
	_apply_graphics_quality(qualities[index])

func _on_fps_toggled(toggled: bool) -> void:
	PlayerData.settings["show_fps"] = toggled

func _apply_graphics_quality(quality: String) -> void:
	match quality:
		"low":
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			RenderingServer.set_max_fps(30)
		"medium":
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			RenderingServer.set_max_fps(60)
		"high":
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			RenderingServer.set_max_fps(0)
		"ultra":
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			RenderingServer.set_max_fps(0)

func open() -> void:
	_load_settings()
	visible = true

func close() -> void:
	PlayerData.save()
	visible = false
	
	if AudioManager:
		AudioManager.play_ui_sound("click")

func linear_to_db(linear: float) -> float:
	if linear <= 0.0:
		return -80.0
	return 20.0 * log10(linear)

func _on_close_button_pressed() -> void:
	close()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		close()