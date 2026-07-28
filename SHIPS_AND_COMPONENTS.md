# Sistema de Naves y Componentes — *Tu Nave es tu Identidad*

> Diseño detallado: astilleros, módulos, personalización, crafting de componentes
> 10 clases de nave, 7 categorías de componentes, 5 niveles de calidad
> Cada nave: modular, personalizable, mejorable

---

## VOLUMEN 1: FILOSOFÍA DEL SISTEMA

La nave del jugador no es un vehículo. Es su casa, su herramienta, su arma, y su identidad en la galaxia.

**Principios:**
- Cada nave es modular — no hay "mejor nave", solo "mejor nave para lo que haces"
- Los componentes se desgastan (mantenimiento real)
- Mejorar una nave vieja es tan válido como comprar una nueva
- La personalización visual es tan importante como la funcional
- Perder una nave duele de verdad

---

## VOLUMEN 2: CLASES DE NAVE — PLANTILLAS BASE

Cuando el jugador compra una nave, adquiere un **casco base** con estadísticas fijas por clase. Todo lo demás es modular.

### Tabla de Cascos Base

| Clase | Nombre | Tamaño (m) | Slack estructural | Ranuras | Coste base | Velocidad base | Vida base |
|:-----:|--------|:---------:|:-----------------:|:-------:|:----------:|:--------------:|:---------:|
| I | Caza | 12–25 | 2 | 3 | 5K–15K | 400 m/s | 200 |
| II | Corbeta | 30–60 | 4 | 5 | 20K–80K | 280 m/s | 800 |
| III | Fragata | 80–150 | 6 | 8 | 150K–500K | 200 m/s | 2,500 |
| IV | Destructor | 180–300 | 8 | 10 | 800K–2.5M | 160 m/s | 6,000 |
| V | Crucero | 350–600 | 10 | 13 | 5M–20M | 120 m/s | 15,000 |
| VI | Acorazado | 650–1,200 | 12 | 16 | 30M–100M | 80 m/s | 40,000 |
| VII | Portanaves | 800–2,000 | 14 | 18 | 50M–150M | 60 m/s | 30,000 |
| VIII | Titán | 2,000–5,000 | 20 | 25 | 500M+ | 40 m/s | 200,000 |
| IX | Megaestructura | 5,000+ | 30 | 40 | 10B+ | 10 m/s | 1,000,000+ |

**Slack estructural**: Puntos de mejora internos. Cada ranura ocupada por un componente consume 1 slack. El slack no usado puede invertirse en refuerzos estructurales, blindaje integrado, o sistemas de supervivencia.

### Atributos Base de Casco (comunes a todas las clases)

```rust
struct Hull {
    class: ShipClass,
    model: String,           // ej: "Mark-7 Aether", "Martillo-3 Rojano"
    manufacturer: FactionId,
    hull_integrity: f32,     // 0.0–1.0 (daño permanente al casco)
    mass_base: f32,          // toneladas (sin componentes)
    mass_current: f32,       // con componentes instalados
    cargo_capacity: f32,     // toneladas de bodega base
    crew_capacity: u16,      // tripulación máxima
    power_output: f32,       // MW generados por reactor base
    power_consumption: f32,  // MW consumidos por sistemas base
    heat_dissipation: f32,   // kW/°C de disipación pasiva
    signature: f32,          // detectabilidad base (mayor = más visible)
    armor_base: f32,         // resistencia estructural del casco
    shield_capacity: f32,    // capacidad base de escudos (si instalados)
    sensor_range: f32,       // UA base
    jump_range: f32,         // AL por salto base
    fuel_capacity: f32,      // toneladas de combustible
    fuel_consumption: f32,   // toneladas por salto
    maneuverability: f32,    // 0.0–1.0 (agilidad de giro)
    price: f64,              // créditos
    rarity: Rarity,          // qué tan difícil de encontrar
}
```

---

## VOLUMEN 3: COMPONENTES — 7 CATEGORÍAS

Cada nave tiene **ranuras** (slots) que se llenan con componentes. Hay 7 categorías de componentes, cada una con subtipos:

### 3.1 Motores

| Componente | Ranura | Función | Variables clave |
|-----------|:------:|---------|:---------------:|
| Motor de maniobra | 1 | Rotación y aceleración lineal intra-sistema | empuje (kN), consumo (MW), firma térmica |
| Motor FTL (Salto) | 1 | Propulsión interestelar | rango (AL), cooldown (min), consumo combustible |
| Post-quemador | 0.5 | Sprint temporal (8s), cooldown 30s | multiplicador velocidad, calor generado |

### Tabla de Motores de Maniobra por Clase

| Calidad | Empuje (kN) | Consumo (MW) | Firma térmica | Coste |
|:-------:|:----------:|:------------:|:-------------:|:-----:|
| Estándar | 100 | 5 | 1.0 | 5K |
| Mejorado | 150 | 7 | 1.2 | 15K |
| Avanzado | 220 | 10 | 1.5 | 50K |
| Militar | 350 | 15 | 2.0 | 200K |
| Prototipo | 500 | 20 | 2.5 | 1M |

### Tabla de Motores FTL

| Calidad | Rango (AL) | Cooldown (min) | Combustible/salto | Coste |
|:-------:|:---------:|:--------------:|:-----------------:|:-----:|
| Civil | 15 | 5 | 1.0t | 10K |
| Comercial | 25 | 4 | 0.8t | 40K |
| Militar | 40 | 3 | 1.2t | 200K |
| Exploración | 60 | 2 | 1.5t | 800K |
| Xylo (raro) | 100 | 1 | 0.5t | 10M+ |

---

### 3.2 Armas

6 categorías de armas (ver SYSTEMS_DESIGN.md). Cada arma ocupa 1 ranura (armas pequeñas) o 2–3 (pesadas).

### Tabla Comparativa de Armas

| Arma | Daño/s | Alcance (UA) | Consumo MW | Calor/s | Ranuras | Coste |
|:----:|:------:|:-----------:|:----------:|:-------:|:-------:|:-----:|
| Cañón láser | 50 | 0.5 | 10 | 80 | 1 | 5K |
| Cañón láser pesado | 150 | 0.8 | 30 | 200 | 2 | 25K |
| Railgun ligero | 80 | 1.0 | 15 | 40 | 1 | 8K |
| Railgun pesado | 250 | 1.5 | 40 | 100 | 2 | 40K |
| Lanzamisiles (4 tubos) | 200/salva | 2.0 | 5 | 20 | 1 | 10K |
| Batería misiles (12 tubos) | 600/salva | 2.5 | 12 | 50 | 2 | 60K |
| Cañón de plasma | 120 | 0.6 | 25 | 150 | 2 | 20K |
| Cañón de iones | 30 (escudos: 200) | 0.7 | 20 | 60 | 2 | 30K |
| Torpedo de resonancia | 500 | 1.0 | 50 | 300 | 3 | 200K |
| Point-defense (CIWS) | 10 (misiles) | 0.3 | 8 | 30 | 1 | 15K |
| Haz de tractor | 0 (control) | 0.4 | 15 | 10 | 1 | 20K |

---

### 3.3 Escudos

| Calidad | Capacidad | Recarga/s | Consumo MW | Penalización firma | Coste |
|:-------:|:---------:|:---------:|:----------:|:------------------:|:-----:|
| Civil | 500 | 10 | 5 | 0% | 10K |
| Comercial | 1,500 | 25 | 10 | +10% | 40K |
| Militar | 4,000 | 50 | 20 | +20% | 200K |
| Avanzado | 8,000 | 80 | 35 | +30% | 1M |
| Prototipo | 15,000 | 120 | 60 | +50% | 5M |

### Tipos de Escudo

| Tipo | Ventaja | Desventaja |
|------|---------|------------|
| Cinético | +30% vs impacto | -20% vs energía |
| Energía | +30% vs láser/plasma | -20% vs cinético |
| Resonancia | +20% contra todo | +50% consumo MW |
| Entrópico | Absorbe daño → recarga más rápido | 50% capacidad base |
| Fase | 10% probabilidad de ignorar daño | 2× consumo MW, +100% firma |

---

### 3.4 Blindaje

| Tipo | Armor | Masa (t) | Penalización maniobra | Coste/t | Efecto especial |
|:----:|:-----:|:--------:|:--------------------:|:-------:|-----------------|
| Compuesto estándar | 50 | 1.0 | −1% | 500 | Ninguno |
| Placas de titanio | 100 | 2.0 | −3% | 2K | +10% vs cinético |
| Cerámica ablativa | 75 | 0.5 | −0.5% | 3K | +30% vs energía (+20% vs cinético) |
| Carbono-nanotubo | 150 | 0.8 | −2% | 10K | Ligero y resistente |
| Reactivo (explosivo) | 200 | 2.5 | −5% | 15K | Niega 1 impacto pesado, luego se agota |
| Armón (raro) | 300 | 0.3 | −0.5% | 100K | Autorreparable (1%/s), resistencia resonancia |
| Xylo (legendario) | 500 | 0.1 | −0.1% | 1M+ | Regenerativo, adaptable (cambia resistencia) |

---

### 3.5 Sensores

| Calidad | Alcance (UA) | Resolución | Consumo MW | Firma pasiva | Coste |
|:-------:|:-----------:|:----------:|:----------:|:------------:|:-----:|
| Estándar | 5 | Baja | 2 | 0.8 | 5K |
| Comercial | 10 | Media | 4 | 0.9 | 20K |
| Militar | 25 | Alta | 8 | 1.0 | 100K |
| Científico | 50 | Muy alta | 12 | 1.1 | 300K |
| T'sarri (sigilo) | 15 | Alta | 6 | 0.3 | 500K |
| Ssathiss (archivo) | 30 | Extrema | 10 | 0.9 | 800K |

### Modos de Sensor

| Modo | Efecto |
|------|--------|
| Pasivo | Detecta firmas (motores, escudos, comunicación). No te delata. |
| Activo | Escanea todo. Te delata inmediatamente (firma ×5). Obtienes datos completos. |
| Geológico | Escanea composición planetaria. Modo científico. |
| Táctico | Rastrea proyectiles, calcula trayectorias. +10% precisión defensiva. |
| Resonancia | Detecta anomalías de Vacío, artefactos Xylo. Corto alcance (2 UA). |

---

### 3.6 Electrónica y Guerra Electrónica

| Componente | Ranura | Efecto | Coste |
|-----------|:------:|--------|:-----:|
| Ordenador de batalla | 1 | +15% precisión, −10% recarga armas | 30K |
| Sistema de puntería | 0.5 | +10% daño crítico | 15K |
| Interferidor de señales | 1 | −40% precisión enemiga en 1 UA | 50K |
| Señuelo táctico | 0.5 | Lanza señuelo (dura 10s, cooldown 60s) | 20K |
| Sistema de camuflaje | 1 | −80% firma al estar inmóvil | 200K |
| Decodificador de comunicaciones | 0.5 | Intercepta comunicaciones enemigas locales | 40K |
| Firewall cuántico | 0.5 | −90% probabilidad de hackeo | 80K |
| Núcleo de IA auxiliar | 1 | Automatiza tareas, +5% eficiencia general | 500K |

---

### 3.8 Componentes Internos (No Ranura, Mejoras de Casco)

| Componente | Slack | Efecto | Coste |
|-----------|:-----:|--------|:-----:|
| Refuerzo estructural | 1 | +20% vida del casco | 50K |
| Compartimentos sellados | 1 | +30% resistencia a brechas | 30K |
| Cableado redundante | 1 | −20% probabilidad de fallo sistémico | 40K |
| Blindaje interno | 2 | +15% armor, −5% maniobra | 100K |
| Bodega expandida | 1–3 | +50% carga por punto de slack | 20K/slack |
| Alojamiento mejorado | 1 | +30% moral de tripulación, efectos de RPG | 50K |
| Laboratorio de investigación | 2 | Permite análisis de artefactos a bordo | 200K |
| Taller de reparación | 2 | Reparaciones sin astillero (50% velocidad) | 150K |
| Clínica médica | 1 | Recuperación de tripulación más rápida | 80K |

---

## VOLUMEN 4: CALIDAD DE COMPONENTES

Cada componente existe en 5 niveles de calidad, que afectan todas sus estadísticas:

| Nivel | Nombre | Multiplicador stats | Rareza | Precio relativo |
|:-----:|--------|:-------------------:|:------:|:---------------:|
| 1 | Estándar | 1.0× | Común | 1× base |
| 2 | Mejorado | 1.3× | Poco común | 3× base |
| 3 | Avanzado | 1.7× | Raro | 10× base |
| 4 | Militar/Élite | 2.2× | Muy raro | 30× base |
| 5 | Prototipo/Legendario | 3.0× | Único | 100×+ base |

### Fabricantes por Facción

| Fabricante | Facción | Especialidad | Calidad máxima |
|-----------|---------|-------------|:--------------:|
| Astilleros Sol | Hegemonía | Motores FTL, blindaje compuesto | 4 |
| Forja de Roj | Liga Rojana | Armas cinéticas, blindaje reactivo | 4 |
| Banco de Nido | K'thari | Electrónica, ordenadores de batalla | 4 |
| Talleres Pte'rak | Pte'rak | Componentes de precisión, sensores | 5 |
| Núcleo Nexum | Nexum | Interfaces neurales, IA auxiliar | 4 |
| Cámaras T'sarri | T'sarri | Sigilo, guerra electrónica | 5 (pero no venden a cualquiera) |
| Enclave Ssathiss | Ssathiss | Sensores, data-cores | 5 (solo intercambio por datos) |
| Artesanía Xylo | Xylo (Restos) | Todo, calidad 5 | 5 (pero hay que encontrarlos y negociar) |

---

## VOLUMEN 5: ASTILLEROS

### Tipos de Astillero

| Tipo | Servicios | Coste recargo |
|------|-----------|:-------------:|
| **Puerto Civil** | Reparación básica, combustible, componentes calidad 1–2 | +0% |
| **Puerto Comercial** | Reparación completa, componentes calidad 1–3 | +10% |
| **Base Militar** | Componentes calidad 3–4, armas militares, blindaje reactivo | +20% (solo afiliados) |
| **Astillero Corporativo** | Personalización estética, componentes 1–4, préstamos | +30% |
| **Astillero de Flota** | Todo, calidad 1–5, construcción de naves clase I–VII | +50% (requiere permisos) |
| **Astillero Titán** | Construcción clase VIII–IX, superarmas | +100% (acceso restringido) |
| **Puerto Pirata** | Componentes sin preguntas, calidad 1–4, robados (−30% precio) | −30% (riesgo de ser identificado) |
| **Estación de Investigación** | Componentes experimentales, calidad 5 | Varía (misiones o intercambio) |

### Servicios de Astillero

| Servicio | Coste | Tiempo | Descripción |
|----------|:-----:|:------:|-------------|
| Reparación | 10% del daño en créditos | 1 min/100 vida | Recupera vida de la nave |
| Mantenimiento | 2% del valor nave | 5 min | Previene desgaste, limpia firma acumulada |
| Cambio componente | precio componente | Instantáneo | Instalar/desinstalar un componente |
| Repintado | 5K–50K | 10 min | Cambiar esquema de color |
| Personalización visual | 10K–200K | 30 min | Cambiar silueta, decoraciones, luces |
| Overhaul completo | 20% del valor nave | 1h | Restaura slack estructural, repara daño permanente |
| Construcción nave | precio base | 1h–24h (según clase) | Encargar nave nueva |
| Subasta de naves capturadas | variable | evento | Naves incautadas a la venta |

---

## VOLUMEN 6: PERSONALIZACIÓN VISUAL

### Esquemas de Color

Cada facción ofrece su paleta. También hay colores neutros y premium:

| Gama | Colores | Coste | Desbloqueo |
|------|---------|:-----:|:----------:|
| Básica | 20 colores sólidos | 5K | Inicial |
| Facción | Paleta de cada facción | 15K | Reputación +10 con esa facción |
| Metálicos | 10 acabados metalizados | 30K | 50h de juego |
| Camuflaje | 15 patrones de guerra | 40K | 100h o facción militar |
| Premium | 5 colores raros (negro absoluto, blanco puro, cromo) | 200K | 500h o evento especial |
| Legendario | Color único (solo 1 por jugador) | 1M | Misión legendaria |

### Decoraciones

| Tipo | Ejemplos | Coste | Ranura visual |
|------|----------|:-----:|:------------:|
| Insignia de facción | Logotipo en alerón/puente | 5K | 1 |
| Marcas de victoria | Calcomanías de naves destruidas | 2K c/u | 5 máx |
| Luces de acento | Tiras LED en bordes | 10K | 3 |
| Diorama de proa | Escultura decorativa | 50K | 1 |
| Tren de aterrizaje personalizado | Color/tipo de glow de aterrizaje | 15K | 1 |
| Estela de motor | Color del rastro del motor | 20K | 1 |
| Nombre de nave | Letrero luminoso en el casco | 30K | 1 |

---

## VOLUMEN 7: MANTENIMIENTO Y DESGASTE

Cada componente tiene **durabilidad** (0–100). Se desgasta con el uso:

| Acción | Desgaste |
|--------|:--------:|
| Salto FTL | −2 a motor FTL, −1 a refuerzos |
| Combate (recibir daño) | −0.1 por golpe a cada componente |
| Combate (disparar) | −0.5 por salva al arma usada |
| Uso de post-quemador | −3 al motor de maniobra |
| Escudo recibiendo daño | −0.5 al generador de escudo |
| Viaje normal | −0.1/hora a todos los componentes |

Cuando un componente llega a 0 de durabilidad, **falla**:
- Motor: no acelera (o explota si crítico)
- Arma: no dispara (puede sobrecalentarse y dañar la nave)
- Escudo: no genera escudo
- Sensor: no detecta nada

La reparación cuesta créditos y tiempo (ver servicios de astillero). El jugador puede hacer reparaciones de emergencia con kits de reparación (restauran 20–50% de durabilidad, calidad según kit).

---

## VOLUMEN 8: COMBATE Y DAÑO POR SISTEMA

Cuando una nave recibe daño, el sistema determina qué componente se daña:

1. Probabilidad de impacto en componente = 10% + (precisión del atacante)
2. Si impacta en componente: selección aleatoria ponderada por tamaño del componente
3. Daño al componente = daño del arma × (1 − blindaje local del componente)
4. Si el componente llega a 0 de vida: destruido permanentemente (efecto específico)

### Efectos de Componentes Destruidos

| Componente destruido | Efecto inmediato |
|---------------------|------------------|
| Motor FTL | No puedes saltar. Atrapado en el sistema. |
| Motor maniobra | −90% aceleración, derivas sin control |
| Arma | Esa arma no funciona |
| Escudo | Pierdes escudo (si es el primario) |
| Sensor | −90% alcance de detección |
| Reactor principal | Fallo de energía total en 30s |
| Puente (crítica) | −50% a todas las estadísticas (daño de mando) |
| Bodega | Pérdida de 30–70% de carga |
| Habitabilidad | La tripulación empieza a morir en 5 min |

---

## VOLUMEN 9: ADQUISICIÓN DE NAVES

### Métodos de Conseguir una Nave

| Método | Coste | Tiempo | Riesgo | Notas |
|--------|:-----:|:------:|:------:|-------|
| Compra nueva | Precio base | 1–24h en astillero | Ninguno | Garantía incluida |
| Compra usada | 40–70% precio | Inmediato | +20% desgaste inicial | Puede tener componentes ocultos |
| Captura en combate | 0 | Misión de abordaje | Alto | Tripulación hostil, posible trampa |
| Hallazgo/exploración | 0 | Tiempo de búsqueda | Alto | Nave abandonada, puede estar dañada o tener sorpresas |
| Misión/recompensa | 0 | Misiones largas | Medio | Nave única, a menudo personalizada |
| Construcción propia | 60–80% precio | Largo (días reales) | Ninguno | Totalmente personalizable, requiere permisos de astillero |

---

## VOLUMEN 10: ECOSISTEMA DE ASTILLEROS

Cada facción tiene astilleros registrados. El juger puede consultar el catálogo galáctico:

```
> ASTILLEROS EN SISTEMA AETHER-7:
  1. Puerto Central (Hegemonía) — Civil, Comercial
  2. Astillero Voss (Sindicato) — Corporativo, préstamos, componentes calidad 1-4
  3. Base Rojana (Liga — REQUIERE PERMISO) — Militar, blindaje reactivo
  4. Taller Pte'rak (Neutral) — Componentes de precisión calidad 5 (stock limitado)
  5. Desguace (Independiente) — Usado, piezas robadas, −30% precio
  
> COMPONENTES DISPONIBLES EN ASTILLERO VOSS:
  - Motor FTL Comercial (cal.2) — 40K créditos — Stock: 5
  - Cañón láser Estándar (cal.1) — 5K créditos — Stock: ∞
  - Railgun Mejorado (cal.2) — 24K créditos — Stock: 2
  - Escudo Militar (cal.4) — 200K créditos — Stock: 0 (EN REPOSICIÓN, 3h)
```

---

*Sistema de Naves y Componentes completo.*
*10 clases, 7 categorías de componentes, 5 niveles de calidad, 10 fabricantes.*
*8 tipos de astillero con servicios, mantenimiento con desgaste real, daño por sistema.*
