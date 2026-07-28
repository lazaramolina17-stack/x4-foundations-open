# Sistema de Combate — *El Juego de Mil Millones de Muerte*

> Diseño detallado: tipos de daño, blindaje, escudos, subsistemas, targeting, maniobras, abordajes, IA de combate

---

## VOLUMEN 1: FILOSOFÍA DEL COMBATE

El combate en este juego no es un shooter tradicional. Es una simulación de combate espacial donde cada decisión tiene consecuencias duraderas. El jugador debe:

- **Entender el ecosistema de combate**: cada clase de nave tiene un rol específico y debe usar su ventaja táctica
- **Gestionar recursos en tiempo real**: combustible, blindaje, munición, y tiempo de recarga
- **Tomar decisiones tácticas**: elegir entre ataque frontal, emboscada, o retirada estratégica
- **Gestionar el riesgo**: cada acción tiene consecuencias que afectan la supervivencia a largo plazo

El juego no premia la reacción rápida, sino la **planificación estratégica y la adaptación continua**.

---

## VOLUMEN 2: TIPOS DE DAÑO Y SU INTERACCIÓN

El daño se clasifica en 6 categorías, cada una con mecánicas específicas:

| Tipo de Daño | Origen | Efecto sobre blindaje | Efecto sobre escudos | Efecto sobre componentes | Visual |
|-------------|--------|---------------------|----------------------|------------------------|--------|
| **Cinético** (balas, proyectiles) | Cañones, misiles | +20% daño | −30% daño | +30% probabilidad de daño a componentes | Proyectiles visibles, chispas |
| **Energía** (láser, plasma) | Láseres, armas de energía | −20% daño | +30% daño | −20% probabilidad de impacto en componentes | Hazo continuo, quemadura en casco |
| **Explosivo** (misiles, bombas) | Misiles, granadas | +10% daño | +10% daño | 100% probabilidad de impacto | Explosión esférica, onda de choque |
| **Iónico** | Armas de resonancia | −50% daño | +100% daño a escudos | 0.5× probabilidad, pero desactiva 3s | Rayo eléctrico, destello |
| **Resonancia** (raro) | Armas de Vacío | +100% daño | Ignora escudos | 2.0× probabilidad | Pulso lento, distorsión del espacio |
| **Cinético pesado** (torpedo) | Cañones de misiles | +50% daño | −10% daño | 1.5× probabilidad, daño masivo a componentes | Proyectil lento, gran explosión |

---

## VOLUMEN 2: TIPOS DE DAMAGE Y SU INTERACCIÓN

### 1. Daño Cinético

- **Origen**: Cañones, misiles, proyectiles
- **Mecánica**: El daño se calcula como `daño_base × (1 + distancia/100) × (blindaje / (blindaje + 100))`
- **Ejemplo**: Cañón de 100 daño, blindaje 100 → daño = 100 × (1 + 0.5) × (100 / (100 + 100)) = 75
- **Ventaja**: Efectivo contra blindaje, pero no penetra escudos

### 2. Daño de Energía

- **Origen**: Láseres, armas de plasma, rayos
- **Mecánica**: `daño_final = daño_base × (1 + distancia/10) × (1 + escudo_efectivo)`
- **Efecto especial**: Si el objetivo tiene escudo activo, el daño se multiplica por 1.3; si el escudo está en 0, el daño se multiplica por 1.3
- **Ejemplo**: Cañón de 100 daño, escudo al 50% → daño = 100 × 1.3 = 130

### 3. Daño Explosivo

- **Origen**: Misiles, torretas, bombas
- **Mecánica**: `daño = daño_base × (1 + distancia/100) × (1 + (distancia/10))`
- **Área de efecto**: 1.5× el radio del objetivo
- **Ejemplo**: Misil de 100 daño, 1 UA de distancia → 100 × (1 + 0.1) = 110 daño efectivo

### 4. Daño Iónico

- **Origen**: Armas de resonancia
- **Mecánica**: `daño = daño_base × (1 + distancia/50) × (1 + escudo_efectivo)`
- **Efecto clave**: Desactiva el componente objetivo por 3 segundos (no daña, pero paraliza)
- **Ejemplo**: Disparo de Iónico a un sistema de IA → desactiva IA durante 5s, no daña la nave

### 5. Daño de Resonancia

- **Origen**: Armas especiales de facciones específicas (Liga Rojana, Círculo Científico)
- **Mecánica**: `daño = daño_base × (1 + distancia/10) × (1 + 0.5 × (distancia / 100))`
- **Efecto**: Ignora escudos, pero solo afecta a sistemas con "resonancia" activada (modo de combate especial)

### 6. Daño Cinético Pesado

- **Origen**: Misiles de larga distancia, cañones de asalto
- **Mecánica**: `daño = daño_base × 1.5 × (1 + distancia/50)`
- **Efecto**: Daño masivo a componentes, ignora blindaje parcial

---

## VOLUMEN 3: FASES DEL COMBATE

### Fase 1: Evaluación (0-10 UA)
- El jugador evalúa el sistema mediante sensores
- Se identifican: tipos de naves, estado de blindaje, estado de escudo, rutas de escape
- Duración: 30s - 2 min
- **Requisito**: Debe tener al menos 1 arma activa y 1 módulo de navegación

### Fase 2: Decisión (5s - 30s)
- El jugador elige una acción:
  - Acción directa (disparar, mover)
  - Decisión táctica (cambiar dirección, activar escudo, usar habilidad)
  - Decisión estratégica (aceptar misión, cambiar objetivo)
- **Tiempo de decisión**: 5-30 segundos
- **Consecuencia**: La decisión afecta el estado de todos los sistemas en los siguientes 10 segundos

### Fase 3: Ejecución (3-15 minutos)
- El jugador ejecuta su decisión
- Durante esta fase, el sistema de IA del enemigo (AI_LOOP.md) procesa sus decisiones
- Eventos dinámicos pueden interrumpir (ej: un evento de EVENT_GEN_LOOP.md activa una patrulla sorpresa)

### Fase 4: Consecuencia (30s - 2 min)
- El jugador recibe consecuencias:
  - Pérdida de créditos
  - Daño a la nave (consumo de componentes)
  - Cambio de reputación con facciones
  - Eventos desencadenados (nuevas misiones, cambios en el mercado)
  - Posible muerte (si la nave es destruida)

---

## VOLUMEN 3: TIPOS DE DAÑO Y SU INTERACCIÓN

### Tabla de Daño Completa

| Tipo | Origen | Daño Base | Blindaje | Escudo | Componentes | Visual |
|------|--------|------------|----------|--------|-----------|--------|
| **Cinético** | Cañones, misiles | 50-200 | +20% | -30% | +30% componentes | Proyectiles, chispas |
| **Energía** | Láseres, plasma | 75-300 | −20% | +30% | +50% | Hazo, quemadura |
| **Explosivo** | Misiles, bombas | 100-400 | +10% | +10% | 100% | Explosión, fuego |
| **Iónico** | Armas de resonancia | 150-500 | +100% | +10% | 50% probabilidad, 3s desactivación |
| **Resonancia** | Armas de Falso (Xylo) | 500-1000 | Ignora escudos | 2.0× probabilidad | Pulso lento, distorsión |
| **Cinético pesado** | Misiles, cañones | 200-600 | −10% | −10% | 1.5× probabilidad, daño masivo a componentes | Proyectil grande, explosión |

---

## VOLUMEN 3: MANIOBRAS DE COMBATE

Cada clase de nave tiene maniobras específicas que afectan su rendimiento en combate:

### Maniobras Clave

| Maniobra | Efecto | Duración | Cooldown | Clase aplicable |
|----------|---------|-----------|------------|----------------|
| **Giro evasivo** | Reduce precisión enemiga 50% | 2s | 5s | I, II |
| **Aceleración máxima** | +100% velocidad, −20% precisión | 5s | 15s | I, II, III |
| **Frenado de combate** | −90% velocidad, 5s de inercia | 5s | 10s | II, III, IV |
| **Deslizamiento lateral** | Movimiento lateral rápido | 3s | 8s | II, III, IV |
| **Inversión de giro** | 180° giro rápido | 5s | 12s | I, II |
| **Escudo de emergencia** | Activa escudo al máximo | 5s | 15s | VI, VII, VIII |

### Maniobras Especiales por Clase

| Clase | Maniobra | Efecto | Cooldown |
|------|----------|--------|----------|
| I (Caza) | **Barril de combate** | Roda alrededor del objetivo, +80% evasión | 4s |
| II (Corbeta) | **Escudo de patrulla** | +20% defensa, −20% velocidad | 10s | II |
| III (Fragata) | **Línea de fuego** | +15% dps, −15% evasión | 15s | III |
| IV (Destructor) | **Ataque de embestida** | +40% daño, −20% evasión | 20s | IV |
| V (Crucero) | **Guerra electrónica** | Desactiva escudos enemigos 10s | 60s | V |
| VII (Portanaves) | **Lanzamiento masivo** | Lanza 10+ cazas simultáneamente | 30s | VII |
| VIII (Titán) | **Campo de batalla** | Crea zona de 500m, +30% dmg, −40% velocidad | 5 min | VIII |
| IX (Megaestructura) | **Control de sector** | Bloquea acceso a 3 sistemas, +20% dmg | 10 min | IX |

---

## VOLUMEN 4: TARGETING Y MISSILES

### Sistema de Targeting

| Modo | Alcance | Precisión | Tiempo de carga | Uso |
|------|--------|-----------|----------------|------|
| **Pasivo** | 5 UA | Baja | 0s | Siempre activo |
| **Táctico** | 2 UA | Media | 2s | Para objetivos móviles |
| **Enfoque** | 0.5 UA | Alta | 1s | Para objetivos específicos |
| **Bloqueo** | 0.1 UA | Muy alta | 0.5s | Para objetivos estáticos |

### Tipos de Misiles

| Tipo | Alcance | Daño | Tiempo de vuelo | Cooldown | Uso |
|------|---------|------|----------------|----------|-----|
| Misil estándar | 2.0 UA | 150 | 12s | 15s | Ataque a distancia media |
| Misil de largo alcance | 5.0 UA | 200 | 25s | 45s | Ataque a larga distancia |
| Misil homing | 3.0 UA | 180 | 18s | 20s | Busca objetivo automático |
| Misil homing + EMP | 2.5 UA | 250 | 20s | 35s | Desactiva sistemas durante 5s |
| Misil homing + EMP + escudo | 2.0 UA | 300 | 25s | 45s | Para sistemas blindados |

---

## VOLUMEN 6: SUBSYSTEMS Y DAÑO POR COMPONENTE

Cuando un componente recibe daño, se aplica el daño a ese sistema específico:

| Sistema | Daño afecta | Efecto inmediato | Tiempo de reparación |
|--------|-------------|-----------------|---------------------|
| Motor FTL | Componente principal | No puede saltar | 30s (si hay reparación) |
| Motor de maniobra | 1 | −50% velocidad, 3s de inercia | 5s |
| Escudo | 1 | Escudo desactivado | 5s |
| Arma | 1 | Arma inoperativa | 5s |
| Sensor | 1 | −80% rango de detección | 5s |
| Reactor | 1 | Nave se apaga en 30s | 30s (si hay energía) |
| Nave de mando | 1 | Pierde control de flotas | 5s |
| Bodega | 1 | Pierde carga (10-70% según valor) | 30s |

---

## VOLUMEN 7: COMBATE EN ESPACIO VS. ATERRAJE

### Combate en Espacio (vacío)

- **Sin gravedad**: maniobras inerciales, no hay fricción
- **Ventaja**: maniobras precisas, sin fricción
- **Desventaja**: sin gravedad, es difícil detenerse
- **Ejemplo**: Un cazador puede girar 180° en 2 segundos, pero necesita 5s para desacelerar

### Combate en Planeta

- **Gravedad**: afecta movimiento, requiere control de velocidad
- **Atmosfera**: afecta visibilidad, proyectiles se desvían
- **Terreno**: obstáculos añaden 30% de daño si colisionan

---

## VOLUMEN 8: COMBATE EN ESPACIO VS. PLANETA

| Factor | Espacio | Planeta |
|--------|---------|---------|
| **Gravedad** | 0 (flotación) | 0.5–3.0G (afecta velocidad) |
| **Atmósfera** | Ausente | Presente (afecta visibilidad, proyectiles) |
| **Terreno** | Ausente | Presente (obstáculos, cobertura) |
| **Comunicación** | Inmediata (sin latencia) | Retrasada por distancia y interferencia |
| **Visibilidad** | Clara (si no hay nebulosa) | Limitada por niebla, polvo, humo |
| **Detección** | Láseres y sensores | Radar, radar, radar |

---

## VOLUMEN 9: IA DE COMBATE

Cada facción tiene un perfil de IA para combate:

| Facción | Estilo de combate | Prioridad de objetivo | Comportamiento ante daño |
|---------|-------------------|----------------------|------------------------|
| **Hegemonía** | Ordenada, táctica disciplinada | Mayor puntuación de daño | Prioriza objetivos de alto valor |
| **Liga Rojana** | Agresiva, embestida directa | Destruir naves capital | Ataca con furia, sin táctica |
| **Sindicato** | Neutral, calculador | Maximiza ganancias | Evita combate si no hay ganancia |
| **Iglesia de la Resonancia** | Defensiva, evasiva | Protege sistemas del Anillo | Se retira si hay amenaza |
| **Colectivo de Estaciones Libres** | Anárquico, sin jerarquía | Neutral | No participa en combates |
| **Círculo Científico** | Analiza antes de actuar | Evalúa riesgos | No ataca a menos que sea amenazado |
| **Restos Xylo** | No combate activo | Solo si detecta amenaza | Ataca con métodos no convencionales |
| **Culto del Vacío** | Terrorista existencial | Destruye todo | Ataca sin discriminación |
| **Piratas** | Piratería, saqueo | Ataca para robar | Ataca sin patrón fijo |
| **Guardianes del Anillo** | Defensivo, no ofensivo | No ataca a menos que provocado | Ataca solo si hay amenaza al Anillo |

---

## VOLUMEN 9: GHOST DRIFT Y MULTIJUGADOR

### Ghost Drift Mechanics

- **Operación**: Cada jugador envía eventos de movimiento y estado cada 5 minutos
- **Privacidad**: Todos los eventos están anonimizados (HMAC-SHA256)
- **Sincronización**: Cada 60s se actualizan los estados de todas las naves
- **Privacidad**: Los jugadores no ven posiciones reales, solo resultados de eventos

### Reglas de Ghost Drift

- **Eventos de combate**: Solo se registran si ambos jugadores están en el mismo sistema
- **Recompensa**: Los jugadores que participan en eventos de combate ganan puntos de reputación
- **Privacidad**: No se sube información de posición, inventario, ni identidad del jugador
- **Cooldown**: 15 min entre envíos de eventos para evitar spam

---

## VOLUMEN 10: COMBATE EN PRÁCTICA — EJEMPLO

**Escenario**: Jugador en Corbeta (Clase II), escudo al 80%, vida al 70%, 300 créditos.

1. **Evaluación**: Detecta 3 cazas (Clase I) y 1 fragata (Clase III) a 0.8 UA. El jugador está en LOD 1 (Táctico).
2. **Decisión**: Decide usar misiles (Clase III) contra la fragata, y cañones láser contra los cazas.
3. **Ejecución**:
   - Lanza 2 misiles contra la fragata (daño 200 × 1.2 = 240)
   - Dispara 3 láseres a los cazas (daño 50 × 1.2 = 60 por láser, total 180)
   - Usa escudo de emergencia (gasta 20 MW, +20% protección por 10s)
4. **Consecuencia**:
   - Fragata: -40% vida, escudo al 40%
   - Cazas: 2 destruidas, 1 con 30% vida, 1 intacto
   - Nave propia: escudo al 60%, vida al 65%, combustible -15%
5. **Consecuencia**: La facción de la fragata pierde 5% de reputación, el jugador gana 12K créditos por la fragata.

---

## VOLUMEN 11: COMBATE EN MULTIJUGADOR

### Ghost Drift Multiplayer

- **Conexión**: Todos los jugadores usan el mismo protocolo HTTPS + MessagePack + zstd
- **Sincronización**: Cada 60s se actualizan los estados de todas las naves
- **Privacidad**: No se sube información de posición, solo eventos y resultados
- **Privacidad de HMAC**: Cada evento tiene HMAC-SHA256 para verificar autenticidad
- **Cobertura**: 10K jugadores = ~$110 USD/mes en costos operativos

### Reglas de Juego Justo

- **Sin lag artificial**: Todos los jugadores usan el mismo servidor de física
- **Sin lag de red**: La latencia se simula con buffers de 2-5 segundos
- **Equidad**: Todos los jugadores tienen acceso al mismo conjunto de armas y componentes
- **Prohibido**: Hacking, modificación de cliente, uso de macros

---

## VOLUMEN 16: RESUMEN DEL SISTEMA DE COMBATE

| Aspecto | Detalle |
|---------|---------|
| **Daño** | 6 categorías (cinético, energía, explosivo, iónico, resonancia, cinético pesado) |
| **Escudos** | 5 tipos, 5 calidades, efectos de adherencia |
| **Maniobras** | 6 maniobras básicas + 3 especiales por clase |
| **IA** | 8 perfiles de IA con comportamientos específicos |
| **Ghost Drift** | Asíncrono, stateless, HTTPS + MessagePack + zstd |
| **Escala** | 5 niveles de zoom, 60fps objetivo, miles de entidades |
| **Objetivo** | Simular combate espacial realista con emergencia narrativa |

---

*Documento completado. El sistema de combate está diseñado para ser implementado en cualquier motor 2D/3D, con soporte para múltiples plataformas.*