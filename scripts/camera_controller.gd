extends Camera3D
class_name GameCamera

@export var target: Node3D
@export var distance: float = 12.0
@export var min_distance: float = 4.0
@export var max_distance: float = 30.0
@export var height: float = 6.0
@export var rotation_speed: float = 0.003
@export var zoom_speed: float = 2.0
@export var smoothing: float = 5.0

var yaw: float = 0.0
var pitch: float = -0.4
var min_pitch: float = -1.2
var max_pitch: float = -0.1

func _ready():
	set_process_input(true)

func _input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		yaw -= event.relative.x * rotation_speed
		pitch -= event.relative.y * rotation_speed
		pitch = clamp(pitch, min_pitch, max_pitch)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			distance = max(min_distance, distance - zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			distance = min(max_distance, distance + zoom_speed)

func _physics_process(delta):
	if not target:
		return

	var target_pos = target.global_position
	var desired_pos = target_pos + Vector3(
		sin(yaw) * cos(pitch) * distance,
		sin(pitch) * distance,
		cos(yaw) * cos(pitch) * distance
	)

	global_position = global_position.lerp(desired_pos, delta * smoothing)
	look_at(target_pos, Vector3.UP)
