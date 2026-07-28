# Sistema de Guardado — *Tu Historia Persiste*

> Formato, frecuencia, qué persiste y qué no
> Guardado asíncrono, nunca interrumpe el gameplay

---

## V1: QUÉ SE GUARDA

| Dato | Frecuencia | Tamaño |
|:-----|:----------:|:------:|
| Posición | Cada cambio | 32B |
| Nave (componentes, daño) | 5 min | ~2KB |
| Inventario | Cada cambio | ~4KB |
| Créditos y monedas | Cada cambio | 64B |
| Reputación 13 facciones | Cada cambio | 104B |
| Misiones activas | Al aceptar/completar | ~1KB |
| Tripulación | 5 min | ~2KB |
| Estaciones propias | Cada cambio | ~4KB |
| Skills y profesiones | 5 min | ~512B |

### No se guarda (regenerable)
- Planetas completos (LOD 0–2) → semilla
- Cola de eventos pasados → solo activos
- NPCs no interactuados → al entrar al sistema
- Árbol tecnología → bitset (32B)

## V2: FORMATO (ProtoBuf)

```protobuf
message SaveFile {
  uint32 version = 1; uint64 timestamp = 2; float playtime_hours = 3;
  string player_name = 4; int64 credits = 5;
  map<uint32, int32> reputation = 6; map<uint32, uint32> skills = 7;
  map<uint32, uint32> professions = 8; ShipState ship = 9;
  repeated CrewMember crew = 10; repeated InventoryItem inventory = 11;
  repeated MissionState missions = 12; repeated StationOwned stations = 13;
  bytes technology_unlocked = 14; bytes systems_visited = 15;
  repeated string achievements = 16; string save_name = 17;
}
```

## V3: BACKUPS Y DETECCIÓN DE CORRUPCIÓN

| Backup | Retención | Trigger |
|:-------|:---------:|:--------|
| Autosave | 1 archivo | Cada 5 min |
| Respaldo | 3 más recientes | Cada 30 min |
| Manual | 10 slots | A petición |
| Emergencia | 1 | Al detectar corrupción |

```rust
fn validate_save(data: &[u8]) -> Result<(), SaveError> {
    let stored = u32::from_le_bytes(data[0..4]);
    let checksum = crc32(&data[4..]);
    if checksum != stored { return Err(SaveError::ChecksumMismatch); }
    rmp_serde::from_slice::<SaveFile>(&data[4..])?;
    Ok(())
}
```

## V4: FRECUENCIA Y TIEMPOS

| Evento | Acción | Target |
|:-------|:-------|:------:|
| Timer 5 min | Auto-save bg | <200ms |
| Atraque estación | Save completo | <300ms |
| Salir del juego | Save forzoso | <500ms |
| Muerte de nave | Save post-muerte | <200ms |
| Cambio sistema | Save rápido | <50ms |
| Carga al inicio | Load | <2s |

---

*Save System: ProtoBuf, CRC32 checksum, backups rotativos, targets de rendimiento, guardado asíncrono sin pausa.*
