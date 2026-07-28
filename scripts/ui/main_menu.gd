extends Control

func _ready():
	$VBoxContainer/NewGame.pressed.connect(_on_new_game)
	$VBoxContainer/LoadGame.pressed.connect(_on_load_game)
	$VBoxContainer/Settings.pressed.connect(_on_settings)
	$VBoxContainer/Quit.pressed.connect(_on_quit)

func _on_new_game():
	GameManager.start_new_game()
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_load_game():
	if GameManager.load_game(0):
		get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_settings():
	pass

func _on_quit():
	get_tree().quit()
