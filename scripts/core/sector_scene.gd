extends Node3D
class_name SectorScene

var sector_id: String = ""

var player_ship: PlayerShip = null
var gates: Node3D
var stations_node: Node3D
var ships_node: Node3D
var asteroids_node: Node3D
var stars_node: Node3D

var universe
var economy
var faction_mgr

var star_count: int = 2000
var asteroid_count: int = 200

func _ready():
	universe = get_tree().root.find_child("UniverseManager", true, false)
	economy = get_tree().root.find_child("EconomyManager", true, false)
	faction_mgr = get_tree().root.find_child("FactionManager", true, false)

	gates = $Gates
	stations_node = $Stations
	ships_node = $Ships
	asteroids_node = $Asteroids
	stars_node = $Stars

	_generate_stars()
	_generate_gates()
	_generate_stations()
	_generate_asteroids()
	_spawn_npc_ships()
	_spawn_player()

func init(sector_id_name: String):
	sector_id = sector_id_name

func _generate_stars():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var star_material = StandardMaterial3D.new()
	star_material.emission_enabled = true
	star_material.emission_energy = 2.0

	for i in range(star_count):
		var m = MeshInstance3D.new()
		m.mesh = SphereMesh.new()
		m.mesh.radius = 0.3 + rng.randf() * 0.7
		m.mesh.height = m.mesh.radius * 2
		m.mesh.material = star_material
		var x = rng.randf_range(-UniverseManager.SECTOR_SIZE, UniverseManager.SECTOR_SIZE)
		var y = rng.randf_range(-UniverseManager.SECTOR_SIZE, UniverseManager.SECTOR_SIZE)
		var z = rng.randf_range(-UniverseManager.SECTOR_SIZE, UniverseManager.SECTOR_SIZE)
		m.position = Vector3(x, y, z)
		var c = Color(rng.randf_range(0.5, 1.0), rng.randf_range(0.5, 1.0), rng.randf_range(0.5, 1.0))
		if rng.randf() < 0.1:
			c = Color(1.0, 0.8, 0.6) if rng.randf() < 0.5 else Color(0.7, 0.8, 1.0)
		m.set_instance_shader_parameter(&"color", c)
		stars_node.add_child(m)

func _generate_gates():
	if not universe: return
	var gate_positions = universe.get_gate_positions_in_sector(sector_id)
	for gp in gate_positions:
		var gate_mesh = MeshInstance3D.new()
		gate_mesh.mesh = TorusMesh.new()
		gate_mesh.mesh.inner_radius = 100.0
		gate_mesh.mesh.outer_radius = 120.0
		gate_mesh.mesh.rings = 32
		gate_mesh.mesh.ring_segments = 64
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.0, 0.5, 1.0)
		mat.emission_enabled = true
		mat.emission = Color(0.0, 0.3, 0.8)
		mat.emission_energy = 3.0
		mat.metallic = 0.8
		mat.roughness = 0.2
		gate_mesh.mesh.material = mat
		gate_mesh.position = gp.position
		gate_mesh.add_to_group("gates")
		gates.add_child(gate_mesh)

		var target_label = MeshInstance3D.new()
		target_label.mesh = BoxMesh.new()
		target_label.mesh.size = Vector3(50, 10, 1)
		var label_mat = StandardMaterial3D.new()
		label_mat.albedo_color = Color(0.0, 0.8, 1.0)
		label_mat.emission_enabled = true
		label_mat.emission = Color(0.0, 0.4, 0.8)
		target_label.mesh.material = label_mat
		target_label.position = gp.position + Vector3(0, 150, 0)
		gates.add_child(target_label)

func _generate_stations():
	if not economy: return
	var station_list = economy.get_stations_in_sector(sector_id)
	for sid in station_list:
		var station_data = station_list[sid]
		var station_node = Station.new()
		station_node.name = sid
		station_node.position = station_data.get("position", universe.find_safe_position_in_sector(sector_id))
		station_node.init(sid, station_data.station_type, station_data.faction, sector_id)
		var faction_color = faction_mgr.get_faction_color(station_data.faction) if faction_mgr else Color.WHITE

		var main_mesh = MeshInstance3D.new()
		main_mesh.mesh = BoxMesh.new()
		main_mesh.mesh.size = Vector3(100, 80, 100)
		var mat = StandardMaterial3D.new()
		mat.albedo_color = faction_color
		mat.emission_enabled = true
		mat.emission = faction_color * 0.3
		mat.metallic = 0.6
		mat.roughness = 0.4
		main_mesh.mesh.material = mat
		station_node.add_child(main_mesh)

		var station_label = MeshInstance3D.new()
		station_label.mesh = BoxMesh.new()
		station_label.mesh.size = Vector3(80, 8, 1)
		var label_mat = StandardMaterial3D.new()
		label_mat.albedo_color = Color.WHITE
		label_mat.emission_enabled = true
		label_mat.emission = Color.WHITE
		station_label.mesh.material = label_mat
		station_label.position = Vector3(0, 80, 0)
		station_node.add_child(station_label)

		station_node.add_to_group("stations")
		stations_node.add_child(station_node)

func _generate_asteroids():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var density = universe.get_sector(sector_id).get("asteroid_density", 0.5) if universe else 0.5
	var count = int(asteroid_count * density)
	for i in range(count):
		var m = MeshInstance3D.new()
		m.mesh = SphereMesh.new()
		var size = rng.randf_range(5.0, 40.0)
		m.mesh.radius = size
		m.mesh.height = size * 2
		var mat = StandardMaterial3D.new()
		var gray = rng.randf_range(0.2, 0.5)
		mat.albedo_color = Color(gray, gray, gray * 0.9)
		mat.roughness = 0.8
		mat.metallic = 0.1
		m.mesh.material = mat
		m.position = Vector3(
			rng.randf_range(-UniverseManager.SECTOR_SIZE * 0.8, UniverseManager.SECTOR_SIZE * 0.8),
			rng.randf_range(-UniverseManager.SECTOR_SIZE * 0.8, UniverseManager.SECTOR_SIZE * 0.8),
			rng.randf_range(-UniverseManager.SECTOR_SIZE * 0.8, UniverseManager.SECTOR_SIZE * 0.8)
		)
		m.scale = Vector3(1, rng.randf_range(0.5, 2.0), rng.randf_range(0.5, 2.0))
		asteroids_node.add_child(m)

func _spawn_npc_ships():
	if not faction_mgr or not universe: return
	var sector_info = universe.get_sector(sector_id)
	var owner = sector_info.get("owner", "neutral")
	var factions_present = [owner]
	for other in FactionData.get_all():
		if other != owner and randi() % 3 == 0:
			factions_present.append(other)

	for fid in factions_present:
		var f = faction_mgr.get_faction(fid)
		if f.is_empty(): continue
		var ships_per_faction = randi_range(1, 3)
		for i in range(ships_per_faction):
			var ship_types = f.get("ship_preferences", ["discoverer"])
			var ship_type = ship_types[randi() % ship_types.size()]
			var ship_node = _create_ship_mesh(ship_type, fid)
			if ship_node:
				var pos = universe.find_safe_position_in_sector(sector_id)
				ship_node.position = pos
				var ai = ShipAI.new()
				ship_node.add_child(ai)
				ai.ship = ship_node
				ai.home_sector = sector_id
				ai.personality = ShipAI.Personality.DEFENSIVE if fid == owner else ShipAI.Personality.PASSIVE
				ships_node.add_child(ship_node)

func _create_ship_mesh(ship_type: String, fid: String) -> ShipBase:
	var ship = ShipBase.new()
	ship.ship_id = ship_type
	ship.faction_id = fid
	ship.ship_name = "%s %s" % [FactionData.get(fid).get("name", fid), ShipData.get(ship_type).get("name", ship_type)]

	var m = MeshInstance3D.new()
	m.mesh = BoxMesh.new()
	var data = ShipData.get(ship_type)
	var size_scale = 1.0
	match data.get("class", ShipData.ShipClass.S):
		ShipData.ShipClass.S: size_scale = 1.0
		ShipData.ShipClass.M: size_scale = 3.0
		ShipData.ShipClass.L: size_scale = 8.0
		ShipData.ShipClass.XL: size_scale = 15.0
	m.mesh.size = Vector3(5 * size_scale, 2 * size_scale, 15 * size_scale)
	var mat = StandardMaterial3D.new()
	mat.albedo_color = faction_mgr.get_faction_color(fid) if faction_mgr else Color(0.5, 0.5, 0.5)
	mat.metallic = 0.7
	mat.roughness = 0.3
	mat.emission_enabled = true
	mat.emission = mat.albedo_color * 0.1
	m.mesh.material = mat
	ship.add_child(m)

	ship.add_to_group("ships")
	return ship

func _spawn_player():
	var player_scene = preload("res://scenes/player.tscn")
	if player_scene:
		player_ship = player_scene.instantiate()
		player_ship.ship_id = "discoverer"
		player_ship.faction_id = "player"
		player_ship.ship_name = "Player Discovery"
		var spawn_pos = $PlayerSpawn
		player_ship.global_position = spawn_pos.global_position
		ships_node.add_child(player_ship)
		GameManager.player_ship = player_ship
		universe.enter_sector(sector_id)
	else:
		print("ERROR: Player scene not found!")
