extends Control
class_name GameOverScreen

@onready var score_label: Label = $VBoxContainer/ScoreLabel
@onready var wave_label: Label = $VBoxContainer/WaveLabel
@onready var enemies_label: Label = $VBoxContainer/EnemiesLabel
@onready var accuracy_label: Label = $VBoxContainer/AccuracyLabel
@onready var credits_label: Label = $VBoxContainer/CreditsLabel
@onready var high_score_label: Label = $VBoxContainer/HighScoreLabel
@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var menu_button: Button = $VBoxContainer/MenuButton
@onready var quit_button: Button = $VBoxContainer/QuitButton

func _ready():
	var stats = GameManager.get_stats()
	var accuracy = GameManager.get_accuracy() * 100
	score_label.text = "Score: %d" % stats["score"]
	wave_label.text = "Waves Survived: %d" % (stats["wave"] - 1)
	enemies_label.text = "Enemies Destroyed: %d" % stats["enemies_destroyed"]
	accuracy_label.text = "Accuracy: %.1f%%" % accuracy
	credits_label.text = "Credits Earned: %d" % stats["score"]
	high_score_label.text = "High Score: %d" % max(stats["score"], PlayerData.high_score)
	continue_button.pressed.connect(_on_continue_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	for button in [continue_button, menu_button, quit_button]:
		button.mouse_entered.connect(_on_button_hover.bind(button))

func _on_continue_pressed(): GameManager.start_game()
func _on_menu_pressed(): get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
func _on_quit_pressed(): get_tree().quit()

func _on_button_hover(button: Button):
	if AudioManager: AudioManager.play_ui_sound("hover")
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.05, 1.05), 0.1)
