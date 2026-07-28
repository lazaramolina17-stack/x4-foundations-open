extends Control
class_name HUD

@onready var hull_bar: TextureProgressBar = $HullBar
@onready var shield_bar: TextureProgressBar = $ShieldBar
@onready var energy_bar: TextureProgressBar = $EnergyBar
@onready var score_label: Label = $ScoreLabel
@onready var wave_label: Label = $WaveLabel
@onready var credits_label: Label = $CreditsLabel
@onready var lives_label: Label = $LivesLabel
@onready var damage_overlay: ColorRect = $DamageOverlay

var player: PlayerShip
var damage_overlay_timer: float = 0.0
var damage_overlay_alpha: float = 0.0

func _ready():
	GameManager.player_died.connect(_on_player_died)
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.wave_changed.connect(_on_wave_changed)
	GameManager.credits_changed.connect(_on_credits_changed)

func set_player(new_player: PlayerShip):
	player = new_player
	if player:
		player.hull_changed.connect(_on_hull_changed)
		player.shield_changed.connect(_on_shield_changed)
		player.energy_changed.connect(_on_energy_changed)
		player.weapon_fired.connect(_on_weapon_fired)
		player.died.connect(_on_player_died)
		_on_hull_changed(player.current_hull, player.max_hull)
		_on_shield_changed(player.current_shield, player.max_shield)
		_on_energy_changed(player.current_energy, player.max_energy)

func _process(delta):
	if damage_overlay_timer > 0:
		damage_overlay_timer -= delta
		damage_overlay.modulate.a = damage_overlay_alpha * (damage_overlay_timer / 1.0)
		damage_overlay_alpha = lerp(damage_overlay_alpha, 0.0, delta * 3.0)

func _on_hull_changed(current: float, max_val: float):
	hull_bar.value = current / max_val if max_val > 0 else 0
	if max_val > 0:
		hull_bar.get_node("Label").text = "Hull: %d/%d" % [int(current), int(max_val)]
	if current / max_val < 0.3 and max_val > 0:
		damage_overlay_alpha = 0.3; damage_overlay_timer = 1.0

func _on_shield_changed(current: float, max_val: float):
	shield_bar.value = current / max_val if max_val > 0 else 0
	if max_val > 0:
		shield_bar.get_node("Label").text = "Shield: %d/%d" % [int(current), int(max_val)]

func _on_energy_changed(current: float, max_val: float):
	energy_bar.value = current / max_val if max_val > 0 else 0
	if max_val > 0:
		energy_bar.get_node("Label").text = "Energy: %d/%d" % [int(current), int(max_val)]

func _on_weapon_fired(weapon_id: String):
	if AudioManager: AudioManager.play_sfx_2d("res://assets/sounds/ui/click.ogg")

func _on_score_changed(new_score: int):
	score_label.text = "Score: %d" % new_score

func _on_wave_changed(wave: int):
	wave_label.text = "Wave %d" % wave
	_show_wave_notification(wave)

func _on_credits_changed(amount: int):
	credits_label.text = "Credits: %d" % GameManager.credits

func _on_player_died():
	lives_label.text = "Lives: %d" % GameManager.lives
	_show_death_notification()

func _show_wave_notification(wave: int):
	var notify = Label.new()
	notify.text = "Wave %d" % wave
	notify.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	notify.set_anchors_preset(Control.PRESET_CENTER)
	notify.add_theme_font_size_override("font_size", 48)
	notify.add_theme_color_override("font_color", Color(1, 0.8, 0.2))
	add_child(notify)
	var tween = create_tween()
	tween.tween_property(notify, "position", Vector2(0, -100), 1.5)
	tween.parallel().tween_property(notify, "modulate", Color(1, 0.8, 0.2, 0), 1.5)
	tween.tween_callback(notify.queue_free)

func _show_death_notification():
	var notify = Label.new()
	notify.text = "Ship Destroyed!"
	notify.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	notify.set_anchors_preset(Control.PRESET_CENTER)
	notify.add_theme_font_size_override("font_size", 36)
	notify.add_theme_color_override("font_color", Color(1, 0, 0))
	add_child(notify)
	var tween = create_tween()
	tween.tween_property(notify, "position", Vector2(0, -150), 2.0)
	tween.parallel().tween_property(notify, "modulate", Color(1, 0, 0, 0), 2.0)
	tween.tween_callback(notify.queue_free)

func _on_pause_button_pressed(): GameManager.pause_game()
