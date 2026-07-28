# Space Shooter 3D

**Un shooter espacial 3D desarrollado con Godot Engine 4.3+**

Pilotaje tu nave a través del espacio infinito, enfréntate a oleadas de enemigos, desbloquea nuevas naves y domina 8 tipos de armas diferentes. Cada partida te recompensa con créditos para mejorar tu arsenal y sobrevivir más tiempo.

---

## Características

- **Gráficos 3D completos** — Escenarios espaciales, efectos de partículas, iluminación dinámica y modelos poligonales.
- **Naves múltiples** — 5 naves desbloqueables, cada una con estadísticas únicas (velocidad, escudo, energía, cadencia).
- **8 tipos de armas** — Desde cañones láser básicos hasta misiles teledirigidos y lanzallamas de plasma.
- **Combate por oleadas** — Oleadas progresivas de enemigos con dificultad creciente.
- **Jefes finales** — Jefes que aparecen cada 5 oleadas con patrones de ataque únicos.
- **Tienda y mejoras** — Gasta créditos para mejorar armas, escudos y capacidad de energía entre partidas.
- **Sistema de auto-aim** — Apuntado asistido que facilita el combate en dispositivos móviles.
- **Sistema de escudo y energía** — Escudo absorbe daño (se recarga), energía alimenta las armas especiales.
- **Controles táctiles Android** — Joystick virtual, botones de armas y habilidades adaptados a pantalla táctil.
- **Controles por teclado** — Soporte completo para teclado y mouse en PC.

---

## Capturas de pantalla

*(Agrega aquí imágenes de tu proyecto)*

```
screenshots/
├── gameplay_01.png
├── shop_screen.png
├── ship_selection.png
└── boss_fight.png
```

---

## Requisitos

| Componente | Versión mínima |
|---|---|
| Godot Engine | 4.3 (o superior) |
| Android SDK | API 26+ (para exportar a Android) |
| Gradle | 7.0+ (incluido con Android SDK) |
| OpenGL | 3.3 / OpenGL ES 3.0 |
| Memoria RAM (PC) | 4 GB |
| Almacenamiento | 500 MB libres |

---

## Cómo compilar para Android

### 1. Instalar Godot 4.3+
Descarga Godot 4.3+ desde [godotengine.org](https://godotengine.org/download).

### 2. Configurar Android SDK
Asegúrate de tener instalado Android SDK. Puedes usar Android Studio o la línea de comandos:

```bash
# Instalar SDK tools (si no los tienes)
sudo apt install android-sdk
```

### 3. Configurar Godot para Android
1. Abre Godot → **Editor → Editor Settings → Export → Android**.
2. Configura la ruta a `adb` y `JDK`.
3. En **Project → Export → Add... → Android**.
4. Completa los campos:
   - **Package Name**: `com.tunombre.spaceshooter3d`
   - **Version Code**: `1`
   - **Version Name**: `1.0`

### 4. Generar la APK

**Opción A — Exportar desde el editor:**
1. Ve a **Project → Export**.
2. Selecciona la plantilla Android.
3. Haz clic en **Export Project**.
4. Elige `spaceshooter.apk` como destino.

**Opción B — Exportar desde terminal:**
```bash
godot --headless --export-debug "Android" build/spaceshooter.apk
```

### 5. Instalar en dispositivo
```bash
adb install build/spaceshooter.apk
```

> **Nota:** Si es la primera vez que exportas, Godot te pedirá descargar las **Android Export Templates**. Ve a **Editor → Manage Export Templates → Download**.

---

## Cómo ejecutar en el editor de Godot

### Desde la terminal
```bash
godot project.godot
```

### Desde el editor gráfico
1. Abre Godot Engine.
2. Haz clic en **Import** o **Importar**.
3. Navega a la carpeta del proyecto y selecciona `project.godot`.
4. Presiona **F5** o el botón **Play** (triángulo en la esquina superior derecha).
5. Selecciona la escena principal (`res://scenes/main/Main.tscn`) si se te pide.

### Hot-reload
Godot recarga los scripts automáticamente. Los cambios en las escenas se ven reflejados al presionar **Ctrl + Shift + R** (recargar escena actual).

---

## Controles

### Teclado y mouse

| Acción | Tecla |
|---|---|
| Moverse | **WASD** |
| Ascender / Descender | **Q / E** |
| Mirar / Apuntar | **Mouse** |
| Disparar arma primaria | **Click izquierdo** |
| Disparar arma secundaria | **Click derecho** |
| Cambiar arma | **Rueda del mouse** |
| Seleccionar arma 1-4 | **Teclas 1-4** |
| Escudo especial | **Espacio** |
| Pausa | **Esc** |
| Recargar | **R** |

### Táctil (Android)

| Control | Descripción |
|---|---|
| Joystick izquierdo | Movimiento de la nave |
| Joystick derecho | Apuntado / cámara |
| Botón disparo (grande) | Arma primaria |
| Botón habilidad | Escudo / especial |
| Slider armas | Cambiar entre armas disponibles |
| Botón pausa | Pausar partida |

---

## Sistema de créditos

Los créditos son la moneda del juego. Se obtienen al destruir enemigos y completar oleadas.

| Acción | Créditos |
|---|---|
| Eliminar enemigo básico | +10 |
| Eliminar enemigo avanzado | +25 |
| Eliminar jefe | +100 |
| Completar oleada (bonus) | +50 × número de oleada |
| Power-up recogido | Variable |

Los créditos se guardan automáticamente y persisten entre partidas. Se pueden gastar en la **Tienda** entre partidas para mejorar armas, naves y escudos.

---

## Tipos de armas

| # | Arma | Daño | Cadencia | Energía | Descripción |
|---|---|---|---|---|---|
| 1 | Láser básico | 10 | Alta | 0 | Disparo continuo, sin costo de energía |
| 2 | Cañón de plasma | 25 | Media | 10 | Proyectil cargado que explota al impactar |
| 3 | Misil guiado | 40 | Baja | 25 | Sigue al enemigo más cercano |
| 4 | Ráfaga láser | 8 × 3 | Muy alta | 5 | Dispara 3 láseres en abanico |
| 5 | Lanzallamas | 15/seg | Continua | 30/seg | Daño área sostenido |
| 6 | Francotirador | 80 | Muy baja | 15 | Un solo disparo de alto daño |
| 7 | Campo de pulso | 50 | Baja | 40 | Onda expansiva radial |
| 8 | Lluvia de meteoros | 30 × 5 | Baja | 60 | Invoca meteoros desde arriba |

---

## Tipos de enemigos

| Enemigo | HP | Velocidad | Daño | Creditos | Comportamiento |
|---|---|---|---|---|---|
| **Dron** | 20 | Rápida | 5 | 10 | Vuela en línea recta hacia el jugador |
| **Caza** | 50 | Media | 10 | 15 | Patrulla y dispara ráfagas |
| **Acorazado** | 200 | Lenta | 20 | 30 | Disparo pesado, mucha vida |
| **Bombardero** | 80 | Lenta | 35 | 25 | Suelta bombas con retardo |
| **Nimbo** | 30 | Muy rápida | 8 | 12 | Teletransportación corta, esquivas |
| **Jefe (Oleada 5)** | 1000 | Lenta | 50 | 100 | 3 fases, patrones de bala, invoca drones |
| **Jefe (Oleada 10)** | 2500 | Media | 75 | 200 | Escudos rotatorios, rayos láser |
| **Jefe (Oleada 15+)** | 5000+ | Variable | 100+ | 500 | Múltiples ataques, fases enrage |

---

## Tipos de naves

| Nave | Velocidad | Escudo | Energía | Cadencia | Arma inicial | Cómo desbloquear |
|---|---|---|---|---|---|---|
| **Delta-1** | Media | 100 | 100 | 1.0x | Láser básico | Por defecto |
| **Interceptor** | Muy alta | 60 | 120 | 1.3x | Ráfaga láser | 500 créditos |
| **Tanque** | Baja | 250 | 80 | 0.7x | Cañón de plasma | 1000 créditos |
| **Acechador** | Alta | 80 | 150 | 1.1x | Misil guiado | 1500 créditos |
| **Apocalipsis** | Media | 180 | 200 | 0.9x | Campo de pulso | 5000 créditos |

---

## Estructura del proyecto

```
space_game/
├── project.godot                 # Archivo de proyecto Godot
├── README.md                     # Este archivo
│
├── assets/                       # Recursos del juego
│   ├── fonts/                    # Fuentes tipográficas
│   ├── textures/                 # Texturas (PNG, WebP)
│   ├── audio/                    # Efectos de sonido y música
│   └── models/                   # Modelos 3D (GLB/OBJ)
│
├── scenes/                       # Escenas Godot (.tscn)
│   ├── main/                     # Escena principal del juego
│   │   └── Main.tscn
│   ├── menu/                     # Menús (principal, opciones)
│   │   ├── MainMenu.tscn
│   │   └── OptionsMenu.tscn
│   ├── hud/                      # Interfaz de juego (HUD)
│   │   ├── HUD.tscn
│   │   └── ShopScreen.tscn
│   ├── player/                   # Escena del jugador
│   │   └── Player.tscn
│   ├── enemies/                  # Escenas de enemigos
│   │   ├── Drone.tscn
│   │   ├── Fighter.tscn
│   │   ├── Battleship.tscn
│   │   └── Boss.tscn
│   ├── weapons/                  # Escenas de armas/proyectiles
│   │   ├── LaserBullet.tscn
│   │   ├── PlasmaBolt.tscn
│   │   ├── Missile.tscn
│   │   └── PulseWave.tscn
│   └── effects/                  # Efectos visuales
│       ├── Explosion.tscn
│       └── ShieldEffect.tscn
│
├── scripts/                      # Scripts GDScript
│   ├── auto_load/                # Singletons (AutoLoad)
│   │   ├── GameManager.gd
│   │   ├── AudioManager.gd
│   │   ├── SaveManager.gd
│   │   └── WaveManager.gd
│   ├── player/
│   │   ├── Player.gd
│   │   └── ShipData.gd
│   ├── enemies/
│   │   ├── EnemyBase.gd
│   │   ├── Drone.gd
│   │   ├── Fighter.gd
│   │   ├── Boss.gd
│   │   └── BossStateMachine.gd
│   ├── weapons/
│   │   ├── WeaponBase.gd
│   │   ├── Laser.gd
│   │   ├── PlasmaCannon.gd
│   │   ├── MissileLauncher.gd
│   │   ├── Flamethrower.gd
│   │   ├── SniperCannon.gd
│   │   ├── BurstLaser.gd
│   │   ├── PulseField.gd
│   │   └── MeteorRain.gd
│   ├── ui/
│   │   ├── HUD.gd
│   │   ├── MainMenu.gd
│   │   ├── ShopScreen.gd
│   │   └── TouchControls.gd
│   └── utils/
│       ├── AutoAim.gd
│       ├── CreditSystem.gd
│       └── MathUtils.gd
│
├── addons/                        # Plugins/recursos externos
│
└── build/                         # APKs compiladas (ignorado en git)
    └── .gitkeep
```

---

## Licencia

```
MIT License

Copyright (c) 2026

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## Contribuir

1. Haz un fork del repositorio.
2. Crea una rama (`git checkout -b feature/nueva-funcionalidad`).
3. Haz commit de tus cambios (`git commit -m 'Agrega nueva funcionalidad'`).
4. Haz push a la rama (`git push origin feature/nueva-funcionalidad`).
5. Abre un Pull Request.

Lee `AGENTS.md` para conocer las convenciones de código y la arquitectura del proyecto.
