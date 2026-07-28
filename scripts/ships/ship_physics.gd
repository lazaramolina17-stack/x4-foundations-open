extends CharacterBody3D
class_name ShipPhysics

var current_speed: float = 0.0
var target_speed: float = 0.0
var max_speed: float = 40.0
var acceleration: float = 15.0
var boost_speed: float = 80.0
var travel_speed: float = 400.0
var travel_charge: float = 0.0
var travel_active: bool = false
var is_boosting: bool = false

var yaw_rate: float = 3.0
var pitch_rate: float = 2.5
var roll_rate: float = 3.5

var input_yaw: float = 0.0
var input_pitch: float = 0.0
var input_roll: float = 0.0
var input_strafe_h: float = 0.0
var input_strafe_v: float = 0.0
var input_throttle: float = 0.0

var engine_on: bool = true
var mass: float = 100.0

var _velocity_buffer: Vector3 = Vector3.ZERO

func _physics_process(delta):
	if not engine_on:
		_velocity_buffer = _velocity_buffer.lerp(Vector3.ZERO, delta * 2.0)
		velocity = _velocity_buffer
		move_and_slide()
		return

	_handle_movement(delta)
	velocity = _velocity_buffer
	move_and_slide()

func _handle_movement(delta):
	var forward = -global_transform.basis.z
	var right = global_transform.basis.x
	var up = global_transform.basis.y

	if travel_active:
		target_speed = travel_speed
	elif is_boosting:
		target_speed = boost_speed
	else:
		target_speed = max_speed * clampf(input_throttle, 0.0, 1.0)

	var speed_diff = target_speed - current_speed
	current_speed += signf(speed_diff) * min(absf(speed_diff), acceleration * delta * 2.0)

	var strafe = right * input_strafe_h + up * input_strafe_v
	var move_dir = forward * current_speed + strafe * (max_speed * 0.5)
	_velocity_buffer = _velocity_buffer.lerp(move_dir, delta * 5.0)

	if input_yaw != 0 or input_pitch != 0 or input_roll != 0:
		var rot = Vector3(
			-input_pitch * pitch_rate * delta,
			-input_yaw * yaw_rate * delta,
			input_roll * roll_rate * delta
		)
		global_rotate(global_transform.basis.x, rot.x)
		global_rotate(global_transform.basis.y, rot.y)
		global_rotate(global_transform.basis.z, rot.z)
		var q = Quaternion(global_transform.basis)
		q = q.normalized()
		global_transform.basis = Basis(q)

func activate_boost():
	if not is_boosting and not travel_active:
		is_boosting = true

func deactivate_boost():
	is_boosting = false

func activate_travel_mode():
	if not travel_active and not is_boosting and current_speed > max_speed * 0.8:
		travel_active = true
		travel_charge = 0.0

func deactivate_travel_mode():
	travel_active = false
	travel_charge = 0.0

func set_throttle(t: float):
	input_throttle = clampf(t, -0.1, 1.0)

func set_strafe(h: float, v: float):
	input_strafe_h = clampf(h, -1.0, 1.0)
	input_strafe_v = clampf(v, -1.0, 1.0)

func set_rotation(yaw: float, pitch: float, roll: float):
	input_yaw = clampf(yaw, -1.0, 1.0)
	input_pitch = clampf(pitch, -1.0, 1.0)
	input_roll = clampf(roll, -1.0, 1.0)

func get_speed_percent() -> float:
	return current_speed / travel_speed if travel_speed > 0 else 0.0

func get_speed_string() -> String:
	return "%d m/s" % int(current_speed)

func apply_impulse(force: Vector3):
	_velocity_buffer += force / maxf(mass, 0.1)

func stop():
	current_speed = 0.0
	target_speed = 0.0
	_velocity_buffer = Vector3.ZERO
	velocity = Vector3.ZERO
	travel_active = false
	is_boosting = false
