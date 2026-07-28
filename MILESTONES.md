# Milestones — *Hoja de Ruta de Desarrollo*

> Fases de producción, tiempos estimados, entregables
> Equipo asumido: 5 programadores, 3 artistas, 1 diseñador, 1 audio

---

## V1: FASES DE DESARROLLO

### Fase 0: Prototipo (3 meses)

| Mes | Objetivo | Entregable |
|:---:|:---------|:-----------|
| 1 | Motor base | Render 2D cenital, movimiento de nave, cámara zoom 5 niveles |
| 2 | Generación procedural | Pipeline semilla→sistema→planeta viable. 1,000 sistemas generables. |
| 3 | Game loop básico | Despegar, navegar, aterrizar, abrir mercado, comprar/vender. Prototipo jugable de 10 min. |

### Fase 1: Alpha (6 meses)

| Mes | Objetivo | Entregable |
|:---:|:---------|:-----------|
| 4 | Naves y componentes | 3 clases de nave (I, II, III), 10 componentes, astillero funcional |
| 5 | Combate básico | 3 tipos de arma, 2 tipos de IA enemiga, daño por sistema |
| 6 | Misiones | 10 templates, tablero de misiones, recompensas, 3 facciones jugables |
| 7 | Economía | 30 bienes, fórmula de precio dinámico, mercados locales |
| 8 | UI principal | HUD, mapa galáctico, mapa de sistema, interfaz de astillero y mercado |
| 9 | Alpha integrada | Loop completo jugable: despegar → misión → combate → recompensa → mejora. 3 sistemas. |

### Fase 2: Beta (6 meses)

| Mes | Objetivo | Entregable |
|:---:|:---------|:-----------|
| 10 | 13 facciones completas | Matriz diplomática, reputación, misiones por facción, naves emblemáticas |
| 11 | Profesiones y progresión | 10 profesiones, skills, licencias, árbol tecnológico |
| 12 | Tripulación | Contratación, generación procedural, moral, lealtad, roles |
| 13 | Estaciones de jugador | Construcción, módulos, mejora, defensa automática |
| 14 | Contenido de planeta | 5 tipos de planeta explorables, minería, flora/fauna básica |
| 15 | Beta jugable | 100 sistemas, loop completo con progresión, pulido de UI |

### Fase 3: Golden (6 meses)

| Mes | Objetivo | Entregable |
|:---:|:---------|:-----------|
| 16 | Cadenas legendarias | 3 cadenas de 8 misiones cada una, branching, recompensas únicas |
| 17 | Ghost Drift | Servidor Rust/Axom, eventos anonimizados, fragments, pruebas de red |
| 18 | Contenido de lore | 30 razas (perfiles completos), diálogos, eventos narrativos |
| 19 | Audio completo | 10 temas, SFX, mezcla dinámica por contexto |
| 20 | Pulido y balance | Ajuste de stats, precios, dificultad, curva de progresión |
| 21 | Lanzamiento | Versión 1.0, 500 sistemas, contenido estimado 200h |

### Fase 4: Post-lanzamiento (indefinido)

| Hito | Tiempo | Contenido |
|:-----|:------:|:----------|
| Actualización 1.1 | +2 meses | Más planetas, 20 razas adicionales, cadenas de misiones extra |
| Actualización 1.2 | +4 meses | Editor de mods, soporte para contenido creado por usuarios |
| Actualización 1.3 | +6 meses | Eventos galácticos masivos, crisis, facciones dinámicas |
| Expansión 2.0 | +12 meses | El Anillo — expedición jugable al Anillo Apagado, nuevo contenido |

---

## V2: TIEMPOS TOTALES

| Fase | Duración | Coste estimado (equipo) |
|:----|:--------:|:----------------------:|
| Prototipo | 3 meses | ~$150K |
| Alpha | 6 meses | ~$350K |
| Beta | 6 meses | ~$400K |
| Golden | 6 meses | ~$400K |
| **Total** | **21 meses** | **~$1.3M** |

### Costes Operativos Adicionales

| Concepto | Coste mensual |
|:---------|:------------:|
| Servidores Ghost Drift (10K jugadores) | ~$110 |
| Herramientas y licencias | ~$2K |
| QA externo | ~$5K (picos en Beta/Golden) |

---

## V3: RIESGOS Y MITIGACIÓN

| Riesgo | Probabilidad | Impacto | Mitigación |
|:-------|:-----------:|:-------:|:-----------|
| Scope creep (añadir más contenido del planeado) | Alta | Alto | Congelar features en Alpha, solo contenido nuevo post-lanzamiento |
| Rendimiento con miles de entidades | Media | Alto | LOD system desde el prototipo, pruebas de estrés semanales |
| Generación procedural no produce planetas interesantes | Media | Medio | Iteración temprana (mes 1–2), seed review semanal |
| Ghost Drift no escala | Baja | Medio | Arquitectura stateless desde el día 1, pruebas de carga |
| Balance económico roto | Alta | Medio | Fórmula parametrizable, ajustable sin parche (datos externos) |

---

## V4: HITO CRÍTICO — PROTOTIPO JUGABLE

El hito más importante del proyecto es el **prototipo jugable al mes 3**. Si para entonces no hay un loop divertido, el proyecto se replantea.

**Prueba de fuego**: Un jugador externo (no del equipo) debe:
1. Abrir el juego
2. Entender cómo moverse sin instrucciones (< 1 min)
3. Aceptar una misión (< 2 min)
4. Completarla con éxito (< 15 min)
5. Querer jugar otra

Si esto no funciona, el diseño necesita iteración antes de escalar.

---

*Milestones: 21 meses de desarrollo, ~$1.3M, 4 fases, prototipo jugable crítico al mes 3, riesgos identificados y mitigados.*
