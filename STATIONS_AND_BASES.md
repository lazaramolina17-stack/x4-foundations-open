# Sistema de Estaciones y Bases — *Tu Hogar en las Estrellas*

> Diseño detallado: tipos de estación, construcción, mejora, servicios, personalización
> 6 clases de estación, 10 módulos funcionales, 5 niveles de mejora

---

## VOLUMEN 1: TIPOS DE ESTACIÓN

### Estaciones Existentes (no construibles por el jugador — puntos de servicio)

| Tipo | Tamaño | Propietario | Servicios | Dónde se encuentran |
|------|:------:|:-----------:|-----------|---------------------|
| **Puerto menor** | Pequeño (30–60 px) | Facción local | Combustible, reparación básica, mercado local | Sistemas menores |
| **Estación comercial** | Mediano (60–120 px) | Sindicato | Taller, mercado completo, banco, préstamos | Sistemas comerciales |
| **Base militar** | Mediano (80–150 px) | Facción militar | Astillero militar, cuartel, armas calidad 4 | Sistemas fronterizos |
| **Capital regional** | Grande (150–300 px) | Facción regional | Todo excepto titanes | Sistemas capital de región |
| **Capital de facción** | Gigante (300–600 px) | Facción mayor | Todo, incluyendo clase VIII | Sistema capital de facción |
| **Estación científica** | Mediano (60–120 px) | Círculo Científico | Investigación, compra datos, tecnología exótica | Sistemas de investigación |
| **Fuerte pirata** | Pequeño (40–80 px) | Piratas | Mercado negro, naves robadas, componentes sin preguntas | Zonas no cartografiadas |
| **Estación abandonada** | Variable | — | Saqueo, exploración, peligro | Sistemas olvidados |
| **Puesto de avanzada** | Muy pequeño (20–40 px) | Variable | Reabastecimiento mínimo, refugio | Sistemas fronterizos |

---

## VOLUMEN 2: ESTACIONES DEL JUGADOR

El jugador puede construir y poseer estaciones. No son naves — son instalaciones fijas en un sistema.

### Requisitos para Construir una Estación

| Requisito | Detalle |
|-----------|---------|
| Permiso de construcción | Se compra a la facción que controla el sistema |
| Coste de permiso | 50K (sistema fronterizo) a 10M (sistema capital Hegemónico) |
| Materiales | 1,000t de acero + 200t de titanio + 100t de cobre + 50t de componentes electrónicos |
| Tiempo de construcción | 24h reales (puede acelerarse con créditos) |
| Astillero | Requiere contratar un astillero de clase III+ para la construcción |

### Clases de Estación del Jugador

| Clase | Tamaño (px) | Coste construcción | Módulos | Tripulación base | Vida |
|:-----:|:-----------:|:------------------:|:-------:|:----------------:|:----:|
| I — Puesto de avanzada | 30–50 | 500K | 2 | 5 | 5,000 |
| II — Estación menor | 60–100 | 2M | 4 | 20 | 15,000 |
| III — Estación media | 120–200 | 10M | 7 | 50 | 40,000 |
| IV — Estación mayor | 250–400 | 50M | 10 | 150 | 100,000 |
| V — Fortaleza | 450–700 | 200M | 14 | 400 | 300,000 |
| VI — Colonia orbital | 800–1,500 | 1B | 20 | 2,000 | 1,000,000 |

---

## VOLUMEN 3: MÓDULOS DE ESTACIÓN

Cada estación tiene ranuras de módulo. Los módulos determinan qué puede hacer la estación.

### Módulos Funcionales

| Módulo | Ranuras | Coste construcción | Efecto |
|--------|:-------:|:------------------:|--------|
| **Atraque** | 1 | 50K | Permite que naves atraquen. Nivel 1: 2 naves simultáneas. Nivel 2: 5. Nivel 3: 15. |
| **Reabastecimiento** | 1 | 30K | Vende combustible, recarga. Genera ingresos pasivos. |
| **Taller de reparación** | 2 | 200K | Repara naves aliadas. Velocidad según nivel. |
| **Mercado** | 1 | 100K | Comercio local. Genera ingresos por impuestos. |
| **Almacén** | 1 | 50K | Almacena recursos. 1,000t por nivel. Compartido con tu bodega. |
| **Barracón** | 1 | 30K | Aloja tripulación/tropas. 10 personas por nivel. |
| **Cañón de defensa** | 1 | 100K | Defensa automática contra piratas. Daño según nivel. |
| **Escudo de estación** | 2 | 300K | Escudo planetario. Absorbe daño antes que el casco. |
| **Laboratorio** | 2 | 400K | Investigación, análisis de artefactos, mejora de componentes. |
| **Astillero ligero** | 3 | 1M | Construye/repara naves clase I–IV. Genera ingresos. |
| **Astillero pesado** | 5 | 5M | Construye/repara naves clase V–VIII. Genera ingresos mayores. |
| **Banco** | 1 | 200K | Préstamos, intereses, cambio de divisas. |
| **Granja de hidroponía** | 1 | 50K | Produce comida. Abastece a la estación, excedente se vende. |
| **Refinadora** | 2 | 500K | Procesa mineral bruto → refinado. 5t/hora por nivel. |
| **Centro de comunicaciones** | 1 | 150K | +50% alcance de comunicaciones, acceso a más misiones remotas. |
| **Cuartel de marines** | 2 | 250K | Entrena y aloja marines para abordajes y defensa. |
| **Generador de escudo planetario** | 4 | 10M | Escudo que cubre toda la estación. Regeneración 1%/hora. |
| **Superarma de estación** | 6 | 50M | Cañón de resonancia fijo. Daño 5,000. Alcance 3 UA. |
| **Módulo de sigilo** | 2 | 2M | Oculta la estación de sensores. −90% firma. |
| **Centro de datos** | 1 | 300K | Almacena información. Genera ingresos por venta de datos. |

### Niveles de Módulo

Cada módulo puede mejorarse (5 niveles):

| Nivel | Coste mejora | Multiplicador eficiencia | Requisito |
|:-----:|:-----------:|:-----------------------:|-----------|
| 1 | incluido | 1.0× | Construcción inicial |
| 2 | 50% del coste base | 1.5× | — |
| 3 | 100% del coste base | 2.5× | 1 mes de operación |
| 4 | 200% del coste base | 4.0× | 3 meses + reputación +20 con facción local |
| 5 | 500% del coste base | 6.0× | 1 año + misión especial |

---

## VOLUMEN 4: ECONOMÍA DE ESTACIONES

### Ingresos Pasivos

| Fuente de ingreso | Fórmula | Cobro |
|-------------------|---------|:-----:|
| Impuesto de atraque | 100cr × nivel_atraque × tráfico_local | Por atraque |
| Comisión de mercado | 2% de transacciones locales | Diario |
| Venta de combustible | (precio_combustible − coste) × volumen | Diario |
| Alquiler de almacén | 10cr/t/día × espacio_alquilado | Diario |
| Astillero | 5% del valor de naves construidas | Por construcción |
| Turismo (si es estación bonita) | 500cr × nivel_estación | Diario |
| Datos (centro de datos) | 1K × nivel_centro_datos | Diario |

### Costes de Operación

| Gasto | Frecuencia | Coste |
|------|:----------:|:-----:|
| Mantenimiento de estación | Diario | 1% del valor de la estación |
| Salarios de tripulación | Semanal | 100cr × tripulación |
| Energía | Diario | 10cr × MW consumidos |
| Defensa (munición) | Por combate | Variable |
| Impuesto a facción local | Mensual | 5% de ingresos del mes |

### Rentabilidad Estimada

| Clase de estación | Inversión inicial | Ingreso diario estimado | ROI |
|:-----------------:|:-----------------:|:----------------------:|:---:|
| I — Puesto avanzada | 500K | 2K–5K | 100–250 días |
| II — Estación menor | 2M | 10K–25K | 80–200 días |
| III — Estación media | 10M | 50K–150K | 66–200 días |
| IV — Estación mayor | 50M | 200K–800K | 62–250 días |
| V — Fortaleza | 200M | 1M–4M | 50–200 días |
| VI — Colonia orbital | 1B | 5M–20M | 50–200 días |

---

## VOLUMEN 5: PERSONALIZACIÓN DE ESTACIÓN

### Estética

| Elemento | Coste | Efecto |
|----------|:-----:|--------|
| Esquema de color | 10K–100K | Identidad visual |
| Iluminación exterior | 25K–500K | +1 nivel de turismo |
| Bandera/insignia | 5K | Identificación de facción |
| Anuncios luminosos | 50K | +5% ingresos mercado |
| Jardines orbitales | 200K | +2 niveles de turismo |
| Arquitectura personalizada | 500K–10M | Diseño único |

### Nombre de Estación

El jugador nombra su estación. El nombre aparece en el mapa galáctico de todos los jugadores (via Ghost Drift).

---

## VOLUMEN 6: DEFENSA DE ESTACIÓN

### Amenazas a Estaciones

| Amenaza | Frecuencia | Daño potencial | Defensa recomendada |
|---------|:---------:|:--------------:|---------------------|
| Piratas menores | Cada 1–3 meses | Daño leve (10–20%) | 1 cañón de defensa |
| Piratas mayores | Cada 6–12 meses | Daño medio (30–50%) | 2 cañones + escudo |
| Patrulla hostil | Variable | Confiscación, multa | Permiso de facción |
| Flota de facción | Raro | Destrucción total | Diplomacia o módulo de sigilo |
| Enjambre Mórr | Muy raro | Devastación total | Escudo planetario + superarma |

### Sistema de Defensa Automática

Cuando la estación es atacada mientras el jugador no está en el sistema:

1. La IA de defensa se activa (basada en módulos instalados)
2. Resultado calculado en simulación galáctica (GALACTIC_SIM_LOOP.md)
3. El jugador recibe notificación al reconectar:
   - "Tu estación fue atacada por piratas. Defensa exitosa. Bajas: 2 tripulantes."
   - "Tu estación fue atacada por piratas. Defensa fallida. Pérdida: 40% de ingresos de esta semana, módulo de mercado destruido."

---

## VOLUMEN 7: DESTRUCCIÓN Y ABANDONO

| Evento | Consecuencia |
|--------|-------------|
| **Estación destruida** | Pierdes toda la inversión. Cápsula de salvamento con tripulación (si hay) aparece en estación amiga más cercana. |
| **Abandono voluntario** | La estación queda inactiva. Puedes retomarla después (pagando mantenimiento atrasado). |
| **Embargo de facción** | La facción confisca la estación si no pagas impuestos. Puedes recuperarla pagando +50% de multa. |
| **Venta de estación** | Recuperas 40% del valor invertido. La facción local compra o un NPC inversor. |

---

*Sistema de Estaciones y Bases completo: 7 volúmenes, 9 tipos de estación existente, 6 clases construibles, 20 módulos funcionales con 5 niveles de mejora, economía detallada con tabla de ROI, defensa automatizada, y reglas de destrucción/abandono.*
