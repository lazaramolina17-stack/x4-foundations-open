# Sistema de Escala Visual de Naves

> Estándar artístico y de diseño visual para toda la Vía Orionalis
> Inspirado en claridad visual tipo Rusted Warfare — adaptado a escala espacial

---

## 1. Dirección Artística

| Atributo | Estándar |
|----------|----------|
| **Vista** | Cenital absoluta (Top-Down 2D) |
| **Sprites** | Dibujados a mano, alta calidad |
| **Estilo** | Limpio, legible, sin ruido visual |
| **Siluetas** | Reconocibles al instante, contrastadas |
| **Color** | Identificación por facción inmediata |
| **Sombras** | Simples, drop-shadow proyectado al sur |
| **Efectos** | Elegantes, ligeros, partículas mínimas |
| **Rendimiento** | GPU batch, miles de entidades simultáneas |

No se busca realismo extremo. Se busca **claridad, rendimiento y lectura visual inmediata**.

---

## 2. Filosofía de Escala

Cada categoría debe **sentirse completamente distinta**. La diferencia entre Clase I y Clase IX no es estadística — es existencial.

> Una nave enorme no es un caza con más vida. Es un evento que redefine el campo de batalla.

---

## 3. Tabla de Clases de Nave

| Clase | Nombre | Tamaño px | Rol | Densidad típica |
|:-----:|--------|:---------:|-----|:----------------:|
| **I** | Caza | 8–16 | Exploración, intercepción, escolta, ataque rápido, reconocimiento | 1,000+ por batalla |
| **II** | Corbeta | 20–32 | Defensa, patrulla, apoyo | 100–500 |
| **III** | Fragata | 40–64 | Combate medio, defensa de flotas, soporte | 50–200 |
| **IV** | Destructor | 70–100 | Ataque pesado, bombardeo, defensa antiaérea | 20–80 |
| **V** | Crucero | 100–150 | Centro de combate, soporte de flota, guerra electrónica | 10–40 |
| **VI** | Acorazado | 150–250 | Artillería pesada, buque insignia, resistencia extrema | 5–20 |
| **VII** | Portanaves | 200–350 | Fabricar cazas, reparar, reabastecer, centro logístico | 2–10 |
| **VIII** | Titán | 350–700 | Superarmas, campo de batalla móvil, control de sectores, transporte masivo | <5 en toda la galaxia |
| **IX** | Megaestructura móvil | 700–2000+ | Ciudades espaciales, astilleros gigantes, fortalezas móviles, arcas, mundos artificiales | Únicas |

**Nota**: Un caza (8px) y una megaestructura (2000px) comparten la misma pantalla gracias al zoom dinámico. La diferencia es de 250× en escala visual.

---

## 4. Estaciones Espaciales

| Tipo | Tamaño px | Propósito |
|------|:---------:|-----------|
| Pequeña | 30–60 | Puesto fronterizo, depósito, baliza |
| Mediana | 60–120 | Estación comercial, puerto menor |
| Grande | 120–300 | Capital regional, astillero, base militar |
| Gigante | 300–800+ | Capital de facción, fortaleza, anillo industrial |

Algunas estaciones gigantes (estaciones anillo, habitats tipo O'Neill) ocupan una **parte importante del mapa** a zoom de sistema.

---

## 5. Zoom Dinámico — 5 Niveles

| Nivel | Nombre | Rango | Visible |
|:-----:|--------|:-----:|---------|
| 0 | **Detalle** | 1×–2× | Tripulación en cubierta, daño por sector de casco, texto de terminal |
| 1 | **Táctico** | 0.3×–1× | Clases I–IX completas, armamento visible, animaciones de motor |
| 2 | **Flota** | 0.1×–0.3× | Formaciones, escuadrones, maniobras de batalla |
| 3 | **Estratégico** | 0.01×–0.1× | Sistema completo, órbitas, rutas comerciales, zonas de control |
| 4 | **Galáctico** | < 0.01× | Múltiples sistemas, guerras, movimientos de flota, esferas de influencia |

**Regla**: Una nave Clase IX solo se aprecia completa en zoom Nivel 1 (Táctico) o superior. En zoom Estratégico se muestra como icono de silueta + etiqueta.

---

## 6. Legibilidad — Identificación Sin Textos

Toda nave debe poder identificarse por:

1. **Silueta** — forma única por clase y facción
2. **Tamaño relativo** — la escala es información
3. **Color de facción** — paleta por facción (ver §8)
4. **Motores** — número y brillo indican clase
5. **Armamento visible** — torretas, lanzamisiles, cañones
6. **Animaciones** — patrones de movimiento distintos por clase

No se deben mostrar etiquetas de texto para identificación básica. El jugador debe leer la batalla visualmente.

---

## 7. IA por Clase — Comportamientos Distintos

| Clase | Comportamiento de IA |
|:-----:|---------------------|
| **I** | Enjambre — movimientos erráticos, rodean, atacan en grupos, huyen si solos |
| **II** | Escolta — orbitan naves aliadas más grandes, interceptan amenazas |
| **III** | Línea — formación, avance coordinado, fuego de cobertura |
| **IV** | Asalto — avanzan recto contra objetivos grandes, ignoran cazas |
| **V** | Comando — se posicionan en retaguardia, priorizan blancos de alto valor |
| **VI** | Ancla — lentos, giran para presentar blindaje, fuego de castigo |
| **VII** | Logística — se mantienen a distancia, lanzan/recuperan cazas |
| **VIII** | Centro de mando — dictan prioridades a flota, superarma en cooldown |
| **IX** | Estratégica — IA de alto nivel, decisiones que afectan el sistema entero |

Los cazas no actúan como destructores. Los destructores no actúan como portanaves. Cada clase tiene una **personalidad de combate** única.

---

## 8. Paleta de Facción (Color Primario)

| Facción | Color primario | Hex | Secundario |
|---------|:--------------:|:---:|:----------:|
| Hegemonía de Sol | Azul marino | #1a2a4a | Dorado #c9a84c |
| Liga Rojana | Rojo óxido | #8b1a1a | Acero #4a4a4a |
| Sindicato de Transportistas | Verde oliva | #4a6b3a | Oro #d4af37 |
| Iglesia de la Resonancia | Marfil | #e8e0c8 | Púrpura #6a2a7a |
| Colectivo de Estaciones Libres | Cian | #2a8a8a | Blanco #e0e0e0 |
| Círculo Científico | Blanco | #e8e8e8 | Azul eléctrico #2a6aff |
| Restos Xylo | Púrpura oscuro | #2a1a3a | Verde neón #3aff3a |
| Alianza Fronteriza | Naranja quemado | #c96a2a | Marrón #5a3a1a |
| Culto del Vacío | Negro absoluto | #0a0a0a | Rojo sangre #6a0000 |
| Peregrinos de Armón | Azul claro | #7ab8e0 | Blanco #f0f0f0 |
| Flota Fantasma | Gris cadáver | #5a5a5a | Rojo óxido #8b1a1a |
| Piratas del Velo | Amarillo sucio | #c9b84a | Negro #1a1a1a |
| Guardianes del Anillo | Blanco puro | #ffffff | Rojo #cc0000 |

---

## 9. Rendimiento — Targets

| Escenario | Entidades | FPS target |
|-----------|:---------:|:----------:|
| Combate masivo | 3,000+ (I–III) + 50 (IV–VI) + 5 (VII+) | 60fps |
| Flota en tránsito | 200–500 naves + estaciones | 60fps |
| Sistema Civil | 50–100 naves + 5–20 estaciones | 60fps |
| Zoom galáctico | 32,000 sistemas (iconos + labels) | 60fps |

GPU instancing para sprites repetidos (cazas). LOD spritesheet: 3 variantes por clase (alta/media/baja).

---

## 10. Escenas Épicas — Diseño de Momentos

El motor y los sistemas deben permitir:

- Miles de cazas rodeando un Titán como moscas alrededor de una bestia
- Portanaves lanzando cientos de drones en oleadas
- Cruceros disparando andanadas de misiles trazadores
- Titanes con superarmas devastando estaciones en 3 disparos
- Flotas completas defendiendo una colonia bajo bombardeo orbital
- Campos de asteroides usados como cobertura por fragatas
- Nebulosas deformando los sensores, naves apareciendo y desapareciendo
- Anomalías de Vacío alterando físicas locales durante el combate
- Megaestructura desplazándose lentamente, aplastando todo a su paso

---

*Estándar visual aprobado. Integrar en CONTENT_ARCHITECT.md y como referencia para arte y programación.*
