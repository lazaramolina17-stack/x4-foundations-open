extends Control
class_name TouchControls

@onready var left_joystick: TouchScreenButton = $LeftJoystick
@onready var right_joystick: TouchScreenButton = $RightJoystick
@onready var fire_button: TouchScreenButton = $FireButton
@onready var boost_button: TouchScreenButton = $BoostButton
@onready var missile_button: TouchScreenButton = $MissileButton
@onready var pause_button: TouchScreenButton = $PauseButton

var left_joystick_active: bool = false
var right_joystick_active: bool = false
var left_joystick_pos: Vector2 = Vector2.ZERO
var right_joystick_pos: Vector2 = Vector2.ZERO

var left_joystick_center: Vector2 = Vector2.ZERO
var right_joystick_center: Vector2 = Vector2.ZERO
var joystick_radius: float = 50.0

func _ready() -> void:
	visible = DisplayServer.is_touchscreen_available()
	
	if not visible:
		return
	
	_setup_joysticks()

func _setup_joysticks() -> void:
	left_joystick_center = left_joystick.position + left_joystick.size / 2
	right_joystick_center = right_joystick.position + right_joystick.size / 2

func _input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event is InputEventScreenTouch:
		_handle_touch(event)
	elif event is InputEventScreenDrag:
		_handle_drag(event)

func _handle_touch(event: InputEventScreenTouch) -> void:
	var pos = event.position
	
	if event.pressed:
		if pos.distance_to(left_joystick_center) < 100:
			left_joystick_active = true
			left_joystick_pos = pos - left_joystick_center
		elif pos.distance_to(right_joystick_center) < 100:
			right_joystick_active = true
			right_joystick_pos = pos - right_joystick_center
	else:
		left_joystick_active = false
		right_joystick_active = false
		left_joystick_pos = Vector2.ZERO
		right_joystick_pos = Vector2.ZERO

func _handle_drag(event: InputEventScreenDrag) -> void:
	var pos = event.position
	
	if left_joystick_active:
		left_joystick_pos = (pos - left_joystick_center).clamp(Vector2(-joystick_radius, -joystick_radius), Vector2(joystick_radius, joystick_radius))
	elif right_joystick_active:
		right_joystick_pos = (pos - right_joystick_center).clamp(Vector2(-joystick_radius, -joystick_radius), Vector2(joystick_radius, joystick_radius))

func get_movement_input() -> Vector2:
	if left_joystick_active:
		return left_joystick_pos / joystick_radius
	return Vector2.ZERO

func get_look_input() -> Vector2:
	if right_joystick_active:
		return right_joystick_pos / joystick_radius
	return Vector2.ZERO

func is_firing() -> bool:
	return fire_button.is_pressed()

func is_boosting() -> bool:
	return boost_button.is_pressed()

func is_missile_pressed() -> bool:
	return missile_button.is_pressed()

func is_pause_pressed() -> bool:
	return pause_button.is_pressed()