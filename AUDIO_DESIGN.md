# Música y Sonido — *La Banda Sonora del Vacío*

> Dirección de audio, tracks, temas por facción, diseño sonoro
> 64 voces simultáneas, 6 niveles de prioridad, Wwise 2024+

---

## V1: FILOSOFÍA DEL AUDIO

El espacio es silencio. Pero el interior de la nave, los sistemas de comunicaciones, y la imaginación del jugador no lo son.

- **Vacío absoluto**: fuera de la nave no hay sonido. Los combates se ven, no se oyen.
- **Conducción estructural**: el sonido viaja por el casco de la nave (subgraves, vibraciones)
- **Radio simulada**: las comunicaciones y los sensores traducen fenómenos a sonido
- **Música dinámica**: 4 stems que se mezclan según contexto

## V2: MÚSICA — TEMAS POR FACCIÓN

| Facción | Estilo | Instrumentación | Tempo | Carácter |
|:--------|:-------|:----------------|:-----:|:---------|
| **Hegemonía** | Orquestral solemne | Cuerdas, metales, coro | 80 BPM | Majestuoso, pesado |
| **Liga Rojana** | Industrial bélico | Percusión metálica, sintes distorsionados | 140 BPM | Agresivo, urgente |
| **Sindicato** | Jazz cósmico | Saxo, bajo eléctrico, batería suave | 100 BPM | Cool, calculador |
| **Iglesia** | Coral minimalista | Voces gregorianas, campanas, drones | 60 BPM | Místico, suspendido |
| **Círculo** | Electrónica ambiental | Sintetizadores modulares, field recordings | 90 BPM | Analítico, curioso |
| **Piratas** | Rock sucio | Guitarra distorsionada, batería, armónica | 130 BPM | Callejero, peligroso |
| **Xylo** | Glitch / digital | Texturas de datos, pulsos cuánticos | Variable | Alienígena, incómodo |
| **Culto** | Drone / ruido | Infrasonidos, frecuencias bajas | <40 BPM | Amenazante, vacío |
| **Frontera** | Folk espacial | Guitarra acústica, banjo, armónica | 110 BPM | Rústico, esperanzado |
| **Guardianes** | Ambiente frío | Pad sintético, campanas de cristal | 70 BPM | Alerta, contenido |

## V3: MÚSICA DINÁMICA — 4 STEMS

| Stem | Contenido | Volumen base | Mezcla cuando |
|:----|:----------|:-----------:|:--------------|
| **Exploration** | Tema principal, relajado | −12dB | Navegando, en estación |
| **Combat** | Percusión intensa, brass | −INF | En combate (crossfade 2.5s) |
| **Mystery** | Drones, pads, cuerdas tensas | −20dB | Cerca de anomalías, ruinas |
| **Danger** | Alarma rítmica, graves | −INF | Baja salud, bajo combustible, persecución |

La transición entre stems usa crossfade de 2.5s con detección de tempo (beat-matching si BPM compatible).

## V4: EFECTOS DE SONIDO

### Motores por Clase

| Clase de motor | Sonido | Rango audible (UA) |
|:--------------|:-------|:------------------:|
| Caza (I) | Zumbido agudo, 8KHz | 0.1 |
| Corbeta (II) | Ronroneo medio, 200Hz | 0.3 |
| Fragata (III) | Retumbar grave, 80Hz | 0.5 |
| Crucero (V) | Temblor profundo, 40Hz | 1.0 |
| Acorazado (VI) | Infrasonido, 25Hz | 2.0 |
| Titán (VIII) | Terremoto, 15Hz | 5.0 |

### Armas

| Arma | Sonido | Característica |
|:-----|:-------|:--------------|
| Láser | Zumbido modulado + siseo | Frecuencia portadora 1KHz, modulada a 4Hz |
| Railgun | Golpe seco + boom subsónico | Transiente de 5ms, seguido de 200ms de retumbar |
| Misil | Silbido ascendente | Frecuencia sube de 200Hz a 2KHz en 2s |
| Iónico | Arco eléctrico + chasquido | Ruido de alta frecuencia, 5KHz+ |
| Resonancia | Pulso que distorsiona | Inaudible (infrasonido) + distorsión en otros sonidos |
| Explosión | Grave + metralla | 40Hz fundamental + ruido blanco modulado 500ms |

### Entornos

| Entorno | Sonido ambiental |
|:--------|:-----------------|
| Vacío | Silencio absoluto (solo respiración, latidos) |
| Interior de nave | Zumbido de sistemas, ventilación, pasos metálicos |
| Estación espacial | Anuncios ambientales, tráfico, máquinas |
| Atmósfera planetaria | Viento, estática de fricción atmosférica |
| Nebulosa | Interferencia de radio, crujidos eléctricos |
| Campo de asteroides | Impactos lejanos, ecos metálicos (conducción estructural) |

## V5: RITMO CARDÍACO DEL JUGADOR

El juego simula un ritmo cardíaco (40–180 BPM) que:

- **Base**: reposo en estación (60 BPM)
- **Navegación**: 70–90 BPM
- **Alerta (enemigo detectado)**: 100–120 BPM
- **Combate**: 120–150 BPM
- **Muerte inminente**: 150–180 BPM

El ritmo se sincroniza con la percusión de la música (cuando hay).

---

*Diseño de audio: 10 temas por facción, 4 stems dinámicos, efectos por clase de motor y arma, entornos, ritmo cardíaco sincronizado.*
