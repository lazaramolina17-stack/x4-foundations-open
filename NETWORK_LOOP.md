# NETWORK LOOP — Especificación de Ingeniería

## Motor Ghost Drift
## Estado: Stateless por diseño. 0 dependencia de red en modo base.

---

## 1. Arquitectura General

```
┌─────────────────────────────────────────────────────┐
│                   GAME CLIENT                        │
│  ┌─────────────────────────────────────────────┐    │
│  │  Single-Player Engine                        │    │
│  │  (0 llamadas de red, 0 dependencias externas) │    │
│  └─────────────────────────────────────────────┘    │
│                           │                          │
│               ┌───────────┴───────────┐              │
│               │   Ghost Drift Module  │              │
│               │   (opt-in, thread)    │              │
│               └───────────┬───────────┘              │
│                           │                          │
│                    HTTPS / zstd                      │
│                           │                          │
└───────────────────────────┼──────────────────────────┘
                            │
                    ┌───────┴───────┐
                    │  Relay Server │
                    │  (Rust, AXUM) │
                    │   Stateless   │
                    └───────────────┘
```

### 1.1 Modos de operación

| Modo | Llamadas de red | Dependencias | Persistencia |
|------|----------------|--------------|--------------|
| **Single-Player** | 0 | Ninguna | 100% local |
| **Ghost Drift** | ~2 POST + N GET por sesión | Relay server público/autogestionado | Local + relay |

### 1.2 Principios fundamentales

- **No hay lobby, no hay matchmaking, no hay presencia**
- **No hay authoritative server**: el cliente es el único autoridad de su simulación
- **No hay real-time sync**: cero WebSocket, cero streaming, cero UDP
- **No hay identidad de jugador**: el relay no sabe quién eres
- **No hay estado compartido**: cada universo es una bifurcación independiente

---

## 2. Ghost Drift — Mecánica de Red

### 2.1 Flujo conceptual

```
Jugador A (15:00 UTC)                       Jugador B (18:00 UTC)
    │                                              │
    ├─ Juega 2h                                    │
    ├─ Su flota conquista Sistema X                 │
    ├─ Su facción pierde Sistema Y                  │
    │                                              │
    ├─ POST /events (eventos comprimidos) ──────┐  │
    │                                            │  │
    ▼                                            ▼  ▼
    ┌──────────────┐                    ┌──────────────┐
    │  Relay Server │ ── TTL 30d ──▶   │  Relay Server │
    │  (shard X)    │                    │  (shard X)    │
    └──────────────┘                    └──────────────┘
                                                │
    ┌──────────────┐                            │
    │  Jugador C   │ ◀── GET /fragments ────────┘
    │  (20:00 UTC) │       since=15:00
    └──────────────┘       region=Sector_7
         │
         ├─ Recibe: "Facción A conquistó Sistema X"
         ├─ Recibe: "Facción B perdió Sistema Y"
         ├─ Aplica al estado local (próximo tick)
         └─ El universo de C cambió sin que C jugara
```

### 2.2 Qué se sube (y qué NO)

**NO se sube** (privacidad absoluta):
- Posición del jugador
- Inventario, créditos, naves del jugador
- Datos de misión, diálogos, progreso de historia
- Identificadores persistentes (IP, UUID de hardware, etc.)
- Telemetría de rendimiento, crashes, uso de CPU/GPU

**SÍ se sube** (eventos anonimizados):
```
Evento: Facción conquistó/pierde sistema
Payload: { faction_id, system_id, old_owner, new_owner, timestamp }
Tamaño: ~120 bytes comprimido

Evento: Precio de bien cambió por evento de facción
Payload: { faction_id, commodity_id, delta_percent, timestamp }
Tamaño: ~90 bytes comprimido

Evento: Estación espacial destruida/construida
Payload: { station_id, system_id, action, timestamp }
Tamaño: ~80 bytes comprimido

Evento: Guerra declarada/terminada entre facciones
Payload: { faction_a, faction_b, action, timestamp }
Tamaño: ~70 bytes comprimido
```

### 2.3 Frecuencia de subida

| Modo | Trigger | Batch |
|------|---------|-------|
| Sesión activa | Cada 15 minutos | Eventos acumulados desde último POST |
| Cierre de sesión | Inmediato | Eventos restantes |
| Cambio de sistema | Opcional | Eventos del sistema saliente |

El engine acumula eventos en un buffer circular en memoria. Si el buffer excede 64KB antes del trigger, se fuerza un flush.

---

## 3. Protocolo de Comunicación

### 3.1 Transporte

| Capa | Especificación |
|------|---------------|
| Protocolo | HTTPS 1.2+ |
| Métodos | POST, GET |
| Formato de datos | **MessagePack** (binario) |
| Compresión | **zstd** nivel 9 (preferencia), fallback gzip nivel 6 |
| Content-Type | `application/x-msgpack+zstd` |
| Timeout | 10s conexión, 30s respuesta |
| Retry | 2 reintentos con backoff exponencial (1s, 4s) |

### 3.2 Endpoints

#### `POST /events`

Sube un lote de eventos al relay.

```
Request:
  Content-Type: application/x-msgpack+zstd
  Body: zstd(MessagePack({
    events: [
      {
        type: "FACTION_CONQUEST" | "FACTION_LOSS" |
              "STATION_EVENT" | "WAR_DECLARATION" |
              "COMMODITY_SHOCK",
        version: 1,           // schema version
        data: { ... },        // payload específico del evento
        timestamp: 1712345678 // UNIX seconds
      }
    ],
    client_version: "1.2.3",
    schema_hash: "a1b2c3d4"  // hash del schema de eventos
  }))

Response:
  202 Accepted
  { "ingested": 5, "duplicates": 0, "server_time": 1712345777 }

  400 Bad Request (schema mismatch)
  { "error": "schema_hash mismatch", "expected": "e5f6g7h8" }

  429 Too Many Requests (rate limit)
  { "error": "rate_limited", "retry_after": 60 }
```

#### `GET /fragments?since={timestamp}&region={sector}`

Descarga eventos ocurridos después de `since` en el sector especificado.

```
Request:
  GET /fragments?since=1712345677&region=sector_7&limit=100

Response:
  200 OK
  Content-Type: application/x-msgpack+zstd
  Body: zstd(MessagePack({
    fragments: [
      {
        type: "FACTION_CONQUEST",
        data: {
          faction_id: 3,
          system_id: "lyra_prime",
          old_owner: 1,
          new_owner: 3
        },
        timestamp: 1712345777
      }
    ],
    since: 1712345677,
    until: 1712345877,
    total_available: 1,
    truncated: false  // true si hay más de 100 eventos
  }))

  304 Not Modified (si no hay eventos nuevos)
  (body vacío)

  416 Range Not Satisfiable (since > server_time)
```

### 3.3 Schema de eventos (versión 1)

```rust
// Definición Rust del schema de eventos (MessagePack serializado)

#[derive(Serialize, Deserialize)]
pub struct EventBatch {
    pub events: Vec<Event>,
    pub client_version: String,
    pub schema_hash: String,
}

#[derive(Serialize, Deserialize)]
#[serde(tag = "type")]
pub enum Event {
    FactionConquest {
        data: FactionConquestData,
        timestamp: u64,
    },
    FactionLoss {
        data: FactionLossData,
        timestamp: u64,
    },
    StationEvent {
        data: StationEventData,
        timestamp: u64,
    },
    WarDeclaration {
        data: WarDeclarationData,
        timestamp: u64,
    },
    CommodityShock {
        data: CommodityShockData,
        timestamp: u64,
    },
}

#[derive(Serialize, Deserialize)]
pub struct FactionConquestData {
    pub faction_id: u16,
    pub system_id: String,   // hasta 32 chars
    pub old_owner: u16,
    pub new_owner: u16,
}
```

---

## 4. Loop de Red en el Cliente

### 4.1 Thread Model

```
┌─────────────────────────────────────────────────────┐
│                  GAME THREAD (main)                   │
│  Tick rate: variable (target 60fps)                  │
│  ┌─────────────────────────────────────────────────┐ │
│  │  Simulation Tick                                │ │
│  │  ├─ Physics (6-DOF integrator)                  │ │
│  │  ├─ AI (faction → system → ship)                │ │
│  │  ├─ Economy (price recalculation)               │ │
│  │  ├─ Event Detection (faction changes, etc.)     │ │
│  │  ├─ Fragment Queue Drain ←─── encolado desde red│ │
│  │  └─ Render preparation                           │ │
│  └─────────────────────────────────────────────────┘ │
└──────────────┬──────────────────────────────────────┘
               │ lock-free SPSC queue (crossbeam)
               │
┌──────────────▼──────────────────────────────────────┐
│                 NETWORK THREAD                        │
│  Tick rate: 1s (check timer), 60s (fetch timer)     │
│                                                      │
│  ┌─────────────────────────────────────────────────┐ │
│  │  Ghost Drift Loop                               │ │
│  │  ├─ Check event buffer size                     │ │
│  │  │   └─ if >= threshold OR timer_15min → POST   │ │
│  │  │                                              │ │
│  │  ├─ Check last_fetch timer                      │ │
│  │  │   └─ if >= 60s → GET /fragments              │ │
│  │  │       (since last_fetch_timestamp)           │ │
│  │  │                                              │ │
│  │  ├─ On response: push fragments to queue        │ │
│  │  │   (lock-free SPSC, non-blocking)             │ │
│  │  │                                              │ │
│  │  └─ Sleep 1s (or wake on event flush)           │ │
│  └─────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────┘
```

### 4.2 Temporal Parameters

| Parámetro | Valor | Justificación |
|-----------|-------|---------------|
| `UPLOAD_INTERVAL` | 900s (15 min) | Balance entre frescura de datos y eficiencia |
| `FETCH_INTERVAL` | 60s | Suficiente para sentir el universo vivo |
| `FLUSH_INTERVAL` | 0s (on quit) | Garantiza que los eventos de la sesión se suban |
| `BUFFER_FLUSH_THRESHOLD` | 64 KB | Evita memoria excesiva en sesiones largas |
| `FETCH_SINCE_OFFSET` | 300s (5 min) | Solapamiento para evitar perder eventos por desync de reloj |

### 4.3 Algoritmo del Network Thread (pseudocódigo)

```
loop:
    now = wall_clock()
    
    // --- UPLOAD ---
    if (now - last_upload >= UPLOAD_INTERVAL) OR (event_buffer.size >= BUFFER_FLUSH_THRESHOLD):
        batch = event_buffer.drain()
        if batch.len() > 0:
            compressed = zstd_encode(msgpack_encode(batch))
            response = http_post("/events", compressed)
            if response.status == 202:
                last_upload = now
                event_buffer.clear_acked()
            else if response.status == 429:
                backoff = response.body.retry_after
                sleep(backoff)
                continue  // retry without advancing timer
    
    // --- DOWNLOAD ---
    if (now - last_fetch >= FETCH_INTERVAL):
        regions = get_player_regions()  // sistemas cercanos al jugador
        for region in regions:
            url = "/fragments?since={last_fetch_timestamp}&region={region}"
            compressed = http_get(url)
            if compressed is not None:
                fragments = msgpack_decode(zstd_decode(compressed))
                for f in fragments:
                    fragment_queue.push(f)
        last_fetch = now

    // --- ON QUIT ---
    on_shutdown:
        batch = event_buffer.drain()
        if batch.len() > 0:
            compressed = zstd_encode(msgpack_encode(batch))
            http_post("/events", compressed)  // síncrono, bloquea hasta confirmación
        thread.join()
    
    sleep(1s)
```

### 4.4 Bandwidth estimado

| Métrica | Valor |
|---------|-------|
| Eventos generados por hora | ~15 eventos |
| Tamaño promedio por evento (sin comprimir) | ~200 bytes |
| Tamaño promedio por evento (zstd nivel 9) | ~60 bytes |
| **Total por sesión de 2h** | **~10 KB** |
| Descarga por fetch (promedio) | ~400 bytes |
| Descarga por día (24 fetches) | ~9.6 KB |
| Ancho de banda total estimado (mensual) | ~1.2 MB |

---

## 5. Aplicación de Fragments

### 5.1 Fragment Queue

```
Network Thread                    Game Thread (next tick)
    │                                   │
    │  lock-free SPSC queue             │
    │  (crossbeam_channel::bounded)     │
    │                                   │
    │  push(fragment) ───────────────▶  │
    │  push(fragment) ───────────────▶  │
    │  push(fragment) ───────────────▶  │
    │                                   │
    │                                   ├─ simulation_tick():
    │                                   │     while let Some(f) = fragment_queue.try_pop():
    │                                   │         apply_fragment(f)
    │                                   │     ...
    │                                   │     resolve_economy()
    │                                   │     resolve_faction_ai()
    │                                   │
```

### 5.2 Resolución de conflictos

| Conflicto | Regla | Ejemplo |
|-----------|-------|---------|
| Mismo sistema, mismo evento | Timestamp gana (el más reciente prevalece) | Jugador A sube "Sistema X conquistado" a T1, Jugador B sube "Sistema X perdido" a T2 → Prevalece T2 |
| Eventos duplicados | Idempotencia por hash (SHA-256 del evento) | El relay detecta duplicados por hash y responde 202 sin aplicar |
| Fragmento corrupto | Se descarta, se loggea, no crashea | Checksum SHA-256 en cada fragmento |

### 5.3 Reglas de aplicación

```
apply_fragment(fragment):
    match fragment.type:
        FACTION_CONQUEST:
            if fragment.timestamp > world.faction_events[fragment.system_id].last_timestamp:
                world.systems[fragment.system_id].owner = fragment.new_owner
                world.faction_events[fragment.system_id].last_timestamp = fragment.timestamp
                // La economía se ajusta en el próximo tick económico (15 min)
                world.economy.schedule_shock(fragment.system_id, CONQUEST_EFFECT)

        FACTION_LOSS:
            // Similar a conquest pero sin nuevo owner
            world.systems[fragment.system_id].owner = NEUTRAL

        STATION_EVENT:
            if action == "destroyed":
                world.stations[fragment.station_id].active = false
            elif action == "constructed":
                world.stations[fragment.station_id] = new_station(fragment.data)

        WAR_DECLARATION:
            world.factions[fragment.faction_a].relations[fragment.faction_b] = WAR
            world.factions[fragment.faction_b].relations[fragment.faction_a] = WAR

        COMMODITY_SHOCK:
            world.economy.prices[fragment.commodity_id] *= (1 + fragment.delta_percent)
```

### 5.4 Sin locks

El fragment queue es **lock-free** (SPSC channel). El game thread consume fragments al inicio de cada tick de simulación. El network thread nunca toca el estado del juego. Esto garantiza:

- **0 contention**: el game thread nunca espera por red
- **Determinismo**: el estado local solo cambia en ticks predecibles
- **Seguridad**: un crash en el network thread no afecta el game state

---

## 6. Relay Server (Rust)

### 6.1 Stack Tecnológico

| Componente | Tecnología |
|------------|-----------|
| HTTP framework | **Axum** 0.8+ |
| Serialización | **RMP-Serde** (MessagePack) |
| Compresión | **zstd** (rust-zstd) |
| Base de datos | **SQLite** (eventos), opcional **PostgreSQL** para producción |
| Cache | **lru** (in-memory, 10k entries) |
| Rate limiting | **governor** (token bucket por IP) |
| Sharding | Por `region` (sector galáctico) |

### 6.2 Endpoints (detalle)

| Endpoint | Método | Body | Respuesta | Latencia objetivo |
|----------|--------|------|-----------|-------------------|
| `/events` | POST | zstd(MessagePack) | 202 / 400 / 429 | <50ms |
| `/fragments` | GET | — | 200 / 304 / 416 | <100ms |
| `/health` | GET | — | 200 `{"status":"ok"}` | <10ms |

### 6.3 Esquema de base de datos (SQLite)

```sql
CREATE TABLE events (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    event_hash BLOB UNIQUE NOT NULL,     -- SHA-256, 32 bytes
    event_type TEXT NOT NULL,            -- "FACTION_CONQUEST", etc.
    region TEXT NOT NULL,                -- "sector_7"
    data BLOB NOT NULL,                  -- MessagePack serializado
    timestamp INTEGER NOT NULL,           -- UNIX seconds
    ingested_at INTEGER NOT NULL DEFAULT (unixepoch())
);

CREATE INDEX idx_events_region_timestamp ON events(region, timestamp);
CREATE INDEX idx_events_ingested ON events(ingested_at);

-- TTL cleanup: DELETE FROM events WHERE ingested_at < unixepoch() - 2592000;
```

### 6.4 Manejo de estado

```
Arquitectura del relay:

┌────────────┐     ┌────────────┐     ┌────────────┐
│  Réplica 1 │     │  Réplica 2 │     │  Réplica 3 │
│  (shard A) │     │  (shard B) │     │  (shard C) │
└──────┬─────┘     └──────┬─────┘     └──────┬─────┘
       │                  │                  │
       └──────────────────┼──────────────────┘
                          │
                    ┌─────┴─────┐
                    │  SQLite /  │
                    │ PostgreSQL │
                    └───────────┘
```

Cada réplica:
- Es **stateless** para el cliente: cualquier réplica puede servir cualquier request
- Tiene su propia instancia de BD (shard por región) o comparte una BD centralizada
- No necesita comunicarse con otras réplicas
- Puede escalar horizontalmente con un load balancer HTTP

### 6.5 Rate Limiting

| Límite | Scope | Penalidad |
|--------|-------|-----------|
| 10 POST /events por minuto | IP | 429 + `Retry-After: 60` |
| 60 GET /fragments por minuto | IP | 429 + `Retry-After: 10` |
| 100 requests/min total | IP | 429 + `Retry-After: 30` |

### 6.6 TTL y purga

- Los eventos viven **30 días** en el relay
- Un worker interno ejecuta `DELETE FROM events WHERE ingested_at < unixepoch() - 2592000` cada hora
- Las réplicas pueden purgar independientemente (no hay sync entre réplicas)

---

## 7. Seguridad y Privacidad

### 7.1 Límites de datos

```
DATOS QUE NUNCA SALEN DEL CLIENTE:
    ├── PlayerProfile.position      ✗
    ├── PlayerProfile.inventory     ✗
    ├── PlayerProfile.credits       ✗
    ├── PlayerProfile.ship_loadout  ✗
    ├── PlayerProfile.mission_log   ✗
    ├── PlayerProfile.stats         ✗
    ├── System.system_state.local   ✗ (solo se suben cambios de facción)
    └── System.player_discoveries   ✗

DATOS QUE SÍ SALEN (anonimizados):
    ├── FactionEvent.system_id      ✓ (hash unidireccional del system_id)
    ├── FactionEvent.faction_id     ✓ (IDs de facción son públicos)
    └── FactionEvent.timestamp      ✓
```

### 7.2 Anonimización

- `system_id` se ofusca con **HMAC-SHA256** usando una clave rotada diariamente (obtenida del relay en `/health`)
- `faction_id` no necesita ofuscación (son IDs públicos del juego)
- El relay no almacena IPs persistentemente (solo en memoria para rate limiting, sin loggeo)
- El relay no correlaciona eventos de la misma IP (cada POST es independiente)

### 7.3 Modo offline

- El jugador puede seleccionar **"Modo 100% Offline"** en opciones
- En este modo: el módulo Ghost Drift no se inicializa, 0 hilos de red, 0 conexiones
- El estado del juego es idéntico en funcionalidad (sin las fluctuaciones de facciones externas)
- No hay penalización al jugador offline (no hay FOMO diseñado)

---

## 8. Modding y Red

### 8.1 Pool de partidas

```
┌──────────────────────┐     ┌──────────────────────────┐
│  Pool Vanilla         │     │  Pool Modificado          │
│  (hash = oficial)     │     │  (hash != oficial)        │
│                      │     │                           │
│  POST /events        │     │  POST /events?pool=modded │
│  GET /fragments      │     │  GET /fragments?pool=modded│
└──────────────────────┘     └──────────────────────────┘
```

### 8.2 Detección de mods

- Al iniciar, el juego calcula un **hash de integridad** de:
  - Archivos de datos del juego (`*.pak`, `*.data`, `*.tbl`)
  - Schemas de eventos (versión y hash)
- Si el hash no coincide con el oficial:
  - La partida se marca como `modified`
  - Los eventos se envían al pool modificado (endpoint con `?pool=modded`)
  - Los fragments solo se reciben de otros clientes modificados

### 8.3 Consecuencias

- Mods puramente cosméticos (texturas, shaders, audio): **no alteran el hash** de datos de juego
- Mods que alteran economía, facciones, sistemas, naves: **alteran el hash** → pool modificado
- Mods de red (interceptar/modificar eventos): el relay valida schemas, eventos malformados son rechazados con 400

---

## 9. Diagrama de Secuencia Completo

```
Jugador A                     Relay                        Jugador B
    │                           │                              │
    │ [Juega 2h]                │                              │
    │ [Eventos acumulados: 12]  │                              │
    │                           │                              │
    │ POST /events ────────────▶│                              │
    │ zstd(msgpack(12 events))  │                              │
    │                           │                              │
    │ ◀─── 202 Accepted         │                              │
    │     { ingested: 12 }      │                              │
    │                           │                              │
    │ [Cierra sesión]           │                              │
    │                           │                              │
    │ POST /events ────────────▶│                              │
    │ zstd(msgpack(3 events))   │                              │
    │                           │                              │
    │ ◀─── 202 Accepted         │                              │
    │                           │                              │
    │                           │                              │ [Jugador B inicia]
    │                           │                              │ [Timer: 60s fetch]
    │                           │                              │
    │                           │     GET /fragments ─────────▶│
    │                           │     ?since=T0&region=Sect7   │
    │                           │                              │
    │                           │ ◀─── zstd(msgpack(15 events))│
    │                           │                              │
    │                           │                              │ [Push a fragment queue]
    │                           │                              │ [Próximo tick: aplicar]
    │                           │                              │
    │                           │                              │ "Facción A conquistó
    │                           │                              │  Sistema X"
    │                           │                              │ "Facción B perdió
    │                           │                              │  Sistema Y"
```

---

## 10. Escalabilidad y Costos

### 10.1 Proyección de carga

| Métrica | 1 jugador | 10K jugadores | 1M jugadores |
|---------|-----------|---------------|--------------|
| POST/hora | ~4 | ~40,000 | ~4,000,000 |
| GET/hora | ~60 | ~600,000 | ~60,000,000 |
| Eventos/hora | ~15 | ~150,000 | ~15,000,000 |
| Datos entrantes/hora | ~1 KB | ~10 MB | ~1 GB |
| Datos salientes/hora | ~24 KB | ~240 MB | ~24 GB |
| Storage (30 días) | ~3 MB | ~30 GB | ~3 TB |

### 10.2 Estrategia de sharding

```
Sharding por región galáctica:

sector_0 → réplica A (BD: relay_s0.db)
sector_1 → réplica A (BD: relay_s1.db)
sector_2 → réplica B (BD: relay_s2.db)
...
sector_15 → réplica D (BD: relay_s15.db)

Load balancing: round-robin con hash ring por region
```

### 10.3 Costo operativo estimado (10K jugadores activos)

| Recurso | Cantidad | Costo mensual estimado |
|---------|----------|----------------------|
| VPS 2GB RAM, 2 vCPU | 4 nodos | ~$80 USD |
| Storage SSD 50GB | 4 nodos | ~$20 USD |
| Transferencia (300 GB) | — | ~$10 USD |
| **Total** | | **~$110 USD/mes** |

El relay puede operar en una Raspberry Pi 4 para comunidades pequeñas (<100 jugadores).

---

## 11. Glosario

| Término | Definición |
|---------|-----------|
| **Ghost Drift** | Sistema asíncrono donde los eventos de jugadores afectan el universo de otros sin interacción directa |
| **Fragment** | Conjunto de eventos comprendidos entre dos timestamps, descargados del relay |
| **Evento** | Unidad atómica de cambio (conquista, guerra, etc.) |
| **Relay** | Servidor stateless que almacena y distribuye eventos anonimizados |
| **Pool** | Separación entre partidas vanilla y modificadas |
| **SPSC** | Single Producer Single Consumer — canal lock-free |
| **zstd** | Zstandard — algoritmo de compresión de Facebook, ratio ~3:1 en datos de juego |
| **HMAC-SHA256** | Hash con clave para ofuscación unidireccional de system_id |
