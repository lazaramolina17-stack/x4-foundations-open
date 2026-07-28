# Sistema de Generación Procedural de Planetas — *El Taller de Mundos*

> Especificación del generador pseudoaleatorio por semilla
> Capaz de producir ~10^18 planetas únicos (más que estrellas en la galaxia)
> Cada planeta: semilla 64-bit → salida determinista con 13 capas de generación

---

## VOLUMEN 1: ARQUITECTURA DEL GENERADOR

### Pipeline de Generación (13 Capas)

```
SEMILLA MAESTRA (64 bits)
  ├── Capa 1: Sistema Estelar    (determina: estrella, nº planetas, zona habitable)
  │     └── Semilla por planeta = MASTER ^ planet_index * HASH_CONSTANT
  │
  ├── Capa 2: Planeta            (tipo, masa, gravedad, composición, órbita)
  ├── Capa 3: Geografía          (mapa de tiles, continentes, océanos, montañas)
  ├── Capa 4: Clima              (temperatura, presión, estaciones, tormentas)
  ├── Capa 5: Atmósfera          (composición, toxicidad, color del cielo)
  ├── Capa 6: Ecosistema         (flora, fauna, cadena trófica, peligros)
  ├── Capa 7: Recursos           (minerales, raros, combustibles, distribución)
  ├── Capa 8: Civilización       (presente/pasada, nivel, ciudades, ruinas)
  ├── Capa 9: Historia           (eventos pasados, guerras, cataclismos)
  ├── Capa 10: Colonización      (dificultad, coste, requisitos)
  ├── Capa 11: Eventos Activos   (tormentas, plagas, migraciones actuales)
  ├── Capa 12: Marcadores        (puntos de interés, dungeons, secretos)
  └── Capa 13: Tags              (etiquetas semánticas para búsqueda y simulación)
```

### Principio de Derivación de Semillas

```
semilla_sistema = SEED_MAESTRA
semilla_planeta[i] = hash(semilla_sistema ++ i ++ CONSTANTE_PLANETA)
semilla_geografia = hash(semilla_planeta ++ 0xGEO)
semilla_clima    = hash(semilla_planeta ++ 0xCLIM)
...

hash(entrada) = SHA-256(entrada) truncado a 64 bits
```

Esto garantiza:
- Misma semilla → mismo planeta exacto (determinismo)
- Cambiar 1 bit en la semilla → planeta radicalmente diferente
- Datos generables bajo demanda (sin almacenar planetas completos)
- Coste de generación: <1ms por capa en CPU moderna

### Formato de Almacenamiento

Cada planeta se representa como estructura compacta en runtime:

```
Planet {
    seed: u64,
    system_id: u32,
    orbit_index: u8,
    type: PlanetType,
    // Capas lazy — se generan bajo demanda
    layers: [Option<LayerSnapshot>; 13],
    // Tags calculados para simulación (ver Capa 13)
    tags: BitSet<256>,
}
```

Las capas se generan en el momento de primer acceso y se cachean en RAM. Nunca se almacenan en disco — solo la semilla y los tags se persisten en la base de datos galáctica.

---

## VOLUMEN 2: CAPA 1 — SISTEMA ESTELAR

### Tipos de Estrella

| Tipo | Masa (Sol=1) | Vida (años) | Zona habitable | Color | Frecuencia |
|:----:|:-----------:|:-----------:|:--------------:|:-----:|:----------:|
| Enana roja M | 0.08–0.45 | 10^12–10^13 | 0.1–0.5 UA | Rojo oscuro | 40% |
| Enana naranja K | 0.45–0.8 | 2×10^10–5×10^10 | 0.3–0.8 UA | Naranja | 15% |
| Enana amarilla G | 0.8–1.2 | 8×10^9–2×10^10 | 0.7–1.5 UA | Blanco-amarillo | 10% |
| Subgigante F | 1.2–1.6 | 2×10^9–8×10^9 | 1.2–2.5 UA | Blanco | 5% |
| Gigante azul B | 2–16 | 10^7–10^8 | 5–50 UA | Azul | 0.5% |
| Gigante azul O | 16–100 | 10^6–10^7 | 10–200 UA | Azul intenso | 0.01% |
| Gigante roja | 0.5–10 | ~10^8 | variable | Rojo-anaranjado | 1% |
| Enana blanca | 0.5–1.4 | ∞ (enfriándose) | ninguna (antes sí) | Blanco puro | 5% |
| Binaria | suma | menor de las dos | complejo | variable | 15% |
| Múltiple (3+) | suma | menor de las tres | complejo | variable | 5% |
| Estrella de neutrones | 1.4–3 | ~10^9 | ninguna | Invisible (púlsar) | 0.1% |
| Variable | depende | depende | inestable | variable | 3% |

### Parámetros Generados por Sistema

```rust
struct StarSystem {
    seed: u64,
    name: String,
    star_type: StarType,
    star_mass: f32,        // masas solares
    star_age: f64,         // años
    star_temperature: f32, // Kelvin
    star_luminosity: f32,  // luminosidades solares
    star_radiation: f32,   // Sv/h en zona habitable
    habitable_zone_inner: f32, // UA
    habitable_zone_outer: f32, // UA
    planet_count: u8,      // 0–15
    asteroid_belts: u8,    // 0–3
    special_phenomena: Vec<Phenomenon>, // nebulosas, agujeros, etc.
}
```

### Fenómenos Especiales del Sistema

| Fenómeno | Efecto en gameplay |
|----------|-------------------|
| Nebulosa cercana | -20% sensores, +30% riesgo de avería |
| Agujero negro | +50% velocidad FTL cerca, peligro de gravedad |
| Púlsar | Radiación pulsante, daño periódico a naves sin blindaje |
| Campo de escombros | +40% riesgo de colisión, valiosos restos |
| Anomalía de Vacío | Eventos extraños, posible contacto con Caminantes |
| Viento estelar extremo | +20% consumo combustible para mantener órbita |
| Cinturón de asteroides denso | Minería rica, navegación peligrosa |
| Luna habitable | Posible colonia alternativa |
| Planeta trotiano | Dos planetas compartiendo órbita |

---

## VOLUMEN 3: CAPA 2 — CREACIÓN DEL PLANETA

### 20 Tipos de Planeta con Reglas de Generación

| # | Tipo | Frecuencia | Atmósfera | Vida posible | Gravedad (G) |
|:-:|------|:----------:|:---------:|:------------:|:------------:|
| 1 | Terrestre (templado) | 8% | Respirable | Alta | 0.5–2.0 |
| 2 | Terrestre (seco) | 10% | Respirable | Media | 0.5–2.0 |
| 3 | Oceánico | 6% | Respirable/húmeda | Alta | 0.4–1.8 |
| 4 | Desértico | 12% | Fina/tóxica | Baja | 0.3–1.5 |
| 5 | Helado | 15% | Congelada | Muy baja | 0.3–2.5 |
| 6 | Volcánico | 7% | Tóxica/densa | Extremófila | 0.6–3.0 |
| 7 | Gaseoso (gigante) | 12% | Profunda (sin suelo) | No aplica | 1.5–8.0 |
| 8 | Gaseoso (enano) | 8% | Profunda (sin suelo) | No aplica | 0.5–2.0 |
| 9 | Tóxico | 9% | Irrespirable | Ninguna | 0.4–2.0 |
| 10 | Pantano | 4% | Respirable/húmeda | Alta | 0.6–1.8 |
| 11 | Selvático | 5% | Respirable/densa | Muy alta | 0.6–2.0 |
| 12 | Cristalino | 1% | Variable | Ninguna/Extremófila | 0.3–1.2 |
| 13 | Cavernario | 2% | Variable (interior) | Media | 0.4–1.5 |
| 14 | Artificial (estación) | 0.1% | Controlada | Según diseño | 0.0–1.0 |
| 15 | Destruido (restos) | 3% | Ninguna | Ninguna | 0.0–0.5 |
| 16 | Extremo (personalizado) | 0.5% | Variable | Variable | Variable |
| 17 | Lava | 2% | Tóxica/extrema | Ninguna | 0.8–3.5 |
| 18 | Roca estéril | 8% | Ninguna | Ninguna | 0.1–1.0 |
| 19 | Anillo (habitable en anillos) | 0.5% | Variable | Media | 0.2–0.8 |
| 20 | Mundo Jardín (raro) | 0.01% | Perfecta | Muy alta | 0.8–1.2 |

### Ecuaciones Físicas del Generador

```rust
fn generate_planet(seed: u64, star: &StarSystem, orbit_index: u8) -> Planet {
    let rng = Rng::from_seed(seed);
    let type = roll_planet_type(rng, star, orbit_index);
    let orbital_distance = compute_orbital_distance(star, orbit_index); // UA
    let base_temp = compute_base_temperature(star, orbital_distance);
    let mass = roll_mass(rng, type); // masas terrestres
    let radius = roll_radius(type, mass);
    let gravity = G * mass / radius^2; // gravedad superficial
    let density = mass / (4/3 * PI * radius^3);
    let rotation = roll_rotation(rng); // horas por día
    let axial_tilt = roll_tilt(rng); // grados
    let magnetic_field = compute_magnetic_field(mass, rotation, core_composition);
    let atmosphere = generate_atmosphere(seed, type, mass, base_temp);
    let age = star.star_age - rng.range(0, star.star_age * 0.3); // planeta más joven que su estrella
    // ...
}
```

### Reglas de Consistencia Física

| Regla | Descripción |
|-------|-------------|
| Distancia orbital | Planetas rocosos más cerca de la estrella, gaseosos más lejos |
| Zona habitable | Planetas con vida están dentro de zona habitable (excepción: extremófilos) |
| Tamaño vs tipo | Gaseosos > 2 radios terrestres; rocosos < 2.5 radios terrestres |
| Edad del sistema | Sistemas jóvenes (<1G años) no tienen vida compleja |
| Rotación | Planetas muy cerca de estrella gigante: rotación sincrónica (misma cara siempre) |
| Campo magnético | Requiere núcleo líquido + rotación. Sin campo: atmósfera arrasada por viento estelar |

---

## VOLUMEN 4: CAPA 3 — GEOGRAFÍA

### Motor de Mapas por Ruido de Perlin/Simplex Multiresolución

```rust
struct Geography {
    resolution: u16,     // tiles por lado del mapa (64–4096 según LOD)
    map: Vec<Tile>,      // tilemap generado lazy
    continents: Vec<Continent>,
    oceans: Vec<Ocean>,
    elevation_map: NoiseMap, // 3 octavas de ruido
    moisture_map: NoiseMap,
    temperature_map: NoiseMap, // corregida por latitud y altitud
}
```

### Sistema de Elevación (6 Octavas)

| Octava | Frecuencia | Amplitud | Rol |
|:------:|:----------:|:--------:|-----|
| 1 | 1/32 | 1.0 | Continentes |
| 2 | 1/16 | 0.5 | Cadenas montañosas |
| 3 | 1/8 | 0.25 | Valles y colinas |
| 4 | 1/4 | 0.125 | Ríos y lagos |
| 5 | 1/2 | 0.0625 | Rugosidad local |
| 6 | 1 | 0.03125 | Detalle de costa |

### Biomas Derivados (Elevación + Humedad + Temperatura)

```rust
fn biome_at(elevation, moisture, temperature) -> Biome {
    if elevation < 0.0 { return Ocean; }
    if elevation < 0.1 && temperature > 10.0 { return Beach; }
    if elevation > 0.8 { return Mountain; }
    // Mapa 2D de biomas:
    match (moisture, temperature) {
        (dry, hot) -> Desert
        (dry, cold) -> Tundra
        (moist, hot) -> Jungle
        (moist, temperate) -> Forest
        (wet, hot) -> Swamp
        (wet, cold) -> Taiga
        (avg, avg) -> Grassland
        // etc.
    }
}
```

### Características Geográficas Especiales

| Característica | Probabilidad | Tamaño |
|----------------|:----------:|:------:|
| Volcán activo | 5% por planeta | 1–3 tiles |
| Cañón profundo | 8% por planeta | línea de 5–20 tiles |
| Cráter de impacto | 12% por planeta | 1–5 tiles radio |
| Lago de lava | 2% por planeta | 1–4 tiles |
| Mar interior | 15% por planeta | 5–20 tiles |
| Arrecife de coral | 6% por planeta (oceánicos) | 2–10 tiles |
| Glaciar | 10% por planeta (fríos) | 10–50 tiles |
| Desierto de cristal | 1% por planeta | 5–15 tiles |
| Formación alienígena | 0.5% por planeta | 1–3 tiles |

---

## VOLUMEN 5: CAPA 4 — CLIMA

### Modelo Climático Simplificado

```rust
struct Climate {
    base_temperature: f32,    // °C en ecuador
    axial_tilt: f32,          // grados (determina estaciones)
    orbital_period: f64,      // días locales por año
    day_length: f32,          // horas por día
    atmospheric_pressure: f32, // atmósferas
    humidity: f32,            // 0.0–1.0
    wind_speed: f32,          // m/s promedio
    wind_pattern: WindPattern, // global/corriente en chorro/celular
    storm_frequency: f32,     // tormentas/año
    storm_severity: f32,      // 0.0–1.0
    seasons: Vec<Season>,
}

struct Season {
    name: String,
    duration_days: f32,
    temp_offset: f32,  // °C de diferencia respecto a base
    precipitation: f32, // mm/día
    hazards: Vec<Hazard>,
}
```

### Fenómenos Climáticos Extremos

| Fenómeno | Condiciones | Efecto en gameplay |
|----------|-------------|-------------------|
| Superhuracán | Atmósfera densa + océanos cálidos | -90% visibilidad, daño a naves en superficie |
| Lluvia ácida | Atmósfera con sulfuros + agua | -5% integridad de casco por hora (sin protección) |
| Tormenta eléctrica masiva | Atmósfera ionizada + fricción | Sistemas electrónicos apagados 30s, posible reinicio |
| Tormenta de polvo global | Desértico, vientos fuertes | -99% visibilidad, sensores ciegos |
| Noche perpetua | Rotación sincrónica | Un lado siempre oscuro (-100°C), otro siempre luz (+100°C) |
| Invierno volcánico | Erupción masiva reciente | -20°C global, oscuridad, cosechas destruidas |
| Calentamiento extremo | Atmósfera desbocada (efecto invernadero) | +30°C, océanos evaporándose |

---

## VOLUMEN 6: CAPA 5 — ATMÓSFERA

### Composición Química Generada

```rust
struct Atmosphere {
    pressure: f32,           // atm
    composition: Vec<Gas>,
    toxicity: ToxicityLevel, // None, Low, Medium, High, Lethal
    color: Rgb,              // color del cielo
    visual_effects: Vec<Effect>, // neblina, auroras, arcoíris dobles, etc.
    breathable: bool,        // para humanos sin equipo
    corrosive: bool,         // daña naves sin protección
    greenhouse_effect: f32,  // % de aumento térmico por gases
}
```

### Tabla de Gases y Efectos

| Gas | Fórmula | Efecto en humanos | Efecto en naves | Color del cielo si predomina |
|:---:|:-------:|:-----------------:|:---------------:|:---------------------------:|
| Nitrógeno | N2 | Inerte | Inerte | Azul |
| Oxígeno | O2 | Vital | Corrosivo (oxida) | Azul claro |
| CO2 | CO2 | Tóxico (>5%) | Inerte | Naranja tenue |
| Metano | CH4 | Inerte (asfixia sin O2) | Inerte | Azul verdoso |
| Amoniaco | NH3 | Tóxico | Corrosivo | Amarillo |
| Sulfuro de H | H2S | Letal (>0.1%) | Corrosivo | Verde pálido |
| Cloro | Cl2 | Letal | Muy corrosivo | Verde amarillento |
| Argón | Ar | Inerte (asfixia sin O2) | Inerte | Azul violáceo |
| Helio | He | Inerte (voz aguda) | Inerte | Rosa pálido |
| Xenón | Xe | Narcótico (alta presión) | Inerte | Azul profundo |

### Color del Cielo por Composición

| Composición dominante | Color de día | Color de atardecer |
|-----------------------|:------------:|:------------------:|
| N2/O2 (como Tierra) | Azul | Naranja/rojo |
| CO2 denso | Naranja | Rojo intenso |
| Metano | Azul verdoso | Verde |
| Partículas finas en suspensión | Blanco lechoso | Rojo sangre |
| Amoniaco | Amarillo | Naranja |
| Cloro | Verde amarillento | Verde |
| Atmósfera muy fina | Negro (cielo negro, estrella visible) | Negro |
| Sin atmósfera | Negro absoluto | Negro absoluto |

---

## VOLUMEN 7: CAPA 6 — ECOSISTEMA

### Cadena Trófica Procedural

```rust
struct Ecosystem {
    energy_source: EnergySource, // solar, quimiosintética, térmica
    producers: Vec<Species>,
    consumers: Vec<Species>,
    predators: Vec<Species>,
    apex_predators: Vec<Species>,
    decomposers: Vec<Species>,
    diversity: f32,           // 0.0–1.0
    danger_level: f32,        // 0.0–1.0
    bioluminescence: bool,
    sentient_species: Option<Vec<Species>>,
}
```

### Generador de Especies (Flora)

| Parámetro | Rango | Descripción |
|-----------|:-----:|-------------|
| Altura | 0.1–100m | Tamaño de la planta |
| Color | paleta | Fotosíntesis o quimiosíntesis |
| Toxicidad | 0.0–1.0 | Peligro al consumir/tocar |
| Recurso | tipo | Lo que se obtiene al cosechar |
| Rareza | 0.0–1.0 | Probabilidad de encontrar |
| Adaptación | bioma | Especialización climática |

### Generador de Especies (Fauna)

| Parámetro | Rango | Descripción |
|-----------|:-----:|-------------|
| Tamaño | 0.01–100m | Masa corporal |
| Dieta | herbívoro/carnívoro/omívoro/filtrador | Posición en cadena |
| Agresividad | 0.0–1.0 | Probabilidad de ataque |
| Velocidad | 0.0–1.0 | Comparado con humano |
| Peligro | 0.0–1.0 | Daño potencial |
| Sociabilidad | solitario/pareja/manada/colmena | Comportamiento de grupo |
| Recurso | tipo | Lo que se obtiene al cazar |

### Reglas de Consistencia del Ecosistema

| Regla | Descripción |
|-------|-------------|
| Energía solar | Plantas fotosintéticas requieren luz → no existen en planetas sin atmósfera |
| Quimiosíntesis | Posible en planetas sin luz (respiraderos, interior) |
| Pirámide trófica | 10% de biomasa pasa al siguiente nivel. Depredadores cima son raros |
| Colonización reciente | Ecosistemas en mundos colonizados tienen especies introducidas |
| Extremófilos | Posibles en ambientes hostiles (alta radiación, presión, temperatura) |
| Vida inteligente | Rarísima (<0.01% de planetas con vida) |

---

## VOLUMEN 8: CAPA 7 — RECURSOS

### Taxonomía de Recursos

```rust
enum ResourceCategory {
    Mineral,          // hierro, cobre, titanio, uranio...
    RareMineral,      // adamantita, vibranio, cristal de resonancia...
    Gas,              // helio-3, hidrógeno, oxígeno licuado...
    Biological,       // madera, seda, veneno, comida...
    Fuel,             // isótopos, antimateria, plasma...
    Data,             // archivos, mapas, códigos...
    Artifact,         // tecnología ancestral, objetos de valor...
    Luxury,           // gemas, especias, obras de arte...
}
```

### Distribución de Recursos por Tipo de Planeta

| Tipo de planeta | Minerales comunes | Minerales raros | Recursos biológicos |
|-----------------|:-----------------:|:---------------:|:-------------------:|
| Terrestre | Hierro, cobre, carbón | Oro, platino, uranio | Madera, alimentos, fibras |
| Oceánico | Níquel, cobalto, manganeso | Perlas, coral raro | Algas, pesca, esponjas |
| Desértico | Silicio, sal, hierro | Cristales, gemas, petróleo | Cactus, xerófitas |
| Helado | Hielo de agua, metano | Deuterio, helio-3 | Microorganismos criófilos |
| Volcánico | Azufre, hierro, magnesio | Diamantes, elementos pesados | Termófilos |
| Gaseoso | Hidrógeno, helio | Helio-3, deuterio, antimateria | Criaturas de gas |
| Selvático | Bauxita, estaño | Plantas medicinales | Biodiversidad extrema |
| Cristalino | Silicio, cuarzo | Cristales de resonancia | Ninguno |

### Rareza de Recursos

| Rareza | Veces en galaxia | Valor en mercado |
|:------:|:----------------:|:----------------:|
| Común | en >30% de planetas | 1× base |
| Poco común | en 10–30% | 2–5× base |
| Raro | en 1–10% | 10–50× base |
| Exótico | en 0.1–1% | 100–500× base |
| Legendario | en <0.01% | 1,000–10,000× base |
| Único | 1 en la galaxia | Sin precio (no mercado) |

---

## VOLUMEN 9: CAPA 8 — CIVILIZACIÓN

### Niveles de Presencia Civilizada

| Nivel | Población | Infraestructura | Efecto en planeta |
|:-----:|:---------:|:---------------:|-------------------|
| 0 — Ninguna | 0 | Nada | Planeta virgen |
| 1 — Ruinas | 0 (pasado) | Restos | Artefactos recuperables |
| 2 — Puesto | <1,000 | 1–5 edificios | Punto de interés menor |
| 3 — Colonia | 1K–1M | Asentamiento | Extracción de recursos local |
| 4 — Ciudad | 1M–100M | Zona urbana | Contaminación local, defensas |
| 5 — Civilización | 100M–10B | Global | Contaminación global, malla orbital |
| 6 — Imperio | 10B+ | Multi-sistema | Planeta capital, astilleros masivos |
| 7 — Artificial | segun diseño | Estación/mundo artificial | Construido, no natural |

### Fracciones de Control por Facción

Cada planeta civilizado tiene un mapa de control:

```rust
struct PlanetControl {
    faction_presence: Vec<(FactionId, f32)>, // facción + % de control
    government_type: GovernmentType,
    stability: f32,          // 0.0 (guerra civil) a 1.0 (paz total)
    tax_rate: f32,           // % de ingresos recaudado
    population_happiness: f32,
}
```

---

## VOLUMEN 10: CAPA 9 — HISTORIA

### Generador de Historia (Plantillas + Variables)

El generador selecciona 1–4 eventos históricos que moldearon el planeta:

```rust
enum HistoricalEvent {
    Colonization { years_ago: f64, faction: FactionId },
    War { years_ago: f64, attacker: FactionId, defender: FactionId, outcome: WarOutcome },
    Cataclysm { years_ago: f64, type: CataclysmType, survivors: f32 },
    Discovery { years_ago: f64, discovery_type: DiscoveryType, significance: f32 },
    Extinction { years_ago: f64, cause: ExtinctionCause, species_lost: u32 },
    FirstContact { years_ago: f64, species: RaceId, peaceful: bool },
    Abandonment { years_ago: f64, reason: AbandonReason },
    Uprising { years_ago: f64, cause: String, success: bool },
    Plague { years_ago: f64, mortality: f32, contained: bool },
    Construction { years_ago: f64, structure_type: String, builder: FactionId },
}
```

### Efectos de la Historia en el Presente

| Evento histórico | Efecto actual |
|------------------|---------------|
| Guerra nuclear | Radiación persistente, ruinas, recursos escasos |
| Extinción masiva | Biodiversidad baja, especies resistentes dominan |
| Cataclismo volcánico | Suelo fértil, atmósfera cargada, actividad sísmica |
| Colonización antigua | Ruinas, tecnología enterrada, población mixta |
| Plaga reciente | Población diezmada, cuarentena, medicina escasa |
| Descubrimiento científico | Base de investigación, laboratorios, recursos exportados |

---

## VOLUMEN 11: CAPA 10 — COLONIZACIÓN

### Ecuación de Dificultad de Colonización

```
Dificultad = (1.0 + GravedadDelta * 0.3) 
           * (1.0 + TempDelta / 100) 
           * (1.0 + PresionDelta * 0.5)
           * (1.0 + PeligroBiologico)
           * (1.0 - RecursosValiosos * 0.2)
           * (1.0 + DistanciaCivilizacion * 0.01)
           * (1.0 + ToxicidadAtmosferica)
```

Donde cada término es una penalización o bonificación.

### Coste y Tiempo de Colonización

| Dificultad | Coste (créditos) | Tiempo (días) | Tecnología requerida |
|:----------:|:----------------:|:-------------:|---------------------|
| <2.0 (Fácil) | 50K–200K | 30–90 | Ninguna especial |
| 2.0–4.0 (Media) | 200K–1M | 90–365 | Generador atmosférico |
| 4.0–8.0 (Difícil) | 1M–10M | 1–5 años | Escudo ambiental + terraformador |
| 8.0–15.0 (Extrema) | 10M–100M | 5–20 años | Terraformador completo + cúpulas |
| >15.0 (Imposible) | No colonizable | — | Requiere modificación genética o robótica |

---

## VOLUMEN 12: CAPA 11 — EVENTOS ACTIVOS

### Eventos Dinámicos por Planeta (conectados a EVENT_GEN_LOOP.md)

```rust
enum ActiveEvent {
    SolarFlare { intensity: f32, eta_hours: f32 },
    Storm { type: StormType, duration_hours: f32 },
    PlagueOutbreak { species_affected: SpeciesId, mortality: f32 },
    Migration { species: SpeciesId, direction: Direction, size: u64 },
    VolcanicEruption { volcano_id: TileId, severity: f32 },
    ResourceBoom { resource: ResourceId, multiplier: f32 },
    PirateRaid { faction: FactionId, ships: u32 },
    Discovery { discovery: DiscoveryType, claimed_by: Option<FactionId> },
    PoliticalChange { old_gov: GovernmentType, new_gov: GovernmentType },
    AlienArrival { race: RaceId, ships: u32, intent: Intent },
}
```

---

## VOLUMEN 13: CAPA 12 — MARCADORES

### Puntos de Interés Generados

```rust
enum PointOfInterest {
    Natural { kind: NaturalPOI, danger: f32, reward: f32 },
    Ruin { age: f64, builder: Option<RaceId>, contents: Vec<Loot> },
    Base { faction: FactionId, type: BaseType, defenses: f32 },
    Anomaly { type: AnomalyType, effects: Vec<Effect> },
    ResourceDeposit { resource: ResourceId, quantity: f64, quality: f32 },
    CrashSite { ship_class: ShipClass, age: f64, survivors: bool },
    TradingPost { faction: FactionId, inventory: Vec<Item> },
    HiddenStash { owner: Option<FactionId>, contents: Vec<Loot> },
    Dungeon { difficulty: f32, rewards: Vec<Loot>, enemies: Vec<Enemy> },
}
```

---

## VOLUMEN 14: CAPA 13 — TAGS

### Sistema de Etiquetas para Búsqueda y Simulación

Cada planeta genera un conjunto de tags que la simulación galáctica (GALACTIC_SIM_LOOP.md) usa para computar eventos, economía, y comportamiento de facciones:

```rust
// Tags de ejemplo (256 bits, uno por bit):
// 0-31: Tipo de planeta
const TAG_TERRESTRE: u16 = 0;
const TAG_OCEANICO: u16 = 1;
const TAG_DESERTICO: u16 = 2;
// ...etc
const TAG_HABITABLE: u16 = 30;
const TAG_MINABLE: u16 = 31;

// 32-63: Recursos
const TAG_HIERRO_RICO: u16 = 32;
const TAG_HELIO3: u16 = 33;
// ...

// 64-95: Civilización
const TAG_COLONIZADO: u16 = 64;
const TAG_FRONTERIZO: u16 = 65;
const TAG_CAPITAL: u16 = 66;
// ...

// 96-127: Peligros
const TAG_PELIGRO_ALTO: u16 = 96;
const TAG_RADIACTIVO: u16 = 97;
const TAG_ENFERMEDAD: u16 = 98;
// ...

// 128-159: Historia
const TAG_RUINAS_XYLO: u16 = 128;
const TAG_GUERRA_PASADA: u16 = 129;
// ...
```

---

## VOLUMEN 15: GENERADOR DE NOMBRES

Cada sistema y planeta recibe un nombre generado proceduralmente de uno de estos orígenes:

| Estilo | Ejemplos | Frecuencia |
|--------|----------|:----------:|
| Latín/científico | Aether-3, Ignis Prime, Aquila-7 | 25% |
| Númerico/catálogo | GX-447, M-8932, XR-112 | 20% |
| Poético/mitológico | Susurro de Eos, Jardín de Sombra | 15% |
| Nombrado por facción | Nueva Esperanza (Heg), Martillo de Roj (Liga) | 15% |
| Nombrado por descubridor | Puerto Kane, Estación Voss | 10% |
| En lengua alienígena | Q'loth-7, Ssathiss-3, Mórr-Prime | 10% |
| Legendario/misterioso | El Último Faro, Silencio, Donde Nadie Mira | 5% |

### Algoritmo de Nombres

```rust
fn generate_name(seed: u64, context: &NameContext) -> String {
    let rng = Rng::from_seed(seed);
    match rng.weighted_choice(&STYLES) {
        LatinScientific => format!("{}-{}", latin_prefix(rng), rng.range(1, 999)),
        Catalog => format!("{}-{}", catalog_prefix(rng), rng.range(100, 99999)),
        Poetic => format!("{} de {}", poetic_noun(rng), poetic_place(rng)),
        // ...
    }
}
```

---

## VOLUMEN 16: DEMOSTRACIÓN — GENERACIÓN COMPLETA DE UN SISTEMA

### Sistema: Aether-7 (semilla: 0x4A1B2C3D)

```
SEMILLA: 0x4A1B2C3D
SISTEMA: Aether-7
ESTRELLA: Enana naranja K3V | Masa: 0.72Sol | Edad: 6.2G años | Temp: 4,800K
Zona habitable: 0.35–0.75 UA
Planetas: 7
  ├── Aether-7a (0.12 UA) | Roca estéril | 0.3G | Sin atmósfera | Temp: 320°C
  ├── Aether-7b (0.28 UA) | Desértico | 0.7G | CO2 fino, tóxico | Temp: 85°C | Recurso: Cristales de silicio (raro)
  ├── Aether-7c (0.45 UA) | Terrestre templado | 0.9G | N2/O2, respirable | Temp: 22°C | COLONIZADO
  │     ├── Biomas: bosque templado (40%), pradera (30%), montaña (20%), océano (10%)
  │     ├── Fauna: herbívoros medianos, 1 depredador ápice
  │     ├── Civilización: Colonia Hegemónica (Nivel 3), 80K habitantes
  │     ├── Historia: Colonizado hace 300 años por la Hegemonía
  │     └── Tags: HABITABLE, COLONIZADO, AGRICOLA, SEGURO
  ├── Aether-7d (0.68 UA) | Oceánico | 1.1G | Atmósfera densa húmeda | Temp: 35°C
  │     └── Recurso: Perlas bioluminiscentes (exótico)
  ├── Aether-7e (1.2 UA) | Gaseoso enano | 2.3G | H/He | Temp: -40°C
  │     └── Luna: Aether-7e-1 | Helado | Recurso: Helio-3 (raro)
  ├── Aether-7f (2.8 UA) | Gaseoso gigante | 5.1G | H/He/CH4 | Temp: -120°C
  │     └── 3 lunas (heladas)
  └── Aether-7g (4.5 UA) | Helado | 0.5G | Metano congelado | Temp: -200°C
```

---

## VOLUMEN 17: LOD DE PLANETAS (RENDIMIENTO)

Para manejar 32,000 sistemas (~480,000 planetas), el generador usa 5 niveles de detalle:

| LOD | Visibilidad | Datos generados | Coste | Uso |
|:---:|:-----------:|:----------------:|:-----:|:---:|
| 4 | Galáctico | Tags + tipo + facción + peligro | 0.01ms | Mapa galáctico, rutas, simulación |
| 3 | Sistema | + recursos principales + atmósfera | 0.1ms | Vista de sistema, selector de destino |
| 2 | Orbital | + geografía+ clima + civilización | 1ms | Aproximación, escaneo orbital |
| 1 | Atmosférico | + ecosistema + marcadores + historia | 5ms | Entrada atmosférica, selección de zona |
| 0 | Superficie | + mapa detallado + POI + fauna local | 20ms | Exploración en superficie, combate |

La transición entre LODs es transparente. El motor nunca genera una capa que no sea necesaria para la vista actual.

---

*Especificación de Generación Procedural de Planetas — 17 volúmenes.*
*Capaz de generar ~10^18 planetas únicos con 13 capas de profundidad cada uno.*
*Coste: <1ms por capa, generación lazy bajo demanda.*
*Total de planetas en galaxia: ~480,000 (32,000 sistemas × 15 planetas máx).*
