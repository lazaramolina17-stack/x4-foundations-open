# Data Pipeline — *La Sangre del Juego*

> ProtoBuf → JSON5 → MessagePack
> Esquemas, formatos de intercambio, persistencia

---

## V1: FILOSOFÍA

480,000 sistemas, ~500K entidades simultáneas, galaxia que evoluciona sin el jugador.

- **Rápidos** en runtime (MessagePack)
- **Editables** por humanos (JSON5)
- **Eficientes** en red (ProtoBuf)
- **Deterministas** (misma semilla → mismo resultado)

## V2: FORMATOS

| Formato | Uso | Velocidad | Legibilidad | Tamaño |
|:--------|:---:|:---------:|:-----------:|:------:|
| JSON5 | Authoring diseño | Lenta | Excelente | Grande |
| ProtoBuf | Red (Ghost Drift) | Rápida | Mala | Muy pequeño |
| MessagePack | Runtime, caché | Muy rápida | Mala | Pequeño |
| SQLite | Persistencia local | Rápida | Buena | Medio |

**Pipeline**: JSON5 → compilador offline → MessagePack (runtime) + ProtoBuf (red)

## V3: ESQUEMAS PRINCIPALES

### Sistema Estelar (ProtoBuf)

```protobuf
message StarSystem {
  uint64 seed = 1; string name = 2; StarType star_type = 3;
  float star_mass = 4; float star_age = 5; float star_temperature = 6;
  uint32 faction_control_id = 7; float faction_control_strength = 8;
  repeated Planet planets = 9; repeated AsteroidBelt belts = 10;
  repeated Phenomenon phenomena = 11; uint32 security_level = 12;
  bool visited = 13;
}
message Planet {
  uint32 index = 1; PlanetType type = 2; float mass = 3; float radius = 4;
  float gravity = 5; float orbital_distance = 6; float rotation_period = 7;
  bool has_atmosphere = 8; bool breathable = 9; float temperature = 10;
  ResourceCategory primary_resource = 11; ResourceCategory secondary_resource = 12;
  FactionId controlling_faction = 13; uint32 population = 14;
}
```

### Nave (JSON5 → MessagePack)

```json5
{
  class: "corbeta", hull: "Mark-7", manufacturer: "Astilleros Sol",
  mass: 120, cargo: 100, crew_max: 12,
  slots: { weapon: 2, utility: 3, defense: 1, engine: 2, special: 0 },
  base_stats: { speed: 280, maneuverability: 0.7, hull: 800, shield: 500, sensor: 5 },
  components: [
    { type: "ftl_drive", quality: 2, model: "Mark-3" },
    { type: "thruster", quality: 1, model: "Standard" },
    { type: "laser_cannon", quality: 1, model: "L-1" }
  ],
  price: 80000, faction: "hegemony"
}
```

## V4: FLUJO EN RUNTIME

```
SQLite (disco)
  ├── galaxia.db (480K sistemas, inmutable, leído al inicio)
  ├── save.db (estado del jugador)
  └── events.db (cola de eventos)
        ↓
MessagePack (caché RAM)
  ├── Sistema actual + 10 vecinos
  ├── Nave + tripulación
  ├── 500 misiones disponibles
  └── 50 eventos activos
        ↓
ProtoBuf + zstd (Ghost Drift)
  ├── POST /events (cada 15 min)
  └── GET /fragments (cada 60s)
```

## V5: PERSISTENCIA

```sql
CREATE TABLE player (
    id INTEGER PRIMARY KEY, name TEXT, credits INTEGER,
    reputation TEXT, position TEXT, ship_state BLOB,
    inventory BLOB, missions BLOB, crew BLOB,
    played_time REAL, created_at TEXT, updated_at TEXT
);
```

**Frecuencia**: auto-save cada 5 min, save completo al atracar/salir, parcial al aceptar misión o cambiar de sistema.

---

*Data Pipeline: 4 formatos, pipeline JSON5→MessagePack+ProtoBuf, flujo disco→RAM→red, persistencia SQLite.*
