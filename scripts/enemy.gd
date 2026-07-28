extends CharacterBody3D
class_name EnemyShip

signal died(enemy_type: String, position: Vector3)

enum AIState { PATROL, APPROACH, ATTACK, EVADE, RETREAT, FORMATION, BOSS_PHASE }

@export var enemy_type: String = "fighter"
@export var detection_range: float = 80.0
@export var attack_range: float = 50.0
@export var evade_range: float = 20.0
@export var avoid_distance: float = 5.0

var enemy_data: Dictionary
var state: AIState = AIState.PATROL
var target: Node3D
var patrol_point: Vector3
var wander_timer: float = 0.0
var attack_cooldown: float = 0.0
var engage_player_if_damaged: bool = true
var boss_phase: int = 0
var max_boss_phases: int = 1
var initial_health: float

var current_health: float
var current_shield: float
var speed: float
var turn_rate: float
var fire_rate: float
var weapon_data: Dictionary
var cloaked: bool = false
var cloak_timer: float = 0.0
var cloak_cooldown: float = 10.0
var cloak_duration: float = 5.0

func _ready():
	add_to_group("Enemy")
	enemy_data = GameManager.get_enemy_data(enemy_type)
	_apply_stats()
	_setup_visuals()

func _apply_stats():
	current_health = enemy_data["health"] * GameManager.difficulty
	current_shield = enemy_data["shield"] * GameManager.difficulty
	initial_health = current_health
	speed = enemy_data["speed"] * (1 + (GameManager.current_wave - 1) * 0.05)
	turn_rate = enemy_data["turn_rate"]
	fire_rate = enemy_data["fire_rate"]
	weapon_data = GameManager.get_weapon_data(enemy_data["weapon"])
	cloaked = enemy_data.get("cloak", false)
	max_boss_phases = enemy_data.get("phases", 1)
	if GameManager.player:
		target = GameManager.player

func _setup_visuals():
	var scale_factor = enemy_data.get("size", 1.0)
	scale = Vector3(scale_factor, scale_factor, scale_factor)
	if cloaked:
		modulate = Color(1, 1, 1, 0.3)

func _physics_process(delta):
	if not GameManager.player:
		_patrol(delta)
		return
	attack_cooldown = max(0, attack_cooldown - delta)
	wander_timer = max(0, wander_timer - delta)
	if cloaked:
		_handle_cloak(delta)
	_update_state()
	match state:
		AIState.PATROL: _patrol(delta)
		AIState.APPROACH: _approach_target(delta)
		AIState.ATTACK: _attack_target(delta)
		AIState.EVADE: _evade(delta)
		AIState.RETREAT: _retreat(delta)
		AIState.FORMATION: _formation(delta)
		AIState.BOSS_PHASE: _boss_phase(delta)
	move_and_slide()

func _update_state():
	if not GameManager.player:
		state = AIState.PATROL
		return
	var distance = global_position.distance_to(GameManager.player.global_position)
	if enemy_data.get("boss", false):
		_handle_boss_state(distance)
		return
	match state:
		AIState.PATROL:
			if distance < detection_range:
				state = AIState.APPROACH
		AIState.APPROACH:
			if distance < attack_range:
				state = AIState.ATTACK
			elif distance > detection_range * 1.5:
				state = AIState.PATROL
		AIState.ATTACK:
			if distance < evade_range:
				state = AIState.EVADE
			elif distance > attack_range * 1.2:
				state = AIState.APPROACH
		AIState.EVADE:
			if distance > evade_range * 1.5:
				state = AIState.ATTACK
		AIState.RETREAT:
			if current_health < initial_health * 0.25:
				_retreat_target_position()
			else:
				state = AIState.APPROACH

func _handle_boss_state(distance: float):
	var health_percent = current_health / initial_health
	if health_percent < 0.66 and boss_phase < 1:
		boss_phase = 1; state = AIState.BOSS_PHASE; _transition_to_phase(1)
	elif health_percent < 0.33 and boss_phase < 2:
		boss_phase = 2; state = AIState.BOSS_PHASE; _transition_to_phase(2)
	if state != AIState.BOSS_PHASE:
		state = AIState.APPROACH if distance > attack_range * 2 else AIState.ATTACK

func _transition_to_phase(phase: int):
	speed *= 1 + phase * 0.1
	fire_rate *= 1 + phase * 0.2

func _patrol(delta):
	if wander_timer <= 0:
		patrol_point = Vector3(randf_range(-50, 50), randf_range(-20, 20), randf_range(-30, 30))
		wander_timer = randf_range(2, 5)
	var direction = (patrol_point - global_position).normalized()
	_rotate_towards(global_position + direction * 100, delta)
	velocity = direction * speed * 0.3

func _approach_target(delta):
	var target_pos = GameManager.player.global_position
	var direction = (target_pos - global_position).normalized()
	_rotate_towards(target_pos, delta)
	velocity = direction * speed

func _attack_target(delta):
	var target_pos = GameManager.player.global_position
	var direction = (target_pos - global_position).normalized()
	_rotate_towards(target_pos, delta)
	var strafe = sin(Time.get_ticks_usec() * 0.0005) * 0.3
	velocity = (direction + global_transform.basis.x * strafe).normalized() * speed
	if attack_cooldown <= 0 and global_position.distance_to(target_pos) <= attack_range:
		_fire_weapon()

func _evade(delta):
	var threat_dir = (global_position - GameManager.player.global_position).normalized()
	var evasive_dir = threat_dir.rotated(Vector3.UP, randf_range(-0.5, 0.5))
	_rotate_towards(global_position + evasive_dir * 100, delta)
	velocity = evasive_dir * speed * 1.5

func _retreat(delta):
	var retreat_dir = (global_position - GameManager.player.global_position).normalized()
	_rotate_towards(global_position + retreat_dir * 100, delta)
	velocity = retreat_dir * speed * 1.8
	if wander_timer <= 0:
		state = AIState.PATROL; wander_timer = 3.0

func _retreat_target_position():
	patrol_point = Vector3(randf_range(-60, 60), randf_range(-30, 30), 100)

func _formation(delta):
	if not target:
		state = AIState.PATROL; return
	var offset = Vector3(cos(Time.get_ticks_usec() * 0.0003) * 10, sin(Time.get_ticks_usec() * 0.0002) * 5, -15)
	var formation_pos = target.global_position + offset
	var direction = (formation_pos - global_position).normalized()
	_rotate_towards(formation_pos, delta)
	velocity = direction * speed

func _boss_phase(delta):
	if not GameManager.player:
		state = AIState.PATROL; return
	var target_pos = GameManager.player.global_position
	var direction = (target_pos - global_position).normalized()
	_rotate_towards(target_pos, delta)
	velocity = direction * speed * 0.5
	if attack_cooldown <= 0:
		_fire_weapon()
		attack_cooldown = fire_rate * (1.0 - boss_phase * 0.15)

func _fire_weapon():
	var projectile = preload("res://scenes/weapons/projectile.tscn").instantiate()
	get_parent().add_child(projectile)
	var muzzle = $Muzzle if has_node("Muzzle") else self
	projectile.global_transform = muzzle.global_transform
	projectile.init(weapon_data, self)
	GameManager.register_shot(false)
	if AudioManager:
		AudioManager.play_sfx_3d("res://assets/sounds/weapons/laser_fire.ogg", global_position, -3.0)

func _rotate_towards(target_pos: Vector3, delta: float):
	var target_dir = (target_pos - global_position).normalized()
	var quat = Quaternion(global_transform.basis.z, target_dir)
	quaternion = quaternion.slerp(quat, turn_rate * delta)

func _handle_cloak(delta):
	if cloaked:
		cloak_timer += delta
		if cloak_timer >= cloak_duration:
			cloaked = false; cloak_timer = 0.0
	else:
		cloak_timer += delta
		if cloak_timer >= cloak_cooldown:
			cloaked = true; cloak_timer = 0.0
	modulate = Color(1, 1, 1, 0.3) if cloaked else Color.WHITE

func take_damage(amount: float, damage_type: String = "kinetic"):
	if current_health <= 0: return
	var damage_to_health = amount
	if current_shield > 0:
		var shield_damage = amount
		if damage_type == "ion": shield_damage *= 2.0
		if shield_damage >= current_shield:
			damage_to_health = shield_damage - current_shield; current_shield = 0
		else:
			current_shield -= shield_damage; damage_to_health = 0
	if damage_to_health > 0:
		current_health -= damage_to_health
		_flash_damage()
		if current_health <= 0: die()
		elif engage_player_if_damaged: state = AIState.ATTACK

func _flash_damage():
	modulate = Color.RED
	await get_tree().create_timer(0.05).timeout
	modulate = Color.WHITE

func die():
	died.emit(enemy_type, global_position)
	GameManager.on_enemy_destroyed(enemy_type, global_position)
	var explosion_size = "large" if enemy_data.get("boss", false) else ("medium" if enemy_data.get("size", 1.0) > 1.5 else "small")
	var explosion = load("res://scenes/effects/explosion_%s.tscn" % explosion_size).instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	if AudioManager:
		AudioManager.play_sfx_3d("res://assets/sounds/explosions/explosion_%s.ogg" % explosion_size, global_position, 0.0)
	queue_free()
