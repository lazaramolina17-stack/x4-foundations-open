extends Node

signal time_tick(day: int, hour: int, minute: int)
signal day_passed(day: int)

const SECONDS_PER_MINUTE: float = 2.0
const MINUTES_PER_HOUR: int = 60
const HOURS_PER_DAY: int = 24

var game_time_seconds: float = 0.0
var time_scale: float = 1.0
var is_paused: bool = false

var current_day: int = 1
var current_hour: int = 6
var current_minute: int = 0

func _process(delta):
	if is_paused: return
	game_time_seconds += delta * time_scale
	_update_time()

func _update_time():
	var total_minutes = int(game_time_seconds / SECONDS_PER_MINUTE)
	var new_day = (total_minutes / (MINUTES_PER_HOUR * HOURS_PER_DAY)) + 1
	var remaining = total_minutes % (MINUTES_PER_HOUR * HOURS_PER_DAY)
	var new_hour = remaining / MINUTES_PER_HOUR
	var new_minute = remaining % MINUTES_PER_HOUR

	if new_day != current_day:
		current_day = new_day
		day_passed.emit(current_day)

	if new_hour != current_hour or new_minute != current_minute:
		current_hour = new_hour
		current_minute = new_minute
		time_tick.emit(current_day, current_hour, current_minute)

func set_time_scale(scale: float):
	time_scale = clampf(scale, 0.1, 100.0)

func toggle_pause():
	is_paused = not is_paused

func get_time_string() -> String:
	return "Day %d, %02d:%02d" % [current_day, current_hour, current_minute]

func get_total_minutes() -> int:
	return int(game_time_seconds / SECONDS_PER_MINUTE)
