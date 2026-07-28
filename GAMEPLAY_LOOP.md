# Game Loop Principal — *Vocación Sideral*

> **Documento Fundacional de Gameplay**
> Redactado bajo dirección de Trosthull (Director Creativo) y Nova-7 (Director Técnico)
> Prioridad: P1 — Crítico

---

## 1. Filosofía del Game Loop

El jugador no es un héroe. No es un elegido. No hay profecía, no hay destino.

El jugador es un ciudadano más entre 2.3 billones de almas repartidas en 32,000 sistemas. La galaxia existía antes de él y seguirá existiendo después. Las facciones guerrean, los mercados fluctúan, los misterios del Anillo Apagado permanecen mudos — todo ocurre con o sin su participación.

**La pregunta central del juego no es "¿puedes salvar la galaxia?" sino "¿qué quieres ser en ella?"**

El game loop está diseñado para que cada jugador construya su propia respuesta a través de decisiones concretas, no a través de diálogos o cinemáticas.

---

## 2. Estructura del Game Loop

Tres escalas temporales anidadas:

```
Sesión de juego (2-4h)
  └── Viaje (15-45 min)
       └── Ciclo Local (5-20 min)
            ├── Fase 1: Evaluación (30s - 2 min)
            ├── Fase 2: Decisión (5s - 30s)
            ├── Fase 3: Ejecución (3-15 min)
            └── Fase 4: Consecuencia (30s - 2 min)
```

---

## 3. El Ciclo Local (5-20 minutos)

Es el latido del juego. El jugador lo repetirá cientos de veces durante su experiencia. Cada ciclo responde a una pregunta tangible.

### Fase 1: Evaluación — "¿Qué está pasando aquí?"

El jugador llega a un sistema o despierta en una estación. Su primer movimiento es siempre leer el contexto:

**Fuentes de información disponibles:**
- **Tablero de Avisos Local**: Misiones, contratos, ofertas de trabajo. Generado por MISSION_LOOP.md. 5-10 ofertas visibles más las personales del jugador.
- **Feed de Noticias**: 3-5 eventos recientes del sistema generados por EVENT_GEN_LOOP.md. Texto breve + tag emocional (URGENTE, RUMOR, CONFIRMADO, MISTERIO).
- **Paneles de Mercado**: Precios actuales de 13 categorías de bienes. Tendencias de las últimas 24h. Ofertas del mercado negro si aplica.
- **Escáner de Sistema**: Tráfico de naves, patrullas de facción, anomalías detectadas, zonas de peligro.
- **Comms Local**: Mensajes NPC contextuales (comerciante que busca escolta, científico que ofrece paga por datos, pirata que amenaza).

**Duración**: 30s - 2 min. No hay pausa. El mundo sigue funcionando.

### Fase 2: Decisión — "¿Qué hago?"

El jugador elige una acción principal entre las opciones que el contexto le presenta. Nunca hay una opción "correcta" — solo decisiones con consecuencias.

**Categorías de decisión:**

| Tipo | Ejemplo | Tiempo típico |
|------|---------|---------------|
| **Oportunidad** | "El mercado de Iridio está alto en Auriga-7 y bajo aquí. 3 saltos de diferencia." | 5-15s |
| **Necesidad** | "Me queda combustible para 2 saltos. Necesito 500 créditos para llenar el tanque." | 5-10s |
| **Curiosidad** | "Señal desconocida en el borde del sistema. Sin clasificar." | 10-30s |
| **Peligro** | "Patrulla de la Liga Rojana en la ruta. Soy marcado en su territorio." | 5-15s |
| **Inversión** | "El astillero ofrece 30% de descuento en blindaje esta semana." | 10-30s |

El juego no presenta "misiones principales" vs "secundarias". Toda actividad es legítima y cualquier cadena de decisiones define la identidad del jugador.

### Fase 3: Ejecución — "Lo hago"

La acción concreta. El jugador ejecuta su decisión a través de los sistemas diseñados (navegación, combate, minería, comercio, etc.).

**Duración**: 3-15 min. Durante este tiempo:

- El motor de eventos (EVENT_GEN_LOOP.md) sigue generando oportunidades y peligros. La ejecución puede ser interrumpida por un evento emergente.
- Los sistemas de IA (AI_LOOP.md) procesan sus decisiones. Una patrulla puede interceptar, un pirata puede atacar, un comerciante puede huir.
- La economía (ECONOMY_LOOP.md) sigue su curso. Los precios cambian. El arbitraje NPC cierra ventanas de oportunidad.

**El mundo no espera al jugador.**

### Fase 4: Consecuencia — "¿Y ahora?"

La acción termina. El jugador obtiene resultados tangibles:

- **Ganancia/Pérdida de créditos** (±)
- **Cambio de reputación** con facciones relevantes (±)
- **Desgaste de nave** (daño, consumo de combustible, desgaste de componentes)
- **Información** (datos de escaneo, coordenadas, conocimiento de facciones)
- **Eventos desbloqueados** (una acción puede trigger una cadena de eventos futuros)

**Duración**: 30s - 2 min. El jugador procesa las consecuencias y decide si continúa en el mismo sistema o se desplaza.

---

## 4. El Viaje (15-45 minutos)

Conectar sistemas no es un loading screen. Es gameplay.

### Fase de Preparación (2-5 min)
- Trazar ruta en el mapa estelar (hasta 10 saltos)
- Verificar combustible (cada salto cuesta)
- Evaluar peligros de ruta (zonas pirateadas, sistemas en guerra, cuarentenas)
- Decidir si viajar directo o hacer escalas

### Fase de Tránsito (10-35 min)
- **Viaje sub-luz** (dentro del sistema): 1-5 min reales. El jugador puede acelerar tiempo (hasta 10×). No es AFK — pueden ocurrir encuentros aleatorios.
- **Salto FTL**: Secuencia de 30s-2 min por salto. No instantáneo. El motor se calienta, el casco vibra, el contador de distancia baja. Durante el salto: pantalla de carga dinámica con datos del sistema destino, transmisiones interceptadas, lecturas de sensores.

### Fase de Llegada (30s - 1 min)
- Salida del FTL en el punto de inserción del sistema
- Escáner pasivo: evaluar qué hay en el sistema antes de comprometerse
- Decisión: ¿proceder al puerto? ¿escanear primero? ¿cambiar de rumbo?

---

## 5. La Sesión de Juego (2-4 horas)

Una sesión típica consiste en 2-4 ciclos locales conectados por viajes.

### Flujo de Sesión Recomendado (no obligatorio)

```
Inicio de sesión
  ├── El jugador aparece en su última ubicación (estación o espacio profundo)
  ├── Resumen de eventos ocurridos durante su ausencia (3-5 líneas)
  │
  ├── [OPCIÓN A: Rutina Local]
  │   ├── Evaluar tablero y mercado (2 min)
  │   ├── Aceptar misión o ruta comercial (1 min)
  │   ├── Ejecutar: 1-3 ciclos locales en el mismo sistema (15-45 min)
  │   ├── Evaluar ganancias, reparar, reabastecer (3-5 min)
  │   └── Decidir próximo destino
  │
  ├── [OPCIÓN B: Expedición]
  │   ├── Preparar ruta de varios saltos (3-5 min)
  │   ├── Viajar: 2-5 saltos con eventos de tránsito (20-40 min)
  │   ├── Llegar a destino, evaluar nuevo contexto (2 min)
  │   └── Iniciar rutina local en el nuevo sistema
  │
  ├── [OPCIÓN C: Exploración]
  │   ├── Dirigirse a zona no cartografiada (10-20 min)
  │   ├── Escaneo profundo de sistema desconocido (10-15 min)
  │   ├── Descubrimiento: catalogar recursos, anomalías, artefactos (5 min)
  │   ├── Decisión: ¿vender datos? ¿explotar recursos? ¿investigar más?
  │   └── Regresar a espacio civilizado para reportar (10-20 min)
  │
  └── Fin de sesión
      ├── La nave queda donde está (sin "regreso a base")
      ├── El jugador puede dejar órdenes pasivas (rumbo automático, esperar en estación)
      └── Estado guardado: posición, inventario, reputación, eventos pendientes
```

---

## 6. Progresión a Largo Plazo

El jugador no sube de nivel. Su progresión es horizontal y orgánica:

### Eje Material
- **Nave mejorada**: Componentes mejores → más opciones disponibles
- **Mayor autonomía**: Más combustible, más bodega, mejor escáner
- **Flota personal**: Múltiples naves en diferentes sistemas

### Eje Relacional
- **Reputación con facciones**: Puertas que se abren (y cierran)
- **Contactos**: NPCs que aparecen con ofertas exclusivas
- **Fama**: Ser reconocido en ciertos círculos

### Eje de Conocimiento
- **Cartografía**: Mapas detallados de sistemas explorados
- **Datos técnicos**: Planos de componentes, recetas de craft
- **Lore descubierto**: Archivos, transmisiones, registros que revelan la historia profunda del universo

### Eje de Identidad
- **Profesión autodefinida**: No hay clase seleccionada al empezar. La profesión emerge de las acciones repetidas. El juego reconoce patrones y ajusta oportunidades.
- **Legado**: Acciones que cambian el estado de la galaxia. Un comerciante que abastece una facción en guerra puede inclinar el conflicto. Un explorador que descubre una ruta establece una nueva ruta comercial permanente.

---

## 7. El Primer Ciclo — Tutorial Embebido

No hay tutorial separado. El juego asume que el jugador es un adulto funcional que aprenderá haciendo.

### Estado Inicial del Jugador
- **Nave**: Clase Corbeta (la más versátil, peor en todo, buena en nada)
- **Créditos**: 1,000 — suficiente para 3-5 saltos de combustible o un cargamento pequeño
- **Deuda**: 10,000 créditos con el Sindicato de Transportistas (préstamo inicial)
- **Reputación**: Neutral con todas las facciones
- **Licencias**: Ninguna
- **Ubicación**: Estación orbital de un sistema menor en región fronteriza

### Primer Contacto — Contexto Mínimo
```
SISTEMA: Aether-3 | ESTACIÓN: Puerta Liminar
CRÉDITOS: 1,000 | DEUDA: 10,000 | COMBUSTIBLE: 3 saltos

> TABLERO DE AVISOS:
  1. Transporte médico urgento → Nueva Esperanza [800cr] [Rep+ SindTransportistas]
  2. Contrato minero menor → Cinturón de Aether [500cr + 20% vetas] [Sin licencia req]
  3. Compra de datos geológicos → Universidad de Tharsis [300cr] [Exploración]
  4. (Oferta personal) El Sindicato te recuerda tu deuda. Próximo pago: 500cr en 7 días.

> FEED LOCAL:
  · Patrulla Fronteriza reporta actividad pirata en ruta comercial A-7
  · Precio del helio-3 sube 12% en última semana
  · Estación Puerta Liminar celebra 150 años de operación continua
```

El jugador puede:
1. Aceptar un trabajo del tablero → primer ciclo guiado
2. Ignorar el tablero y volar al cinturón de asteroides a minar por su cuenta
3. Volar a otro sistema y explorar
4. Intentar piratear la primera nave que pase (y probablemente morir)

Todas las opciones son válidas. El juego no intervine ni juzga.

---

## 8. Tensión y Flow

El game loop está diseñado para un ciclo de tensión predecible:

```
Evaluación (baja tensión) → Decisión (tensión media) →
Ejecución (tensión máxima) → Consecuencia (tensión baja) →
[viaje: tensión media sostenida] → Evaluación (baja tensión)
```

Cada ciclo funciona como un "mini-arco" narrativo de ~10 minutos. La experiencia completa es una serie de estos mini-arcos, algunos conectados por decisiones previas, otros completamente independientes.

---

## 9. Ghost Drift y el Loop

La capa multijugador asíncrona (Ghost Drift) inyecta variaciones en cada ciclo sin violar la experiencia single-player:

- **Evaluación**: Los precios del mercado incluyen fluctuaciones causadas por eventos de otros jugadores en sistemas vecinos
- **Ejecución**: Puedes encontrar restos de batallas de otros jugadores (escombros, carga abandonada, señales de socorro)
- **Consecuencia**: Tu muerte en combate puede generar un "fantasma" — un registro de tu última batalla que otro jugador puede encontrar si visita el mismo sistema

---

## 10. Loop de Salida — Fin de Partida

No hay "game over" permanente. Cuando el jugador muere:

- **Pérdida de nave actual** (seguro cubre 60% del valor, el resto es pérdida)
- **Carga perdida** (todo el inventario a bordo se destruye o es saqueado)
- **Respawn** en la última estación donde pagó seguro, con una nave prestada de clase inferior
- **Deuda** si el seguro no cubrió todo

La muerte es un golpe duro pero no el fin. Como en la vida real en el espacio: sobrevives, aprendes, sigues.

El verdadero "fin de partida" ocurre cuando el jugador decide que su historia ha terminado. No hay créditos. No hay final. La galaxia sigue girando.

---

## 11. Resumen en Una Línea

> *Llegas a un sistema, ves qué está pasando, decides qué hacer, lo haces, vives con las consecuencias, y te desplazas al próximo horizonte.*

---

*Documento aprobado por Trosthull (Director Creativo) y Nova-7 (Director Técnico).*
*Próximo paso recomendado: FASE 3 — Facciones.*
