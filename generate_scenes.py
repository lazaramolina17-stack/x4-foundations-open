#!/usr/bin/env python3
"""Generate all .tscn scene files for Space Shooter 3D project."""

import os
import uuid

SCENES_DIR = os.path.dirname(os.path.abspath(__file__)) + "/scenes"
ASSETS_DIR = os.path.dirname(os.path.abspath(__file__)) + "/assets"

def uid():
    return "uid://" + uuid.uuid4().hex[:16]

def ensure_dirs():
    for d in ["scenes/enemies", "scenes/weapons", "scenes/effects", "scenes/pickups", "assets/environments"]:
        os.makedirs(os.path.join(os.path.dirname(os.path.abspath(__file__)), d), exist_ok=True)

def write_tscn(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        f.write(content)
    print(f"  Wrote {path}")

# ==================== MAIN MENU ====================
def gen_main_menu():
    u = uid()
    content = f'''[gd_scene load_steps=4 format=3 uid="{u}"]

[ext_resource type="Script" path="res://scripts/main_menu.gd" id="1"]

[sub_resource type="Animation" id="2"]
resource_name = "title_pulse"
length = 2.0
loop_mode = 2
tracks/0/type = "value"
tracks/0/path = NodePath("TitleLabel:modulate")
tracks/0/interp = 1
tracks/0/loop_wrap = true
tracks/0/keys = {{
"times": PackedFloat32Array(0, 1.0, 2.0),
"transitions": PackedFloat32Array(1, 1, 1),
"values": [Color(1,1,1,1), Color(0.8,0.8,1,1), Color(1,1,1,1)]
}}

[sub_resource type="AnimationPlayer" id="3"]
resource_name = "AnimationPlayer"
anims/pulse = SubResource("2")

[node name="MainMenu" type="Control"]
anchors_preset = 0
anchor_right = 1.0
anchor_bottom = 1.0
script = ExtResource("1")

[node name="Background" type="ColorRect" parent="."]
anchors_preset = 0
anchor_right = 1.0
anchor_bottom = 1.0
color = Color(0.02, 0.02, 0.08, 1)

[node name="TitleLabel" type="Label" parent="."]
anchors_preset = 0
offset_left = 200.0
offset_top = 60.0
offset_right = 1080.0
offset_bottom = 160.0
text = "SPACE SHOOTER 3D"
horizontal_alignment = 1
vertical_alignment = 1
theme_overrides/font_sizes/font_size = 64
theme_overrides/colors/font_color = Color(0.3, 0.6, 1, 1)

[node name="MenuButtons" type="VBoxContainer" parent="."]
anchors_preset = 0
offset_left = 440.0
offset_top = 220.0
offset_right = 840.0
offset_bottom = 520.0
theme_overrides/constants/separation = 12

[node name="StartButton" type="Button" parent="MenuButtons"]
layout_mode = 2
text = "START GAME"
theme_overrides/font_sizes/font_size = 28
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="ContinueButton" type="Button" parent="MenuButtons"]
layout_mode = 2
text = "CONTINUE"
theme_overrides/font_sizes/font_size = 28
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="ShopButton" type="Button" parent="MenuButtons"]
layout_mode = 2
text = "SHOP"
theme_overrides/font_sizes/font_size = 28
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="SettingsButton" type="Button" parent="MenuButtons"]
layout_mode = 2
text = "SETTINGS"
theme_overrides/font_sizes/font_size = 28
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="QuitButton" type="Button" parent="MenuButtons"]
layout_mode = 2
text = "QUIT"
theme_overrides/font_sizes/font_size = 28
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="VersionLabel" type="Label" parent="."]
anchors_preset = 0
offset_left = 20.0
offset_top = 690.0
offset_right = 200.0
offset_bottom = 720.0
text = "v1.0"
theme_overrides/font_sizes/font_size = 12
theme_overrides/colors/font_color = Color(0.5, 0.5, 0.5, 1)

[node name="HighScoreLabel" type="Label" parent="."]
anchors_preset = 0
offset_left = 1040.0
offset_top = 690.0
offset_right = 1260.0
offset_bottom = 720.0
text = "High Score: 0"
horizontal_alignment = 2
theme_overrides/font_sizes/font_size = 14
theme_overrides/colors/font_color = Color(0.7, 0.7, 0.3, 1)

[node name="AnimationPlayer" type="AnimationPlayer" parent="."]
root_node = NodePath("../TitleLabel")
anims = SubResource("3")
'''
    write_tscn(f"{SCENES_DIR}/main_menu.tscn", content)

# ==================== GAME WORLD ====================
def gen_game():
    u = uid()
    content = f'''[gd_scene load_steps=4 format=3 uid="{u}"]

[ext_resource type="Script" path="res://scripts/game_world.gd" id="1"]
[ext_resource type="PackedScene" path="res://scenes/enemies/boss_destroyer.tscn" id="2"]

[sub_resource type="Environment" id="3"]
background_mode = 2
background_sky_custom_fov = 120.0
ambient_light_color = Color(0.01, 0.01, 0.05, 1)
ambient_light_energy = 0.3
glow_enabled = true
glow_levels/1 = 0.0
glow_levels/2 = 0.0
glow_levels/3 = 1.0
glow_levels/4 = 0.0
glow_levels/5 = 0.0
glow_levels/6 = 0.0
glow_levels/7 = 0.0
glow_intensity = 0.8
glow_strength = 1.0
glow_bloom = 0.2
fog_enabled = true
fog_density = 0.001

[node name="GameWorld" type="Node3D"]
script = ExtResource("1")

[node name="WorldEnvironment" type="WorldEnvironment" parent="."]
environment = SubResource("3")

[node name="PlayerSpawn" type="Marker3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 20)

[node name="Background" type="Node3D" parent="."]

[node name="BackgroundMesh" type="MeshInstance3D" parent="Background"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, -200)
mesh = SubResource("sky_box")

[sub_resource type="BoxMesh" id="4"]
size = Vector3(400, 200, 2)

[sub_resource type="StandardMaterial3D" id="5"]
albedo_color = Color(0.0, 0.0, 0.05, 1)
emission = Color(0.0, 0.0, 0.1, 1)
emission_enabled = true

[node name="SkyMesh" type="MeshInstance3D" parent="Background"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, -200)
mesh = SubResource("4")
material_override = SubResource("5")

[node name="AudioListener" type="AudioListener3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)

[node name="UI" type="CanvasLayer" parent="."]

[node name="HUD" type="Control" parent="UI"]
script = ExtResource("hud_ext")
visible = true
anchor_right = 1.0
anchor_bottom = 1.0
'''
    # We'll reference the HUD via path loading; for now use a dummy reference
    # Actually let's make it a proper ext_resource reference
    content = content.replace("ExtResource(\"hud_ext\")", 'load("res://scenes/hud.tscn").instantiate()')
    # Better approach: instantiate HUD scene
    write_tscn(f"{SCENES_DIR}/game.tscn", content)

# Let's just write proper scenes directly
def write_all_scenes():
    ensure_dirs()
    gen_main_menu()
    gen_game_direct_v2()
    gen_player()
    gen_enemies()
    gen_weapons()
    gen_explosions()
    gen_pickups()
    gen_hud()
    gen_shop()
    gen_settings()
    gen_game_over()
    gen_touch_controls()
    gen_default_env()

def gen_game_direct():
    u = uid()
    content = f'''[gd_scene load_steps=3 format=3 uid="{u}"]

[ext_resource type="Script" path="res://scripts/game_world.gd" id="1"]

[sub_resource type="Environment" id="2"]
background_mode = 0
ambient_light_color = Color(0.01, 0.01, 0.05, 1)
ambient_light_energy = 0.3
glow_enabled = true
glow_levels/1 = 0.0
glow_levels/2 = 0.0
glow_levels/3 = 1.0
glow_levels/4 = 0.0
glow_levels/5 = 0.0
glow_levels/6 = 0.0
glow_levels/7 = 0.0
glow_intensity = 0.5
glow_bloom = 0.1

[node name="GameWorld" type="Node3D"]
script = ExtResource("1")

[node name="WorldEnvironment" type="WorldEnvironment" parent="."]
environment = SubResource("2")

[node name="PlayerSpawn" type="Marker3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 20)

[node name="Background" type="Node3D" parent="."]

[node name="AudioListener" type="AudioListener3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)

[node name="Camera3D" type="Camera3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 15, 5, 15)
current = true

[node name="UI" type="CanvasLayer" parent="."]

[node name="HUD" type="Control" parent="UI"]
anchor_right = 1.0
anchor_bottom = 1.0
script = ExtResource("hud")
'''
    # We need to reference the HUD scene - let's use instance loading
    content = content.replace('script = ExtResource("hud")', 'script = load("res://scenes/hud.tscn")')
    # Actually, we should instance the HUD scene properly. Let me rewrite this.
    write_tscn(f"{SCENES_DIR}/game.tscn", content)

# Let's redo the game scene properly - instance the HUD as a child
def gen_game_direct_v2():
    u = uid()
    content = f'''[gd_scene load_steps=4 format=3 uid="{u}"]

[ext_resource type="Script" path="res://scripts/game_world.gd" id="1"]
[ext_resource type="PackedScene" path="res://scenes/hud.tscn" id="2"]

[sub_resource type="Environment" id="3"]
background_mode = 0
ambient_light_color = Color(0.01, 0.01, 0.05, 1)
ambient_light_energy = 0.3
glow_enabled = true
glow_levels/1 = 0.0
glow_levels/2 = 0.0
glow_levels/3 = 1.0
glow_levels/4 = 0.0
glow_levels/5 = 0.0
glow_levels/6 = 0.0
glow_levels/7 = 0.0
glow_intensity = 0.5
glow_bloom = 0.1

[node name="GameWorld" type="Node3D"]
script = ExtResource("1")

[node name="WorldEnvironment" type="WorldEnvironment" parent="."]
environment = SubResource("3")

[node name="PlayerSpawn" type="Marker3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 20)

[node name="Background" type="Node3D" parent="."]

[node name="AudioListener" type="AudioListener3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)

[node name="Camera3D" type="Camera3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 15, 5, 15)
current = true

[node name="UI" type="CanvasLayer" parent="."]

[node name="HUD" type="Control" parent="UI" instance=ExtResource("2")]
anchor_right = 1.0
anchor_bottom = 1.0
'''
    write_tscn(f"{SCENES_DIR}/game.tscn", content)

def gen_player():
    u = uid()
    content = f'''[gd_scene load_steps=7 format=3 uid="{u}"]

[ext_resource type="Script" path="res://scripts/player_ship.gd" id="1"]

[sub_resource type="BoxMesh" id="2"]
size = Vector3(0.2, 0.6, 1.2)

[sub_resource type="StandardMaterial3D" id="3"]
albedo_color = Color(0.2, 0.4, 0.8, 1)
metallic = 0.7
roughness = 0.3

[sub_resource type="BoxMesh" id="4"]
size = Vector3(1.2, 0.1, 0.8)

[sub_resource type="StandardMaterial3D" id="5"]
albedo_color = Color(0.3, 0.5, 0.9, 1)
metallic = 0.8
roughness = 0.2
emission = Color(0.1, 0.2, 0.5, 1)
emission_enabled = true

[sub_resource type="CylinderMesh" id="6"]
top_radius = 0.03
bottom_radius = 0.03
height = 0.4

[node name="Player" type="CharacterBody3D"]
script = ExtResource("1")
collision_layer = 2
collision_mask = 10

[node name="CollisionShape3D" type="CollisionShape3D" parent="."]
shape = SubResource("6")

[node name="MeshRoot" type="Node3D" parent="."]
groups = ["PlayerMesh"]

[node name="Fuselage" type="MeshInstance3D" parent="MeshRoot"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)
mesh = SubResource("2")
material_override = SubResource("3")

[node name="Wings" type="MeshInstance3D" parent="MeshRoot"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)
mesh = SubResource("4")
material_override = SubResource("5")

[node name="Nose" type="MeshInstance3D" parent="MeshRoot"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, -0.9)
mesh = SubResource("4")
material_override = SubResource("3")
scale = Vector3(0.5, 0.5, 0.5)

[node name="EngineTrail" type="GPUParticles3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0.8)
emitting = false
amount = 16
lifetime = 0.5
one_shot = false
preprocess = 0.5
explosiveness = 0.0
randomness = 0.2
fixed_fps = 0
fractional_delta = true
interpolate = false

[sub_resource type="ParticleProcessMaterial" id="7"]
emission_shape = 0
direction = Vector3(0, 0, 1)
spread = 30.0
gravity = Vector3(0, 0, 0)
initial_velocity_min = 2.0
initial_velocity_max = 6.0
scale_min = 0.05
scale_max = 0.15
color = Color(0.3, 0.6, 1, 0.6)

[node name="EngineTrail" type="GPUParticles3D" parent="."]
process_material = SubResource("7")

[node name="BoostTrail" type="GPUParticles3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0.8)
emitting = false
amount = 32
lifetime = 0.8
one_shot = false
preprocess = 0.0
explosiveness = 0.0
randomness = 0.3

[sub_resource type="ParticleProcessMaterial" id="8"]
emission_shape = 0
direction = Vector3(0, 0, 1)
spread = 15.0
gravity = Vector3(0, 0, 0)
initial_velocity_min = 5.0
initial_velocity_max = 15.0
scale_min = 0.1
scale_max = 0.3
color = Color(1, 0.8, 0.4, 0.8)

[node name="BoostTrail" type="GPUParticles3D" parent="."]
process_material = SubResource("8")

[node name="Muzzle" type="Marker3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, -1.2)

[node name="MissileMuzzle" type="Marker3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, -1.2)
'''
    write_tscn(f"{SCENES_DIR}/player.tscn", content)

def gen_enemies():
    enemies = {
        "fighter": {"health": 50, "shield": 0, "speed": 40, "size": 1.0, "color": "0.8,0.2,0.2", "mesh_scale": "1,1,1"},
        "interceptor": {"health": 30, "shield": 0, "speed": 70, "size": 0.8, "color": "0.2,0.8,0.2", "mesh_scale": "0.8,0.8,0.8"},
        "bomber": {"health": 200, "shield": 50, "speed": 20, "size": 2.0, "color": "0.6,0.3,0.8", "mesh_scale": "2,1.5,2"},
        "gunship": {"health": 500, "shield": 150, "speed": 15, "size": 3.0, "color": "0.8,0.6,0.2", "mesh_scale": "3,2,3"},
        "stealth": {"health": 40, "shield": 20, "speed": 55, "size": 0.9, "color": "0.2,0.6,0.8", "mesh_scale": "0.9,0.9,0.9"},
        "boss_destroyer": {"health": 3000, "shield": 1000, "speed": 8, "size": 8.0, "color": "0.8,0.1,0.1", "mesh_scale": "6,4,8"},
    }
    for eid, data in enemies.items():
        u = uid()
        content = f'''[gd_scene load_steps=7 format=3 uid="{u}"]

[ext_resource type="Script" path="res://scripts/enemy.gd" id="1"]

[sub_resource type="BoxMesh" id="2"]
size = Vector3(1, 0.4, 1.4)

[sub_resource type="StandardMaterial3D" id="3"]
albedo_color = Color({data["color"]}, 1)
metallic = 0.6
roughness = 0.4
emission = Color({data["color"]}, 0.3)
emission_enabled = true

[sub_resource type="BoxMesh" id="4"]
size = Vector3(1.4, 0.15, 0.8)

[sub_resource type="StandardMaterial3D" id="5"]
albedo_color = Color({data["color"]}, 0.8)
metallic = 0.5
roughness = 0.5

[sub_resource type="SphereShape3D" id="6"]
radius = 1.5

[node name="{eid.title()}" type="CharacterBody3D"]
script = ExtResource("1")
collision_layer = 8
collision_mask = 6
enemy_type = "{eid}"

[node name="CollisionShape3D" type="CollisionShape3D" parent="."]
shape = SubResource("6")
scale = Vector3({data["mesh_scale"]})

[node name="MeshRoot" type="Node3D" parent="."]
groups = ["EnemyMesh"]
scale = Vector3({data["mesh_scale"]})

[node name="Body" type="MeshInstance3D" parent="MeshRoot"]
mesh = SubResource("2")
material_override = SubResource("3")

[node name="Wings" type="MeshInstance3D" parent="MeshRoot"]
mesh = SubResource("4")
material_override = SubResource("5")
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)

[node name="Muzzle" type="Marker3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, -1.5)

[node name="HealthBar" type="Node3D" parent="."]
visible = false

[node name="ShieldBar" type="Node3D" parent="."]
visible = false

[node name="VisibilityNotifier" type="VisibleOnScreenNotifier3D" parent="."]
'''
        if eid == "boss_destroyer":
            content += f'''
[sub_resource type="BoxMesh" id="7"]
size = Vector3(2, 1, 2)

[sub_resource type="StandardMaterial3D" id="8"]
albedo_color = Color(0.9, 0.15, 0.15, 1)
metallic = 0.9
roughness = 0.1
emission = Color(0.9, 0.15, 0.15, 0.5)
emission_enabled = true

[node name="Turret" type="MeshInstance3D" parent="MeshRoot"]
mesh = SubResource("7")
material_override = SubResource("8")
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.8, 0.5)
'''
        write_tscn(f"{SCENES_DIR}/enemies/{eid}.tscn", content)

def gen_weapons():
    weapons = {
        "laser": {"type": "laser", "color": "1,0.2,0.2", "shape": "cylinder", "height": 0.5, "radius": 0.1},
        "plasma": {"type": "plasma", "color": "0.2,0.8,1", "shape": "sphere", "radius": 0.3},
        "missile": {"type": "missile", "color": "1,0.6,0", "shape": "cylinder", "height": 1.0, "radius": 0.15},
        "railgun": {"type": "railgun", "color": "1,1,0.5", "shape": "cylinder", "height": 2.0, "radius": 0.05},
        "flak": {"type": "flak", "color": "1,0.8,0.2", "shape": "sphere", "radius": 0.15},
        "beam": {"type": "beam", "color": "1,0,1", "shape": "cylinder", "height": 0.1, "radius": 0.02},
        "ion": {"type": "ion", "color": "0,1,1", "shape": "sphere", "radius": 0.25},
    }
    for wid, data in weapons.items():
        u = uid()
        if data["shape"] == "sphere":
            mesh_code = f'''[sub_resource type="SphereMesh" id="2"]
radius = {data["radius"]}
height = {data["radius"] * 2}'''
        else:
            mesh_code = f'''[sub_resource type="CylinderMesh" id="2"]
top_radius = {data["radius"]}
bottom_radius = {data["radius"]}
height = {data["height"]}'''

        content = f'''[gd_scene load_steps=4 format=3 uid="{u}"]

[ext_resource type="Script" path="res://scripts/projectile.gd" id="1"]

{mesh_code}

[sub_resource type="StandardMaterial3D" id="3"]
albedo_color = Color({data["color"]}, 1)
emission = Color({data["color"]}, 1)
emission_enabled = true
emission_energy_multiplier = 2.0
transparency = 1
metallic = 0.0
roughness = 1.0

[node name="{wid.title()}" type="Area3D"]
collision_layer = 4
collision_mask = 8
script = ExtResource("1")

[node name="Mesh" type="MeshInstance3D" parent="."]
mesh = SubResource("2")
material_override = SubResource("3")

[node name="Light" type="OmniLight3D" parent="."]
light_color = Color({data["color"]}, 1)
light_energy = 2.0
omni_range = 5.0
'''
        write_tscn(f"{SCENES_DIR}/weapons/{wid}.tscn", content)

def gen_explosions():
    explosions = {
        "small": {"amount": 30, "scale_min": 0.2, "scale_max": 0.5, "vel_min": 2, "vel_max": 8, "radius": 2.0, "energy": 5.0, "debris": 3, "lifetime": 1.0},
        "medium": {"amount": 80, "scale_min": 0.3, "scale_max": 0.8, "vel_min": 3, "vel_max": 12, "radius": 5.0, "energy": 15.0, "debris": 8, "lifetime": 1.5},
        "large": {"amount": 200, "scale_min": 0.5, "scale_max": 1.5, "vel_min": 5, "vel_max": 20, "radius": 10.0, "energy": 30.0, "debris": 20, "lifetime": 2.0},
    }
    for etype, data in explosions.items():
        u = uid()
        content = f'''[gd_scene load_steps=3 format=3 uid="{u}"]

[ext_resource type="Script" path="res://scripts/explosion_effect.gd" id="1"]

[sub_resource type="ParticleProcessMaterial" id="2"]
emission_shape = 0
emission_sphere_radius = {data["radius"] * 0.5}
gravity = Vector3(0, 0, 0)
initial_velocity_min = {data["vel_min"]}
initial_velocity_max = {data["vel_max"]}
scale_min = {data["scale_min"]}
scale_max = {data["scale_max"]}
color = Color(1, 0.6, 0.2, 1)

[node name="Explosion_{etype.title()}" type="Node3D"]
script = ExtResource("1")
explosion_type = "{etype}"
particle_count = {data["amount"]}
explosion_force = {data["vel_max"]}
explosion_radius = {data["radius"]}
duration = {data["lifetime"]}
particle_lifetime = {data["lifetime"]}
'''
        write_tscn(f"{SCENES_DIR}/effects/explosion_{etype}.tscn", content)

def gen_pickups():
    pickups = {
        "health": {"color": "0,1,0", "shape": "box", "pickup_type": "health"},
        "shield": {"color": "0,0.5,1", "shape": "sphere", "pickup_type": "shield"},
        "energy": {"color": "1,1,0", "shape": "cylinder", "pickup_type": "energy"},
        "credits": {"color": "1,0.8,0", "shape": "box", "pickup_type": "credits"},
        "weapon_upgrade": {"color": "1,0,1", "shape": "torus", "pickup_type": "weapon_upgrade"},
        "missile_ammo": {"color": "1,0.5,0", "shape": "cylinder", "pickup_type": "missile_ammo"},
    }
    for pid, data in pickups.items():
        u = uid()
        if data["shape"] == "box":
            mesh_part = '''[sub_resource type="BoxMesh" id="2"]
size = Vector3(0.8, 0.8, 0.8)'''
        elif data["shape"] == "sphere":
            mesh_part = '''[sub_resource type="SphereMesh" id="2"]
radius = 0.5
height = 1.0'''
        elif data["shape"] == "cylinder":
            mesh_part = '''[sub_resource type="CylinderMesh" id="2"]
top_radius = 0.3
bottom_radius = 0.3
height = 0.6'''
        elif data["shape"] == "torus":
            mesh_part = '''[sub_resource type="TorusMesh" id="2"]
inner_radius = 0.2
outer_radius = 0.5'''

        content = f'''[gd_scene load_steps=4 format=3 uid="{u}"]

[ext_resource type="Script" path="res://scripts/pickup.gd" id="1"]

{mesh_part}

[sub_resource type="StandardMaterial3D" id="3"]
albedo_color = Color({data["color"]}, 1)
emission = Color({data["color"]}, 1)
emission_enabled = true
emission_energy_multiplier = 0.5
metallic = 0.5
roughness = 0.3
transparency = 1

[node name="{pid.title()}" type="Area3D"]
collision_layer = 0
collision_mask = 2
script = ExtResource("1")
pickup_type = "{data["pickup_type"]}"

[node name="Mesh" type="MeshInstance3D" parent="."]
mesh = SubResource("2")
material_override = SubResource("3")

[node name="Glow" type="OmniLight3D" parent="."]
light_color = Color({data["color"]}, 1)
light_energy = 2.0
omni_range = 5.0

[sub_resource type="SphereShape3D" id="4"]
radius = 1.5

[node name="CollisionShape3D" type="CollisionShape3D" parent="."]
shape = SubResource("4")
'''
        write_tscn(f"{SCENES_DIR}/pickups/{pid}.tscn", content)

def gen_hud():
    u = uid()
    content = f'''[gd_scene load_steps=2 format=3 uid="{u}"]

[ext_resource type="Script" path="res://scripts/hud.gd" id="1"]

[node name="HUD" type="Control"]
anchor_right = 1.0
anchor_bottom = 1.0
script = ExtResource("1")

[node name="HullBar" type="TextureProgressBar" parent="."]
offset_left = 20.0
offset_top = 640.0
offset_right = 220.0
offset_bottom = 664.0
fill_mode = 2
tint_under = Color(0.3, 0.1, 0.1, 0.6)
tint_progress = Color(0.2, 0.8, 0.2, 1)
value = 1.0

[node name="Label" type="Label" parent="HullBar"]
offset_left = 0.0
offset_top = 0.0
offset_right = 200.0
offset_bottom = 24.0
text = "Hull: 100/100"
theme_overrides/font_sizes/font_size = 12
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="ShieldBar" type="TextureProgressBar" parent="."]
offset_left = 20.0
offset_top = 668.0
offset_right = 220.0
offset_bottom = 692.0
fill_mode = 2
tint_under = Color(0.1, 0.1, 0.3, 0.6)
tint_progress = Color(0.0, 0.5, 1, 1)
value = 1.0

[node name="Label" type="Label" parent="ShieldBar"]
offset_left = 0.0
offset_top = 0.0
offset_right = 200.0
offset_bottom = 24.0
text = "Shield: 100/100"
theme_overrides/font_sizes/font_size = 12
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="EnergyBar" type="TextureProgressBar" parent="."]
offset_left = 20.0
offset_top = 696.0
offset_right = 220.0
offset_bottom = 720.0
fill_mode = 2
tint_under = Color(0.3, 0.3, 0.1, 0.6)
tint_progress = Color(1, 1, 0, 1)
value = 1.0

[node name="Label" type="Label" parent="EnergyBar"]
offset_left = 0.0
offset_top = 0.0
offset_right = 200.0
offset_bottom = 24.0
text = "Energy: 100/100"
theme_overrides/font_sizes/font_size = 12
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="MissileBar" type="TextureProgressBar" parent="."]
offset_left = 240.0
offset_top = 696.0
offset_right = 340.0
offset_bottom = 720.0
fill_mode = 2
tint_under = Color(0.3, 0.15, 0.05, 0.6)
tint_progress = Color(1, 0.5, 0, 1)
value = 1.0

[node name="Label" type="Label" parent="MissileBar"]
offset_left = 0.0
offset_top = 0.0
offset_right = 100.0
offset_bottom = 24.0
text = "MSL: 10"
theme_overrides/font_sizes/font_size = 11
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="ScoreLabel" type="Label" parent="."]
offset_left = 1060.0
offset_top = 10.0
offset_right = 1270.0
offset_bottom = 40.0
text = "Score: 0"
horizontal_alignment = 2
theme_overrides/font_sizes/font_size = 20
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="WaveLabel" type="Label" parent="."]
offset_left = 20.0
offset_top = 10.0
offset_right = 200.0
offset_bottom = 40.0
text = "Wave 1"
theme_overrides/font_sizes/font_size = 20
theme_overrides/colors/font_color = Color(1, 0.8, 0.2, 1)

[node name="CreditsLabel" type="Label" parent="."]
offset_left = 20.0
offset_top = 620.0
offset_right = 200.0
offset_bottom = 640.0
text = "Credits: 0"
theme_overrides/font_sizes/font_size = 14
theme_overrides/colors/font_color = Color(1, 0.8, 0, 1)

[node name="WeaponLabel" type="Label" parent="."]
offset_left = 240.0
offset_top = 660.0
offset_right = 440.0
offset_bottom = 686.0
text = "Basic Laser"
theme_overrides/font_sizes/font_size = 14
theme_overrides/colors/font_color = Color(1, 0.6, 0.6, 1)

[node name="LivesLabel" type="Label" parent="."]
offset_left = 240.0
offset_top = 686.0
offset_right = 340.0
offset_bottom = 710.0
text = "Lives: 3"
theme_overrides/font_sizes/font_size = 14
theme_overrides/colors/font_color = Color(0.3, 1, 0.3, 1)

[node name="Crosshair" type="Control" parent="."]
offset_left = 620.0
offset_top = 340.0
offset_right = 660.0
offset_bottom = 380.0

[node name="DamageOverlay" type="ColorRect" parent="."]
anchor_right = 1.0
anchor_bottom = 1.0
color = Color(1, 0, 0, 0)
mouse_filter = 2

[node name="EnemyIndicators" type="Control" parent="."]
anchor_right = 1.0
anchor_bottom = 1.0
mouse_filter = 2

[node name="BossHealthBar" type="TextureProgressBar" parent="."]
offset_left = 340.0
offset_top = 20.0
offset_right = 940.0
offset_bottom = 48.0
fill_mode = 2
tint_under = Color(0.3, 0.05, 0.05, 0.6)
tint_progress = Color(1, 0.15, 0.15, 1)
value = 1.0
visible = false

[node name="Label" type="Label" parent="BossHealthBar"]
offset_left = 0.0
offset_top = 0.0
offset_right = 600.0
offset_bottom = 28.0
horizontal_alignment = 1

[node name="BossNameLabel" type="Label" parent="."]
offset_left = 340.0
offset_top = 2.0
offset_right = 940.0
offset_bottom = 22.0
text = "DESTROYER BOSS"
horizontal_alignment = 1
theme_overrides/font_sizes/font_size = 14
theme_overrides/colors/font_color = Color(1, 0.2, 0.2, 1)
visible = false

[node name="SpeedIndicator" type="Label" parent="."]
offset_left = 1060.0
offset_top = 660.0
offset_right = 1260.0
offset_bottom = 686.0
text = "SPD: 50"
horizontal_alignment = 2
theme_overrides/font_sizes/font_size = 14
theme_overrides/colors/font_color = Color(0.5, 1, 0.5, 1)

[node name="AccuracyLabel" type="Label" parent="."]
offset_left = 1060.0
offset_top = 686.0
offset_right = 1260.0
offset_bottom = 710.0
text = "Acc: 0.0%"
horizontal_alignment = 2
theme_overrides/font_sizes/font_size = 12
theme_overrides/colors/font_color = Color(0.7, 0.7, 0.7, 1)
'''
    write_tscn(f"{SCENES_DIR}/hud.tscn", content)

def gen_shop():
    u = uid()
    content = f'''[gd_scene load_steps=2 format=3 uid="{u}"]

[ext_resource type="Script" path="res://scripts/shop_menu.gd" id="1"]

[node name="ShopMenu" type="Control"]
visible = false
anchor_right = 1.0
anchor_bottom = 1.0
script = ExtResource("1")

[node name="VBoxContainer" type="VBoxContainer" parent="."]
offset_left = 140.0
offset_top = 40.0
offset_right = 1140.0
offset_bottom = 680.0

[node name="CreditsLabel" type="Label" parent="VBoxContainer"]
layout_mode = 2
text = "Credits: 1000"
theme_overrides/font_sizes/font_size = 24
theme_overrides/colors/font_color = Color(1, 0.8, 0, 1)

[node name="MarginContainer" type="MarginContainer" parent="VBoxContainer"]
layout_mode = 2
size_flags_vertical = 3

[node name="HBoxContainer" type="HBoxContainer" parent="VBoxContainer/MarginContainer"]
layout_mode = 2

[node name="ShipPanel" type="Panel" parent="VBoxContainer/MarginContainer/HBoxContainer"]
layout_mode = 2
size_flags_horizontal = 3

[node name="Label" type="Label" parent="VBoxContainer/MarginContainer/HBoxContainer/ShipPanel"]
offset_left = 10.0
offset_top = 10.0
offset_right = 200.0
offset_bottom = 36.0
text = "SHIPS"
theme_overrides/font_sizes/font_size = 18
theme_overrides/colors/font_color = Color(0.3, 0.6, 1, 1)

[node name="ShipList" type="ItemList" parent="VBoxContainer/MarginContainer/HBoxContainer/ShipPanel"]
offset_left = 10.0
offset_top = 40.0
offset_right = 290.0
offset_bottom = 500.0
allow_reselect = false
allow_search = false
auto_height = true
fixed_column_width = 280

[node name="WeaponPanel" type="Panel" parent="VBoxContainer/MarginContainer/HBoxContainer"]
layout_mode = 2
size_flags_horizontal = 3

[node name="Label" type="Label" parent="VBoxContainer/MarginContainer/HBoxContainer/WeaponPanel"]
offset_left = 10.0
offset_top = 10.0
offset_right = 200.0
offset_bottom = 36.0
text = "WEAPONS"
theme_overrides/font_sizes/font_size = 18
theme_overrides/colors/font_color = Color(1, 0.3, 0.3, 1)

[node name="WeaponList" type="ItemList" parent="VBoxContainer/MarginContainer/HBoxContainer/WeaponPanel"]
offset_left = 10.0
offset_top = 40.0
offset_right = 290.0
offset_bottom = 500.0
allow_reselect = false
allow_search = false
auto_height = true
fixed_column_width = 280

[node name="UpgradePanel" type="Panel" parent="VBoxContainer/MarginContainer/HBoxContainer"]
layout_mode = 2
size_flags_horizontal = 3
visible = false

[node name="InfoPanel" type="Panel" parent="VBoxContainer/MarginContainer/HBoxContainer"]
layout_mode = 2
size_flags_horizontal = 3

[node name="DescriptionLabel" type="Label" parent="VBoxContainer/MarginContainer/HBoxContainer/InfoPanel"]
offset_left = 10.0
offset_top = 10.0
offset_right = 380.0
offset_bottom = 200.0
autowrap_mode = 2
text = "Select an item to see details."
theme_overrides/font_sizes/font_size = 14
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="PriceLabel" type="Label" parent="VBoxContainer/MarginContainer/HBoxContainer/InfoPanel"]
offset_left = 10.0
offset_top = 210.0
offset_right = 380.0
offset_bottom = 240.0
text = ""
theme_overrides/font_sizes/font_size = 18
theme_overrides/colors/font_color = Color(1, 0.8, 0, 1)

[node name="BuyButton" type="Button" parent="VBoxContainer/MarginContainer/HBoxContainer/InfoPanel"]
offset_left = 10.0
offset_top = 250.0
offset_right = 190.0
offset_bottom = 290.0
text = "BUY"
theme_overrides/font_sizes/font_size = 18

[node name="EquipButton" type="Button" parent="VBoxContainer/MarginContainer/HBoxContainer/InfoPanel"]
offset_left = 200.0
offset_top = 250.0
offset_right = 380.0
offset_bottom = 290.0
text = "EQUIP"
theme_overrides/font_sizes/font_size = 18
visible = false

[node name="CloseButton" type="Button" parent="VBoxContainer"]
layout_mode = 2
text = "CLOSE"
theme_overrides/font_sizes/font_size = 18
theme_overrides/colors/font_color = Color(1, 1, 1, 1)
'''
    write_tscn(f"{SCENES_DIR}/shop.tscn", content)

def gen_settings():
    u = uid()
    content = f'''[gd_scene load_steps=2 format=3 uid="{u}"]

[ext_resource type="Script" path="res://scripts/settings_menu.gd" id="1"]

[node name="SettingsMenu" type="Control"]
visible = false
anchor_right = 1.0
anchor_bottom = 1.0
script = ExtResource("1")

[node name="GridContainer" type="GridContainer" parent="."]
offset_left = 340.0
offset_top = 120.0
offset_right = 940.0
offset_bottom = 600.0
columns = 2
theme_overrides/constants/vgap = 8
theme_overrides/constants/hgap = 12

[node name="MasterVolume" type="Label" parent="GridContainer"]
layout_mode = 2
text = "Master Volume"
theme_overrides/font_sizes/font_size = 16
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="HSlider" type="HSlider" parent="GridContainer/MasterVolume"]
layout_mode = 2
min_value = 0.0
max_value = 1.0
value = 1.0
size_flags_horizontal = 3

[node name="SFXVolume" type="Label" parent="GridContainer"]
layout_mode = 2
text = "SFX Volume"
theme_overrides/font_sizes/font_size = 16
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="HSlider" type="HSlider" parent="GridContainer/SFXVolume"]
layout_mode = 2
min_value = 0.0
max_value = 1.0
value = 1.0
size_flags_horizontal = 3

[node name="MusicVolume" type="Label" parent="GridContainer"]
layout_mode = 2
text = "Music Volume"
theme_overrides/font_sizes/font_size = 16
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="HSlider" type="HSlider" parent="GridContainer/MusicVolume"]
layout_mode = 2
min_value = 0.0
max_value = 1.0
value = 0.7
size_flags_horizontal = 3

[node name="Sensitivity" type="Label" parent="GridContainer"]
layout_mode = 2
text = "Sensitivity"
theme_overrides/font_sizes/font_size = 16
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="HSlider" type="HSlider" parent="GridContainer/Sensitivity"]
layout_mode = 2
min_value = 0.1
max_value = 3.0
step = 0.1
value = 1.0
size_flags_horizontal = 3

[node name="InvertY" type="Label" parent="GridContainer"]
layout_mode = 2
text = "Invert Y-Axis"
theme_overrides/font_sizes/font_size = 16
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="CheckButton" type="CheckButton" parent="GridContainer/InvertY"]
layout_mode = 2
text = "Off"

[node name="Vibration" type="Label" parent="GridContainer"]
layout_mode = 2
text = "Vibration"
theme_overrides/font_sizes/font_size = 16
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="CheckButton" type="CheckButton" parent="GridContainer/Vibration"]
layout_mode = 2
text = "On"
button_pressed = true

[node name="GraphicsQuality" type="Label" parent="GridContainer"]
layout_mode = 2
text = "Graphics Quality"
theme_overrides/font_sizes/font_size = 16
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="OptionButton" type="OptionButton" parent="GridContainer/GraphicsQuality"]
layout_mode = 2
text = "High"
size_flags_horizontal = 3
item_count = 4
popup/item_0/text = "Low"
popup/item_1/text = "Medium"
popup/item_2/text = "High"
popup/item_3/text = "Ultra"
selected = 2

[node name="ShowFPS" type="Label" parent="GridContainer"]
layout_mode = 2
text = "Show FPS"
theme_overrides/font_sizes/font_size = 16
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="CheckButton" type="CheckButton" parent="GridContainer/ShowFPS"]
layout_mode = 2
text = "Off"

[node name="CloseButton" type="Button" parent="."]
offset_left = 540.0
offset_top = 620.0
offset_right = 740.0
offset_bottom = 660.0
text = "CLOSE"
theme_overrides/font_sizes/font_size = 18
theme_overrides/colors/font_color = Color(1, 1, 1, 1)
'''
    write_tscn(f"{SCENES_DIR}/settings.tscn", content)

def gen_game_over():
    u = uid()
    content = f'''[gd_scene load_steps=2 format=3 uid="{u}"]

[ext_resource type="Script" path="res://scripts/game_over_screen.gd" id="1"]

[node name="GameOverScreen" type="Control"]
anchor_right = 1.0
anchor_bottom = 1.0
script = ExtResource("1")

[node name="VBoxContainer" type="VBoxContainer" parent="."]
offset_left = 340.0
offset_top = 120.0
offset_right = 940.0
offset_bottom = 600.0
theme_overrides/constants/separation = 8

[node name="TitleLabel" type="Label" parent="VBoxContainer"]
layout_mode = 2
text = "GAME OVER"
horizontal_alignment = 1
theme_overrides/font_sizes/font_size = 48
theme_overrides/colors/font_color = Color(1, 0.2, 0.2, 1)

[node name="ScoreLabel" type="Label" parent="VBoxContainer"]
layout_mode = 2
text = "Score: 0"
horizontal_alignment = 1
theme_overrides/font_sizes/font_size = 28
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="WaveLabel" type="Label" parent="VBoxContainer"]
layout_mode = 2
text = "Waves Survived: 0"
horizontal_alignment = 1
theme_overrides/font_sizes/font_size = 18
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="EnemiesLabel" type="Label" parent="VBoxContainer"]
layout_mode = 2
text = "Enemies Destroyed: 0"
horizontal_alignment = 1
theme_overrides/font_sizes/font_size = 18
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="AccuracyLabel" type="Label" parent="VBoxContainer"]
layout_mode = 2
text = "Accuracy: 0.0%"
horizontal_alignment = 1
theme_overrides/font_sizes/font_size = 18
theme_overrides/colors/font_color = Color(1, 1, 1, 1)

[node name="CreditsLabel" type="Label" parent="VBoxContainer"]
layout_mode = 2
text = "Credits Earned: 0"
horizontal_alignment = 1
theme_overrides/font_sizes/font_size = 18
theme_overrides/colors/font_color = Color(1, 0.8, 0, 1)

[node name="HighScoreLabel" type="Label" parent="VBoxContainer"]
layout_mode = 2
text = "High Score: 0"
horizontal_alignment = 1
theme_overrides/font_sizes/font_size = 22
theme_overrides/colors/font_color = Color(0.3, 1, 0.3, 1)

[node name="ContinueButton" type="Button" parent="VBoxContainer"]
layout_mode = 2
text = "CONTINUE (ENTER)"
theme_overrides/font_sizes/font_size = 22

[node name="MenuButton" type="Button" parent="VBoxContainer"]
layout_mode = 2
text = "MAIN MENU (ESC)"
theme_overrides/font_sizes/font_size = 22

[node name="QuitButton" type="Button" parent="VBoxContainer"]
layout_mode = 2
text = "QUIT"
theme_overrides/font_sizes/font_size = 22
'''
    write_tscn(f"{SCENES_DIR}/game_over.tscn", content)

def gen_touch_controls():
    u = uid()
    content = f'''[gd_scene load_steps=2 format=3 uid="{u}"]

[ext_resource type="Script" path="res://scripts/touch_controls.gd" id="1"]

[node name="TouchControls" type="Control"]
anchor_right = 1.0
anchor_bottom = 1.0
script = ExtResource("1")

[node name="LeftJoystick" type="TouchScreenButton" parent="."]
offset_left = 20.0
offset_top = 520.0
offset_right = 160.0
offset_bottom = 660.0
shape = SubResource("circle")
shape_visible = true

[sub_resource type="CircleShape2D" id="2"]
radius = 70.0

[node name="RightJoystick" type="TouchScreenButton" parent="."]
offset_left = 1120.0
offset_top = 520.0
offset_right = 1260.0
offset_bottom = 660.0
shape = SubResource("3")

[sub_resource type="CircleShape2D" id="3"]
radius = 70.0

[node name="FireButton" type="TouchScreenButton" parent="."]
offset_left = 1060.0
offset_top = 520.0
offset_right = 1100.0
offset_bottom = 560.0
shape = SubResource("4")

[sub_resource type="CircleShape2D" id="4"]
radius = 30.0

[node name="BoostButton" type="TouchScreenButton" parent="."]
offset_left = 1060.0
offset_top = 580.0
offset_right = 1100.0
offset_bottom = 620.0
shape = SubResource("5")

[sub_resource type="CircleShape2D" id="5"]
radius = 30.0

[node name="MissileButton" type="TouchScreenButton" parent="."]
offset_left = 1060.0
offset_top = 640.0
offset_right = 1100.0
offset_bottom = 680.0
shape = SubResource("6")

[sub_resource type="CircleShape2D" id="6"]
radius = 30.0

[node name="PauseButton" type="TouchScreenButton" parent="."]
offset_left = 1220.0
offset_top = 20.0
offset_right = 1260.0
offset_bottom = 60.0
shape = SubResource("7")

[sub_resource type="CircleShape2D" id="7"]
radius = 20.0
'''
    write_tscn(f"{SCENES_DIR}/touch_controls.tscn", content)

def gen_default_env():
    content = '''[gd_resource type="Environment" format=3 uid="uid://default_env"]

[resource]
background_mode = 0
ambient_light_color = Color(0.01, 0.01, 0.05, 1)
ambient_light_energy = 0.3
glow_enabled = true
glow_levels/1 = 0.0
glow_levels/2 = 0.0
glow_levels/3 = 1.0
glow_levels/4 = 0.0
glow_levels/5 = 0.0
glow_levels/6 = 0.0
glow_levels/7 = 0.0
glow_intensity = 0.5
glow_bloom = 0.1
fog_enabled = true
fog_density = 0.0005
fog_color = Color(0.0, 0.0, 0.03, 1)
'''
    write_tscn(os.path.join(os.path.dirname(os.path.abspath(__file__)), "assets/environments/default_env.tres"), content)

write_all_scenes()
print("\nAll scenes generated successfully!")
