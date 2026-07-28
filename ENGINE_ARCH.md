# Arquitectura del Motor — *Cómo late la galaxia*

> Conexión de los 9 loops en runtime, Job System, LOD, floating origin
> Forward+ 3D / 2.5D isométrico / UI immediate mode

---

## V1: ARQUITECTURA GENERAL

```
┌──────────────────────────────────────────────────────────────┐
│                     GAME LOOP PRINCIPAL                       │
│  Tick rate: 60fps (16.6ms budget total)                      │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────┐│
│  │ INPUT    │→ │ GAMEPLAY │→ │ PHYSICS  │→ │ ANIMATION    ││
│  │          │  │ LAYER    │  │ 120Hz    │  │              ││
│  └──────────┘  └──────────┘  └──────────┘  └──────────────┘│
│       ↓            ↓              ↓               ↓         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────┐│
│  │ AUDIO   │← │ AI       │← │ GALACTIC │← │ NETWORK      ││
│  │ 64 voces│  │ 4-tier   │  │ SIM 60s  │  │ Ghost Drift  ││
│  └──────────┘  └──────────┘  └──────────┘  └──────────────┘│
│       ↓            ↓                              ↓         │
│  ┌──────────┐  ┌─────────────────────────────────────────┐  │
│  │ RENDER  │  │                  ECS                     │  │
│  │ Forward+ │  │   Entities, Components, Systems         │  │
│  │ 3D/2.5D │  └─────────────────────────────────────────┘  │
│  └──────────┘                                             │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

## V2: LOS 9 LOOPS — FRECUENCIAS Y BUDGETS

| Loop | Frecuencia | Budget | Prioridad | Hilo |
|:----:|:----------:|:------:|:---------:|:----:|
| **RENDER** | 60fps (16.6ms) | 12ms | 1 | Principal |
| **PHYSICS** | 120Hz (8.3ms) | 4ms | 2 | Worker pool |
| **AI** | 4 tiers (0.5s–60s) | 2ms total | 3 | Worker pool |
| **ECONOMY** | 10 min | 500ms | 5 | Async |
| **GALACTIC_SIM** | 60s | 30ms | 4 | Worker pool |
| **EVENT_GEN** | 4 min | 50ms | 5 | Async |
| **MISSION** | 60s + on-demand | 5ms push | 5 | Async |
| **AUDIO** | 120Hz (8.3ms) | 1ms | 6 | Separate |
| **NETWORK** | 15 min / 60s | 100ms batch | 6 | Async |

### Frame Budget (16.6ms a 60fps)

```
Input:         0.5ms
Gameplay:      2ms
Animation:     1ms
Culling:       1ms
Scene Graph:   0.5ms
3D Render:     4ms
2.5D Render:   1ms
UI:            1ms
Post-Process:  1ms
Buffer:        5.6ms (para DRS si necesario)
```

## V3: SISTEMA ECS

Componentes clave:

```rust
// Tags de identidad
struct Ship { class: ShipClass, hull_id: u32, faction: FactionId }
struct Station { class: StationClass, modules: Vec<ModuleId> }
struct Planet { seed: u64, generated_lods: BitSet<5> }

// Datos de transform
struct Transform { position: Vec3, rotation: Quat, scale: f32 }
struct PhysicsBody { velocity: Vec3, angular_vel: Vec3, mass: f32 }

// Datos de estado
struct Health { current: f32, max: f32, armor: f32 }
struct Shield { current: f32, max: f32, regen_rate: f32, online: bool }
struct Cargo { items: Vec<ItemStack>, capacity: f32 }

// Datos de combate
struct Weapon { type: WeaponType, damage: f32, cooldown: f32, range: f32 }
struct AI { behavior: AIProfile, state: AIState, target: Option<Entity> }

// Datos de red
struct GhostData { last_sync: f64, events: Vec<GhostEvent> }
```

## V4: JOB SYSTEM

Jobs se ejecutan en 4 hilos de worker + hilo principal:

```
Frame N
├── Job 1: Physics (broad phase) → Worker 1
├── Job 2: Physics (narrow phase) → Worker 2
├── Job 3: AI (tier 3, 4) → Worker 3
├── Job 4: AI (tier 1, 2) → Worker 4
├── Job 5: Culling → Hilo principal (después de physics)
└── Job 6: Render → Hilo principal
```

### Prioridades de Jobs

| Prioridad | Tipo | Ejemplo |
|:---------:|:----:|:--------|
| P0 | Critical | Input, Render |
| P1 | High | Physics, Animation |
| P2 | Medium | AI tier 1–2 |
| P3 | Low | AI tier 3–4, Particle FX |
| P4 | Background | Economy, Galactic Sim, Network |
| P5 | Idle | Save, Garbage Collection |

## V5: LOD SYSTEM (5 NIVELES)

| LOD | Distancia (UA) | Entidades | Actualización | Datos |
|:---:|:--------------:|:---------:|:-------------:|:------|
| 0 | <0.1 | 1–50 | Cada frame | Completo (mesh, AI, physics) |
| 1 | 0.1–1 | 10–200 | Cada 2 frames | Mesh simplificado, AI cada 0.5s |
| 2 | 1–5 | 50–500 | Cada 10 frames | Sprite + label, AI cada 5s |
| 3 | 5–50 | 200–2K | Cada 60 frames | Icono + tag, sin AI |
| 4 | >50 | 2K–32K+ | Bajo demanda | Punto + label, frozen |

## V6: FLOATING ORIGIN

Para manejar coordenadas enormes sin perder precisión:

```rust
struct FloatingOrigin {
    world_offset: Vec3<f64>,   // offset en FP64 (meteorológico)
    local_position: Vec3<f32>, // posición relativa en FP32
}

// Cada vez que la nave se mueve > 1km del origen:
fn rebase_origin(ship: &mut Transform, origin: &mut FloatingOrigin) {
    if ship.local_position.length() > 1000.0 {
        origin.world_offset += ship.local_position.as_f64();
        ship.local_position = Vec3::zero();
    }
}
```

## V7: RENDER PIPELINE

```
Geometry Pass (3D)
  ├── Skydome (nebulosa, estrellas de fondo)
  ├── Planetas (LOD mesh o billboard según distancia)
  └── Naves (instanciadas, LOD por clase)
        ↓
2.5D Isometric Pass
  ├── Hash grid (tilemap planetario)
  ├── Z-sort (painter's algorithm)
  └── Sprites de edificios, flora, fauna
        ↓
UI Pass
  ├── HUD (overlay)
  ├── Mapas (galáctico, sistema, planetario)
  └── Menús (astillero, mercado, tripulación)
        ↓
Post-Process
  ├── Bloom (nebulosas, motores)
  ├── ACES Tonemapping
  ├── LUT 3D (paleta sucia)
  ├── Vignette
  └── Grain
```

---

*Engine Architecture: 7 volúmenes, 9 loops con frecuencias y budgets, ECS con 10 componentes, Job System 4 hilos + 6 prioridades, 5 LODs, Floating Origin FP64/FP32, Render Pipeline 4 pasos.*
