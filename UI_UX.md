# Interfaz de Usuario y Experiencia — *Lo que Ves es lo que Controlas*

> HUD, mapas, menús, interfaces de todos los sistemas
> Diseñado para 2D cenital con 5 niveles de zoom

---

## VOLUMEN 1: FILOSOFÍA DE UI

La interfaz debe ser **invisible** — el jugador debe sentir que controla la nave directamente, no que opera un menú.

Principios:
- **Información a demanda**: nada permanente en pantalla que no sea crítico
- **Contextual**: lo que ves depende de lo que estás haciendo y a qué zoom
- **Jerarquía visual**: lo más importante es lo más grande y visible
- **Consistencia**: mismos colores, mismos iconos, mismos gestos en todo el juego
- **Mínimo clicks**: ninguna acción debería requerir más de 3 clics

---

## VOLUMEN 2: HUD PRINCIPAL

### Layout (pantalla 1920×1080 referencia)

```
┌──────────────────────────────────────────────────────────────────┐
│ [BARRA SUPERIOR]  Sistema: Aether-7b  |  Créditos: 12,450       │
│                    Estación: Puerto Central |  Combustible: ████  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│        [AREA DE JUEGO — 2D CENITAL — ZOOM ACTUAL]               │
│                                                                  │
│                                                                  │
│                                                                  │
│                                                                  │
│                                                                  │
│                                                                  │
│                                                                  │
│                                                                  │
├──────────────┬───────────────────────────────────────┬───────────┤
│ [MINIMAPA]   │                                       │ [INFO]    │
│ Sistema      │                                       │ Blanco:   │
│ actual con   │                                       │ Fragata   │
│ iconos de    │                                       │ Vida: 75% │
│ naves y      │                                       │ Esc: 60%  │
│ POIs         │                                       │ Dist: 0.8 │
│              │                                       │ UA        │
├──────────────┴───────────────────────────────────────┴───────────┤
│ [BARRA INFERIOR]  Armas: [Láser] [Rail] [Misil] | Motor: ████   │
│                    Escudo: ██████  |  Vida: ████████              │
└──────────────────────────────────────────────────────────────────┘
```

### Elementos del HUD por Nivel de Zoom

| Elemento | Detalle | Galáctico | Estratégico | Flota | Táctico |
|:--------:|:-------:|:---------:|:-----------:|:-----:|:-------:|
| Barra superior | Sistema, créditos, combustible | ✓ | ✓ | ✓ | ✓ |
| Minimapa | Mapa del ámbito actual | ✓ | ✓ | ✓ | ✓ |
| Info de blanco | Nave seleccionada | ✗ | ✗ | ✓ | ✓ |
| Armas | Estado de armas | ✗ | ✗ | ✓ | ✓ |
| Escudo/Vida | Barras de salud | ✗ | ✗ | ✓ | ✓ |
| Radar | Naves cercanas (5 UA) | ✗ | ✗ | ✓ | ✓ |
| Brújula de misión | Dirección del objetivo | ✗ | ✓ | ✓ | ✓ |
| Tags de sistema | Iconos de facción, peligro | ✓ | ✓ | ✗ | ✗ |
| Rutas comerciales | Líneas de comercio | ✓ | ✓ | ✗ | ✗ |

---

## VOLUMEN 3: MAPA GALÁCTICO (ZOOM 4)

### Vista de Mapa Galáctico

```
┌──────────────────────────────────────────────────────────────────┐
│ [MAPA GALÁCTICO — VÍA ORIONALIS]              ───── ✕           │
│                                                                  │
│          · · · · · BRAZO INTERIOR · · · · · ·                    │
│         ·  [Sol] ── [Aether] ── [Tharsis]  ·                     │
│        ·      │           │            │    ·                    │
│       ·   [K'thar] ── [Verda] ── [Pte'rak]  ·                   │
│      ·                            │  [NÚCLEO]                    │
│     ·      · · · · · · · · · ·  [ANILLO]  · · ·                 │
│      ·                            │  [ZONA CUARENTENA]          │
│       ·   [Roj] ── [Drak'tar] ── [Furia]   ·                    │
│        ·      │           │            │    ·                    │
│         ·   [Fenrir] ── [Hel] ── [Q'lot]  ·                     │
│          · · · · · BRAZO EXTERIOR · · · · · ·                    │
│                                                                  │
│ [Filtros: █ Facción █ Peligro █ Recursos █ Misiones]            │
│ [Sistema seleccionado: Aether-7 — Rep: Heg +20 — 3 misiones]    │
└──────────────────────────────────────────────────────────────────┘
```

### Funcionalidad del Mapa Galáctico

| Acción | Efecto |
|--------|--------|
| Click en sistema | Seleccionar, mostrar info |
| Click derecho | Trazar ruta |
| Rueda de zoom | Cambiar nivel de zoom |
| Filtros | Mostrar solo ciertos tipos de sistema |
| Buscar | Buscar sistema por nombre |
| Marcadores | Marcar sistemas favoritos |
| Capas | Superponer: rutas, guerras, facciones, peligros |

---

## VOLUMEN 4: INTERFACES ESPECÍFICAS

### Interfaz de Astillero

```
┌──────────────────────────────────────────────────────────────────┐
│ ASTILLERO — PUERTO CENTRAL (AETHER-7)                           │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  NAVE ACTUAL: Corbeta Mark-7 (Clase II)                         │
│  ┌──────────────────────────────────────────────────────┐       │
│  │  [VISTA DE NAVE — SPRITE 2D CENITAL]                 │       │
│  │                                                       │       │
│  │  Ranuras ocupadas: 4/5    Slack: 2/4    Masa: 120t   │       │
│  └──────────────────────────────────────────────────────┘       │
│                                                                  │
│  RANURAS:                                                       │
│  [Motor FTL] [Motor maniobra] [Arma 1] [Arma 2] [Vacía]        │
│     Civil       Estándar      Láser     Railgun                  │
│                                                                  │
│  [ + Añadir componente ]  [ − Retirar ]  [ ↑ Mejorar ]         │
│                                                                  │
│  COMPONENTES DISPONIBLES:                                        │
│  ┌──────────────┬──────────┬───────┬────────┬────────┐         │
│  │ Componente   │ Calidad  │ Stock │ Precio │ Efecto │         │
│  ├──────────────┼──────────┼───────┼────────┼────────┤         │
│  │ Motor FTL    │ Mej. (2) │ 3     │ 40K    │ +10 AL │         │
│  │ Cañón láser  │ Avz. (3) │ 1     │ 50K    │ +30 dño│         │
│  │ Escudo       │ Mil. (4) │ 0     │ 200K   │ AGOTADO│         │
│  │ Blindaje     │ Est. (1) │ ∞     │ 500/t  │ +50 ar │         │
│  └──────────────┴──────────┴───────┴────────┴────────┘         │
│                                                                  │
│  CRÉDITOS: 12,450    [COMPRAR] [VENDER] [REPARAR] [SALIR]      │
└──────────────────────────────────────────────────────────────────┘
```

### Interfaz de Mercado

```
┌──────────────────────────────────────────────────────────────────┐
│ MERCADO — PUERTO CENTRAL (AETHER-7)                             │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  RECURSOS EN VENTA:                    TU BODEGA: 45t/100t     │
│  ┌──────────┬───────┬────────┬──────┐  ┌──────────┬──────┬────┐│
│  │ Recurso  │ Stock │ Precio │ Tend │  │ Recurso  │ Cant │ Val││
│  ├──────────┼───────┼────────┼──────┤  ├──────────┼──────┼────┤│
│  │ Acero    │ 5,000 │ 50/t   │ ↑    │  │ Acero    │ 20t  │ 1K ││
│  │ Titanio  │ 200   │ 150/t  │ →    │  │ Cristal  │ 5t   │ 5K ││
│  │ Cristal  │ 50    │ 1K/t   │ ↓    │  │ Datos    │ 2un  │ 4K ││
│  │ Helio-3  │ 0     │ 2K/t   │ AGOT │  └──────────┴──────┴────┘│
│  │ Comida   │ 1,000 │ 20/t   │ →    │                           │
│  └──────────┴───────┴────────┴──────┘                           │
│                                                                  │
│  [COMPRAR]  [VENDER]  [BUSCAR]  [HISTORIAL]                    │
│                                                                  │
│  PREDICCIÓN: El precio del Helio-3 subirá +20% en 2 ticks       │
│  (Dato obtenido de Ssathiss — necesita confirmación)            │
└──────────────────────────────────────────────────────────────────┘
```

### Interfaz de Tripulación

```
┌──────────────────────────────────────────────────────────────────┐
│ TRIPULACIÓN — A BORDO DE CORBETA MARK-7                          │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ TRIPULANTES ACTIVOS:                                             │
│                                                                  │
│  ┌───────┬─────────┬──────┬───────┬──────┬─────────┬────────┐  │
│  │ Nombre│ Rol     │ Nvl  │ Sueldo│ Leal │ Moral   │ Salud  │  │
│  ├───────┼─────────┼──────┼───────┼──────┼─────────┼────────┤  │
│  │ Jak   │ Piloto  │ 8    │ 800/d │ ████ │ █████  │ ██████ │  │
│  │ Zara  │ Artill. │ 5    │ 500/d │ ██   │ █████  │ ██████ │  │
│  │ Vex   │ Ing.    │ 3    │ 300/d │ █████│ ████   │ ████   │  │
│  └───────┴─────────┴──────┴───────┴──────┴─────────┴────────┘  │
│                                                                  │
│  [CONTRATAR]  [DESPEDIR]  [ASIGNAR ROL]  [HABLAR]              │
│                                                                  │
│  MORAL GRUPAL: 78% — BUENA                                       │
│  GASTO DIARIO: 1,600 cr                                         │
│  PRÓXIMO PAGO: en 5h reales                                     │
└──────────────────────────────────────────────────────────────────┘
```

### Interfaz de Misiones

```
┌──────────────────────────────────────────────────────────────────┐
│ TABLERO DE MISIONES — PUERTO CENTRAL (AETHER-7)                 │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  [TODAS] [COMBATE] [COMERCIO] [EXPLORACIÓN] [FACCIÓN]          │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ ★ [URGENTE] Transporte médico → Nueva Esperanza          │   │
│  │   Recompensa: 2,500cr + Rep Sindicato +10  | Tiempo: 30m│   │
│  │   [ACEPTAR] [INFO]                                       │   │
│  ├──────────────────────────────────────────────────────────┤   │
│  │ [Peligro: Medio] Escolta convoy Minero → Cinturón-7      │   │
│  │   Recompensa: 5,000cr  |  Tiempo: 45m                   │   │
│  │   [ACEPTAR] [INFO]                                       │   │
│  ├──────────────────────────────────────────────────────────┤   │
│  │ Contrato minero: 500t de hierro → Fundición local        │   │
│  │   Recompensa: 25,000cr  |  Plazo: 7 días                │   │
│  │   [ACEPTAR] [INFO]                                       │   │
│  ├──────────────────────────────────────────────────────────┤   │
│  │ [RESTRINGIDO] Investigación arqueológica (Círculo +30)   │   │
│  │   Recompensa: 50,000cr + Dato científico  |  Tiempo: 2h │   │
│  │   [BLOQUEADO — Requiere reputación Círculo +30]          │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
│  [ACEPTADAS: 1/3]  [COMPLETADAS: 12]  [FALLADAS: 2]           │
└──────────────────────────────────────────────────────────────────┘
```

---

## VOLUMEN 5: NOTIFICACIONES Y FEEDBACK

### Sistema de Notificaciones

| Tipo | Color | Duración | Ejemplo |
|:----:|:-----:|:--------:|:--------|
| Éxito | Verde | 3s | "Misión completada: +2,500cr, +10 Rep Sindicato" |
| Peligro | Rojo | Persistente | "NAVE HOSTIL DETECTADA — 1.2 UA" |
| Información | Azul | 5s | "Sistema Aether-7: 3 misiones disponibles" |
| Evento | Amarillo | 8s | "TORMENTA DE ASTEROIDES — Cinturón de Aether" |
| Sistema | Blanco | 2s | "Combustible bajo: 1 salto restante" |

### Feedback de Combate

| Evento | Feedback visual | Feedback sonoro |
|--------|:---------------:|:---------------:|
| Escudo recibe daño | Destello azul en borde de pantalla | Zumbido eléctrico |
| Casco recibe daño | Vibración de pantalla, marca roja | Golpe metálico |
| Arma recarga | Indicador de arma en barra inferior | Click mecánico |
| Blanco destruido | Explosión sprite, +créditos en pantalla | Explosión grave |
| Nave propia dañada | Líneas rojas, humo en sprite | Alarmas, sirenas |
| Misil entrante | Icono de alerta rojo + pitido | Pitido creciente |

---

## VOLUMEN 6: MAPA ESTELAR (ZOOM 3 — SISTEMA)

```
┌──────────────────────────────────────────────────────────────────┐
│ SISTEMA: AETHER-7     [Estrella: Enana naranja K3V]            │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│              [PUERTO CENTRAL] ★                                  │
│                  │                                               │
│                  │ 0.45 UA                                       │
│                  │                                               │
│    ┌─────────────┴─────────────┐                                │
│    │                           │                                │
│  [A-7a] 0.12UA              [A-7c] 0.68UA                      │
│  Roca estéril               Oceánico                            │
│    │                           │                                │
│    │                           │ 1.2 UA                         │
│    │                           │                                │
│    │                      [A-7d] Gaseoso enano                  │
│    │                           │     └── [Luna] Helado          │
│    │                           │         Helio-3 disponible     │
│    │ 2.8 UA                    │                                │
│    │                           │ 4.5 UA                         │
│  [A-7e] Gaseoso gigante     [A-7f] Helado                       │
│                                                                  │
│   [Leyenda: ● Visitado  ○ No visitado  ★ Estación  ⚠ Peligro]  │
│                                                                  │
│  [SELECCIONADO: A-7c (Oceánico)]                                │
│  ─────────────────────────────────────                           │
│  Tipo: Oceánico | Gravedad: 1.1G | Atm: Densa húmeda           │
│  Temp: 35°C | Recurso: Perlas bioluminiscentes (Exótico)       │
│  Peligro: Tormentas frecuentes | Control: Nadie (no colonizado)│
│                                                                  │
│  [VIAJAR A] [ESCANEAR] [MARCAR] [INFO]                         │
└──────────────────────────────────────────────────────────────────┘
```

---

*Interfaz de Usuario completa: HUD por nivel de zoom, layout de pantalla, 5 interfaces específicas (astillero, mercado, tripulación, misiones, mapa), sistema de notificaciones con colores y feedback de combate.*
