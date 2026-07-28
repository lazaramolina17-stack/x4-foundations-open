# Sistema de Misiones Detallado — *El Mundo te Pide Cosas*

> Generación branching, cadenas de misiones, recompensas dinámicas, facciones
> 20 templates arquetipo × 13 facciones = 260 variantes base, millones de instancias

---

## VOLUMEN 1: GENERACIÓN DE MISIONES

### Pipeline de 6 Pasos (ver MISSION_LOOP.md)

```
1. Validar facción → la facción tiene autoridad/motivo para emitir esta misión
2. Seleccionar template → de los 20 arquetipos, según necesidades de la facción
3. Poblar variables → sistema, facciones involucradas, objetivos, recompensas
4. Validar viabilidad → 3 reintentos si el resultado no es coherente
5. Asignar recompensa → según dificultad, rareza, y riesgo
6. Publicar → disponible en tablero de la facción
```

---

## VOLUMEN 2: LOS 20 TEMPLATES ARQUETIPO

### Tabla de Templates

| # | Template | Tipo | Descripción | Duración estimada | Recompensa base |
|:-:|:---------|:----:|:-----------|:------------------:|:--------------:|
| 1 | **Transporte** | Comercio | Llevar carga de A a B. No requiere combate. | 15–30 min | 5K–50K cr |
| 2 | **Escolta** | Combate | Proteger una nave o convoy | 20–45 min | 10K–100K cr |
| 3 | **Patrulla** | Combate | Limpiar zona de enemigos | 15–40 min | 8K–80K cr |
| 4 | **Eliminación** | Combate | Destruir un blanco específico | 20–60 min | 20K–500K cr |
| 5 | **Extracción** | Minería | Extraer X cantidad de recurso Y | 20–60 min | 5K–60K cr |
| 6 | **Exploración** | Exploración | Cartografiar un sistema o zona | 30–90 min | 10K–100K cr |
| 7 | **Investigación** | Ciencia | Analizar artefacto o fenómeno | 30–90 min | 15K–150K cr |
| 8 | **Entrega urgente** | Comercio | Llevar algo rápido (contrarreloj) | 10–30 min | 15K–100K cr |
| 9 | **Rescate** | Combate | Liberar prisioneros o recuperar datos | 30–60 min | 20K–200K cr |
| 10 | **Infiltración** | Sigilo | Entrar, obtener datos, salir sin ser visto | 30–90 min | 30K–300K cr |
| 11 | **Sabotaje** | Sigilo | Destruir instalación o nave enemiga ocultamente | 30–90 min | 40K–400K cr |
| 12 | **Cazarrecompensas** | Combate | Capturar o eliminar un objetivo con precio | 30–120 min | 50K–1M cr |
| 13 | **Defensa de estación** | Combate | Defender una estación de un ataque | 20–60 min | 20K–200K cr |
| 14 | **Suministro** | Comercio/Minería | Llevar recursos a una colonia necesitada | 20–60 min | 10K–80K cr |
| 15 | **Diplomacia** | Diálogo | Llevar mensaje o negociar entre facciones | 30–90 min | 20K–150K cr |
| 16 | **Contrabando** | Sigilo | Pasar mercancía ilegal por aduanas | 20–60 min | 30K–300K cr |
| 17 | **Guerra de información** | Ciencia/Datos | Robar o plantar datos en sistema enemigo | 30–90 min | 40K–400K cr |
| 18 | **Construcción** | Ingeniería | Ayudar a construir o reparar una estación | 60–180 min | 50K–500K cr |
| 19 | **Prueba de combate** | Combate | Sobrevivir X oleadas de enemigos | 15–45 min | 10K–100K cr |
| 20 | **Cadena de misiones** | Mixto | Serie de 3–8 misiones conectadas narrativamente | 3–8h total | 200K–5M cr |

---

## VOLUMEN 3: GENERACIÓN POR FACCIÓN

Cada facción pondera los templates según su especialidad y necesidad actual:

| Facción | Templates preferidos | Prohibidos |
|---------|:--------------------:|:----------:|
| **Hegemonía** | 1, 2, 3, 4, 8, 13, 14 | 10, 11, 16 |
| **Liga Rojana** | 4, 7, 12, 13, 19 | 10, 15, 18 |
| **Sindicato** | 1, 5, 8, 14, 16, 18 | 4, 11, 12 |
| **Iglesia** | 6, 7, 9, 15, 20 | 11, 16, 17 |
| **Colectivo** | 9, 14, 15, 18 | 4, 11, 12 |
| **Círculo Científico** | 6, 7, 17, 20 | 4, 11, 16 |
| **Restos Xylo** | 7, 17, 20 | 4, 11, 12 |
| **Alianza Fronteriza** | 1, 5, 9, 14, 18 | 4, 11, 17 |
| **Culto del Vacío** | 10, 11, 17, 20 | 1, 2, 8, 15 |
| **Peregrinos de Armón** | 6, 7, 15, 20 | 4, 11, 16 |
| **Flota Fantasma** | — (no emiten misiones) | Todas |
| **Piratas** | 1, 9, 10, 11, 12, 16 | 2, 3, 4, 13, 15 |
| **Guardianes del Anillo** | 3, 6, 7, 13, 15 | 4, 11, 16, 17 |

---

## VOLUMEN 4: MISIONES BRANCHING (CADENAS)

### Estructura de Cadena

Una cadena de misiones es una serie de 3–8 misiones conectadas por decisiones del jugador. Cada misión tiene hasta 3 outcomes que afectan la siguiente.

```
Misión 1
  ├── Éxito A → Misión 2A (aliado con facción X)
  ├── Éxito B → Misión 2B (aliado con facción Y)
  └── Fracaso → Misión 2C (ambas facciones enemigas)

Misión 2A
  ├── Decisión 1 → Misión 3A (ataque directo)
  ├── Decisión 2 → Misión 3B (infiltración)
  └── Decisión 3 → Misión 3C (paga para evitarlo)

... hasta finalizar la cadena
```

### Cadena de Ejemplo: "El Precio del Poder"

| Paso | Misión | Decisión | Consecuencia |
|:----:|:-------|:---------|:-------------|
| 1 | Llevar cargamento a estación fronteriza | Entregar / Robar / Informar a otra facción | Determina qué facción te odia/ama |
| 2 | Escoltar científico a ruina alienígena | Dejar que lo capturen / Defenderlo / Unirte a los captores | +/− rep con Círculo, Piratas |
| 3 | Investigar la ruina | Compartir datos / Venderlos / Usarlos | Desbloquea tecnología, créditos, o enemigos |
| 4 | La facción traicionada ataca | Defender estación / Huir / Negociar | +/− rep masivo, posible pérdida de estación |
| 5 | Final: reconstruir o destruir | Ayudar reconstrucción / Rematar / Neutral | Cambia el mapa político del sector |

---

## VOLUMEN 5: RECOMPENSAS DINÁMICAS

### Fórmula de Recompensa Base

```
Recompensa = Dificultad_base × Rango_jugador × Riesgo × (1 + Reputación_bonus)
```

Donde:
- **Dificultad_base**: 1,000–100,000cr según template
- **Rango_jugador**: 1.0× (rango 1) a 3.0× (rango 10 en profesión relevante)
- **Riesgo**: 1.0× (seguro) a 5.0× (muerte probable)
- **Reputación_bonus**: hasta +50% si eres aliado de la facción

### Tipos de Recompensa

| Tipo | Ejemplo | Frecuencia |
|------|:-------:|:----------:|
| Créditos | 5K–5M | Siempre |
| Reputación | +5 a +50 | Siempre |
| Componente | Arma, escudo, motor calidad 3+ | 40% |
| Datos | Mapas, tecnología, secretos | 30% |
| Nave | Nave clase I–IV | 5% (misiones de facción) |
| Terreno/Estación | Permiso de construcción | 2% |
| Contacto | Nuevo tripulante disponible | 15% |
| Información | Localización de tesoro/ruina | 20% |

---

## VOLUMEN 6: ESTADOS DE MISIÓN

| Estado | Descripción |
|:------:|:-----------|
| CREADA | Generada pero no visible hasta su tick de publicación |
| DISPONIBLE | Visible en tablero, cualquier jugador puede aceptar |
| ACEPTADA | Un jugador la tomó. Exclusiva (excepto misiones de facción). |
| EN PROGRESO | El jugador está ejecutándola. Puede fallar si abandona el sistema. |
| COMPLETADA | Objetivos cumplidos. Recompensa entregada. |
| FALLADA | Tiempo límite excedido o el jugador falló el objetivo. |
| EXPIRADA | Nunca fue aceptada. Se regenera en el siguiente tick. |

### Penalización por Fracaso

| Motivo | Penalización |
|--------|:------------|
| Tiempo límite excedido | −10 reputación con la facción |
| Nave destruida durante misión | Misión fallada automáticamente |
| Abandono voluntario | −20 reputación, posible pérdida de depósito |
| Traición (ayudar al enemigo) | −50 reputación, caza permanente de la facción |

---

*Sistema de Misiones Detallado completo: 20 templates arquetipo × 13 facciones, branching de cadenas con 3 outcomes por paso, fórmula de recompensa dinámica, 7 estados con penalizaciones.*
