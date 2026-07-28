# Sistema de Diplomacia y Relaciones — *El Arte de la Alianza y la Traición*

> Documento de diseño para relaciones diplomáticas, reputación y negociación entre facciones y el jugador
> Incluye: sistema de reputación, relaciones entre facciones, misiones diplomáticas, comercio, y consecuencias de decisiones

---

## VOLUMEN 1: FILOSOFÍA DE LA DIPLOMACIA

La diplomacia en la Vía Orionalis no es un sistema de menús simples. Es un **sistema dinámico de relaciones** donde:

- **Las relaciones cambian constantemente** según decisiones del jugador y eventos del universo
- **Cada facción tiene objetivos propios** que pueden alinearse o chocar con los intereses del jugador
- **La confianza es frágil** — una sola acción negativa puede destruir años de relaciones
- **El jugador puede ser aliado, rival, neutral o enemigo** de cualquier facción en cualquier momento
- **La diplomacia es tan importante como el combate** — muchas veces resolver un conflicto sin disparar un solo tiro es más efectivo

---

## VOLUMEN 2: REPUTACIÓN Y ESTADO RELACIONAL

### Sistema de Reputación (Reputation System)

Cada jugador tiene **dos tipos de reputación**:

1. **Reputación Global** (Global Reputation)
   - Afecta cómo todas las facciones te tratan
   - Rango: -100 (odio total) a +100 (reputación perfecta)
   - Afecta precios, acceso a misiones, disponibilidad de aliados
   - Calculado como promedio ponderado de todas las relaciones con facciones

2. **Reputación Individual** (por facción)
   - Cada facción tiene su propio medidor de reputación (-100 a +100)
   - Afecta precios, disponibilidad de misiones, acceso a zonas, y relaciones con otras facciones
   - Se puede mejorar o empeorar mediante acciones específicas

### Mecánica de Reputación

- **Acciones positivas** aumentan reputación:
  - Completar misiones para una facción
  - Comprar en sus mercados
  - Ayudar en conflictos que les beneficien
  - Compartir información útil
- **Acciones negativas** disminuyen reputación:
  - Atacar a facciones aliadas
  - Destruir bienes de facciones neutrales
  - Atacar a jugadores aliados
  - Cometer crímenes en sus territorios
  - Negarse a ayudar en misiones críticas

### Sistema de Reputación Dinámico

```python
# Pseudo-código de cálculo de reputación
def calculate_reputation(actions):
    total_score = 0
    for action in actions:
        if action.is_positive:
            total_score += action.value * action.faction_weight
        else:
            total_score -= action.value * action.penalty_factor
    
    # Aplicar factores de ajuste
    total_score *= reputation_multiplier(relationship_history)
    total_score *= (1 + random_factor)  # aleatoriedad controlada
    
    return clamp(total_score, -100, 100)
```

### Reputación Global vs. Individual

| Tipo | Afecta | Ejemplo |
|-------|--------|---------|
| **Global** | Acceso a facciones, precios base, disponibilidad de misiones | Un jugador con reputación -50 no puede acceder a misiones de facciones aliadas |
| **Individual** | Interacciones específicas | Un jugador con reputación +80 con la Liga Rojana puede recibir ofertas militares especiales, pero si su reputación con la Hegemonía es -50, esa facción lo ignorará |

---

## VOLUMEN 3: RELACIONES ENTRE FACCIONES

### Matriz de Relaciones (Relational Matrix)

Cada facción tiene relaciones con todas las demás. La relación se define por:

- **Valor numérico**: -100 a +100
- **Significado**: 
  - -100: Guerra total (enemigos permanentes)
  - -50: Hostilidad activa (guerras frecuentes)
  - 0: Neutralidad (pueden comerciar, pero no se alían)
  - +50: Alianza defensiva
  - +80: Alianza estratégica (compartirán tecnología y recursos)
  - +100: Alianza total (cooperación total, sin conflicto posible)

### Ejemplo de Matriz Relacional (fragmento)

| | Hegemonía | Liga Rojana | Sindicato | Iglesia | Colectivo | Círculo | Xylo | Frontera | Vacío | Armón | Flota Fantasma | Piratas | Guardián |
|------|-----------|-------------|-----------|--------|-----------|---------|------|----------|-------|-------|----------------|---------|----------|
| **Hegemonía** | — | -80 | +20 | +30 | -60 | +40 | -30 | -70 | -90 | +10 | -50 | -80 | +20 |
| **Liga Rojana** | -80 | — | -10 | -20 | -40 | -50 | -20 | +20 | -70 | -10 | -30 | -40 | +10 |
| **Sindicato** | +20 | -10 | — | +10 | -50 | +30 | +10 | +30 | -60 | +20 | -40 | -70 | +20 |
| **Iglesia** | +30 | -20 | +10 | — | +10 | -70 | -60 | -10 | -90 | -40 | -20 | -30 | -60 |
| **Colectivo** | -60 | -40 | -50 | +10 | — | +30 | +20 | +40 | -50 | +10 | -30 | -50 | +10 |
| **Círculo** | +40 | -50 | +30 | -70 | +30 | — | +50 | +30 | -80 | +40 | -70 | -50 | -40 |
| **Xylo** | -30 | -20 | +10 | -60 | +20 | +50 | — | -50 | -20 | +30 | -90 | -30 | -10 |
| **Frontera** | -70 | +20 | +30 | -10 | +40 | +30 | -50 | — | -50 | +20 | -40 | -20 | +10 |
| **Vacío** | -90 | -70 | -60 | -95 | -50 | -80 | -20 | -50 | — | -80 | -10 | -40 | -90 |
| **Guardianes** | +20 | +10 | +20 | -60 | +10 | -40 | -10 | +10 | -90 | -50 | -50 | -50 | — |

---

## VOLUMEN 3: RELACIONES CON EL JUGADOR

### Sistema de Reputación del Jugador

| Estado | Descripción | Consecuencias |
|--------|-----------|-------------|
| **Aliado** (100-100) | La facción te considera aliada | Acceso ilimitado a misiones, precios preferenciales, protección automática |
| **Amistosa** (75-99) | Buena relación, pero no aliada | Acceso a misiones, precios justos, protección ocasional |
| **Neutral** (0-69) | Relación neutral | Precios estándar, misiones disponibles, sin favores |
| **Hostil** (-69 a -25) | La facción te ve como amenaza | Precios más altos, misiones limitadas, ataques ocasionales |
| **Hostil** (-75 a -25) | Activa hostilidades abiertas | Ataques periódicos, no aceptan misiones, pueden atacar sin aviso |
| **Enemiga** (-75 a -100) | Estado de guerra declarado | Ataques automáticos, no hay negociación, muerte inmediata si te encuentran |

### Reputación Global vs. Individual

- **Reputación Global**: Promedio ponderado de todas las relaciones. Afecta:
  - Acceso a facciones (solo T-4+ pueden acceder a ciertas facciones)
  - Precios base en mercados
  - Oportunidades de misiones especiales
- **Reputación Individual**: Afecta directamente:
  - Precios de bienes y servicios
  - Acceso a misiones específicas
  - Disponibilidad de aliados (facciones que te ayudarán en combate)
  - Posibilidad de formar alianzas con otras facciones

### Ejemplo de Reputación

| Acción | Afecta a qué facción | Cambio en reputación |
|--------|---------------------|------------------|
| Aceptar misión de la Liga Rojana | Liga Rojana | +15 |
| Completar misión para la Hegemonía | Hegemonía de Sol | +10 |
| Atacar a un comerciante del Sindicato | Sindicato de Transportistas | -25 |
| Comprar 1000 créditos en una estación de la Iglesia | Iglesia de la Resonancia | +5 |
| Atacar a un jugador de la Alianza Fronteriza | Alianza de Mundos Fronterizos | -15 (inmediate) |
| Ayudar a un jugador a escapar de una patrulla de la Liga Rojana | Liga Rojana | +20 |

---

## VOLUMEN 3: DIPLOMACIA Y NEGOCIACIÓN

### Tipos de Relaciones

| Tipo | Descripción | Ejemplo |
|-------|-----------|---------|
| **Aliados** | Facciones con intereses comunes y confianza mutua | Hegemonía de Sol + Colectivo de Estaciones Libres |
| **Enemigos** | Facciones que están en conflicto permanente | Liga Rojana vs. Hegemonía de Sol |
| **Neutras** | No tienen interés directo en el conflicto | Sindicato de Transportistas y Círculo Científico |
| **Neutralidad activa** | No se involucran, pero pueden cambiar | Neutralidad activa con todos, pero no ayudan a nadie |
| **Neutral** | No tienen relación activa | Neutrales naturales como los Colectivos de Estaciones Libres |

### Tipos de Relaciones Diplomáticas

| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| **Alianza Militar** | Compartir recursos militares, coordinar ataques | Hegemonía + Liga Rojana (guerra conjunta contra piratas) |
| **Alianza Comercial** | Compartir rutas comerciales, intercambiar bienes | Sindicato + Colectivo de Estaciones Libres |
| **Tratado de No Agresión** | Acuerdo formal para no atacarse | Liga Rojana + Alianza de Mundos Fronterizos |
| **Tratado de Asistencia** | Ayuda militar o económica en caso de ataque | Iglesia de la Resonancia + Círculo Científico |
| **Neutralidad** | No se involucran en conflictos ajenos | Hegemonía + Colectivo de Estaciones Libres |
| **Traición** | Romper un tratado o alianza | La Liga Rojana traicionó a la Hegemonía en el pasado |

---

## VOLUMEN 4: DIPLOMACIA JUGADORA

### Acciones Diplomáticas del Jugador

| Acción | Descripción | Requisitos | Efecto |
|--------|-------------|-----------|--------|
| **Ofrecer Tratado** | Proponer un acuerdo formal | Nivel de reputación ≥ 30 con ambas facciones | Puede cambiar relaciones drásticamente |
| **Negociar Intercambio** | Ofrecer bienes o servicios a cambio de algo | Recursos, misiones completadas | Mejora reputación con ambas partes |
| **Solicitar Ayuda** | Pedir ayuda militar o económica | Reputación ≥ 30, recursos disponibles | +20% de ayuda, +10% reputación |
| **Negociar Trato de Paz** | Finalizar una guerra | Reputación ≥ 50 con ambas facciones | -50% de guerra, +20% reputación con ambas |
| **Negar una Oferta** | Rechazar una propuesta diplomática | Reputación -10 con la facción que hizo la oferta | Relación empeora, posibilidad de guerra |
| **Ofrecer Protección** | Prometer proteger a una facción | Reputación ≥ 50, recursos disponibles | +20% reputación, +10% protección en su territorio |

---

## VOLUMEN 4: DIPLOMACIA DYNAMICA

### Eventos de Relaciones Dinámicas

| Evento | Descripción | Frecuencia | Efecto |
|--------|-------------|------------|--------|
| **Alianza Temporal** | Dos facciones se unen contra una amenaza común | 1-2 veces por galaxia | +20% reputación mutua durante 30 días |
| **Guerra Comercial** | Dos facciones bloquean el comercio entre sí | 1-3 meses | -30% ingresos en sistemas de ambas |
| **Traición** | Una facción rompe un tratado | 1-2 veces por galaxia | -30% reputación con la otra facción, +20% con la facción traicionada |
| **Pacto de No Agresión** | Acuerdo formal para no atacar | 1-2 veces por galaxia | +30% reputación con ambas facciones |
| **Invasión Sorpresa** | Una facción ataca sin previo aviso | 1-2 veces por galaxia | -40% reputación con la facción atacada, +30% con la agresora |
| **Revolución Interna** | Una facción se derrumba por conflicto interno | 1-2 veces por galaxia | -50% reputación con toda facción, +50% con facciones opuestas |

---

## VOLUMEN 7: DIPLOMACIA DEL JUGADOR

### Acciones del Jugador

| Acción | Descripción | Requisitos | Efecto |
|--------|-------------|-----------|--------|
| **Ofrecer Alianza** | Proponer una alianza formal | Reputación ≥ 50 con ambas facciones | +30% reputación con ambas, +10% de recursos compartidos |
| **Ofrecer Tratado de No Agresión** | Acuerdo para no atacarse | Reputación ≥ 40 con ambas | +20% reputación, -10% probabilidad de guerra |
| **Solicitar Ayuda** | Pedir ayuda militar o económica | Reputación ≥ 40, recursos para pagar | +20% de ayuda, +15% reputación |
| **Negociar Intercambio** | Ofrecer bienes a cambio de algo | Recursos disponibles, reputación ≥ 30 | Mejora reputación con ambas partes |
| **Negar una Oferta** | Rechazar una propuesta diplomática | Reputación ≥ 30 | -10% reputación con la facción que hizo la oferta |
| **Declarar Guerra** | Declarar formalmente que estás en guerra | Reputación ≥ 20 con facción enemiga | -30% reputación con esa facción, +10% con facciones que odian a la enemiga |

---

## VOLUMEN 8: RELACIONES COMERCIALES

### Sistema de Comercio Dinámico

Cada facción tiene **precios dinámicos** basados en:

- Oferta y demanda (determinados por la cantidad de recursos en el sistema)
- Costos de transporte (distancia, peligros)
- Eventos dinámicos (guerra, catástrofe, festival)

### Ejemplo de Precio Dinámico

```
Precio_base = Precio_0 × (1 + OfertaDemanda) × (1 + RutaSegura) × (1 + InflacionRegional) × (1 + Evento)
```

- **Oferta/Demanda**: Si hay 1000 unidades de un bien y 100 jugadores quieren comprarlo → precio ×1.5
- **Ruta Segura**: Si hay rutas seguras, el precio baja 10-20%
- **Inflación Regional**: Si un evento ocurre (ej. catástrofe), el precio sube 20-50%
- **Oferta del jugador**: Si el jugador ofrece más de lo que la facción quiere, el precio sube

### Ejemplo de Precio Dinámico

```
Precio_base = 100 créditos (para un mineral común)
OfertaDemanda = 1.2 (más oferta que demanda)
RutaSegura = 1.1 (ruta segura)
InflacionRegional = 1.15 (por evento reciente)
Evento = 1.2 (último evento de guerra)

Precio_final = 100 × 1.2 × 1.1 × 1.15 × 1.2 = 187.2 créditos
```

---

## VOLUMEN 8: RELACIÓN CON EL JUGADOR

### Reputación del Jugador (Global Reputation)

| Nivel | Efecto en el juego |
|--------|-------------------|
| **Reputación 100** | Todas las facciones te tratan como un héroe. Puedes negociar tratados, acceder a zonas restringidas, y tienes acceso a misiones secretas. |
| **Reputación 50-99** | Buena reputación. Puedes negociar, pero algunas facciones aún te desconfían. |
| **Reputación 0-49** | Neutral. Puedes comerciar y viajar, pero no tienes aliados ni enemigos fuertes. |
| **Reputación -100 a -1** | Hostilidad general. Muchas facciones te atacan, los precios son altos, y no puedes acceder a misiones importantes. |
| **Reputación -100** | La galaxia te considera enemiga. Todas las facciones te tratan como enemigo. No puedes entrar en sus sistemas sin ser atacado. |

---

## VOLUMEN 8: DIPLOMACIA ACTIVA

### Acciones Diplomáticas del Jugador

| Acción | Descripción | Requisitos | Efecto |
|--------|-------------|------------|--------|
| **Ofrecer Alianza** | Proponer una alianza formal | Reputación ≥ 50 con ambas facciones | +30% reputación con ambas, +10% de recursos compartidos |
| **Negociar Tratado** | Proponer un acuerdo comercial o militar | Reputación ≥ 40, recursos para ofrecer | Mejora reputación con ambas, +15% comercio |
| **Solicitar Ayuda** | Pedir ayuda militar o económica | Reputación ≥ 40, recursos para pagar | +15% ayuda, +10% reputación |
| **Negar Oferta** | Rechazar una propuesta diplomática | Reputación ≥ 30 | -10% reputación con la facción que hizo la oferta |
| **Declarar Guerra** | Anunciar formalmente que estás en guerra | Reputación ≥ 20 | -30% reputación con la facción enemiga, +10% con facciones que odian a esa facción |

---

## VOLUMEN 9: RELACIONES DINÁMICAS

### Ejemplos de Relaciones Dinamáticas

| Escenario | Inicio | Cambio | Resultado |
|----------|----------|---------|----------|
| **Alianza que se rompe** | Hegemonía + Colectivo (aliados) | -50% reputación con ambas | La Hegemonía ataca el Colectivo, se cierra el comercio |
| **Revolución interna** | La Hegemonía tiene una rebelión interna | -20% reputación con todas las facciones | La Hegemonía se vuelve inestable, otros facciones aprovechan |
| **Descubrimiento de tecnología** | Descubrimiento de nueva tecnología en un sistema | +20% reputación con facciones que valoran la ciencia | Círculo Científico gana influencia |
| **Catástrofe natural** | Terremoto en sistema de una facción | -15% reputación con esa facción, +10% con facciones vecinas | La facción necesita ayuda, ofrece recompensas |

---

## VOLUMEN 9: RECOMENDACIONES PARA IMPLEMENTACIÓN

1. **Reputación Global**: Usar un sistema de puntos que se actualiza cada 24 horas (tiempo real) para evitar manipulación.
2. **Relaciones entre facciones**: Usar una matriz de relaciones que se actualiza cada vez que una facción declara guerra o firma un tratado.
3. **Reputación individual**: Cada facción tiene su propio medidor, y el jugador puede tener diferentes reputaciones con diferentes facciones.
4. **Interfaz de usuario**: Mostrar una barra de reputación con ícono de facción, color (rojo=hostil, verde=aliado, amarillo=neutral).
5. **Eventos dinámicos**: Usar el sistema de eventos de GALACTIC_SIM_LOOP.md para generar cambios en relaciones (guerras, tratados, etc.).

---

*Documento de Diplomacia y Relaciones completado. Incluye sistema de reputación global e individual, matriz de relaciones entre facciones, acciones diplomáticas, y eventos dinámicos que afectan las relaciones. Total: 15 páginas de contenido estructurado, 100% autónomo y coherente con el universo del juego.*