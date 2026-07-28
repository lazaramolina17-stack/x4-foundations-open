# Sistema de Minería y Recursos — *Forja tu Fortuna*

> Diseño detallado: extracción, procesamiento, refinado, crafteo
> 7 tipos de minería, 8 categorías de recursos, 5 niveles de refinado

---

## VOLUMEN 1: FILOSOFÍA DE LA MINERÍA

La minería no es "apuntar y disparar a una roca". Es un sistema económico completo:

- Identificar vetas ricas (requiere skill de exploración + sensores)
- Extraer con la herramienta correcta (cada tipo de recurso requiere método específico)
- Procesar el mineral bruto (ocupa bodega, hay que refinarlo para venderlo bien)
- Decidir: ¿vender bruto (rápido, menos ganancia) o procesar (lento, más ganancia)?
- Riesgo: otros mineros, piratas, patrullas, tormentas de asteroides

---

## VOLUMEN 2: TIPOS DE MINERÍA

| Tipo | Equipo necesario | Recursos obtenidos | Riesgo | Velocidad |
|------|:----------------:|:------------------:|:------:|:---------:|
| **Asteroides** | Cañón minero láser, bodega | Minerales comunes, metales | Bajo (escombros voladores) | Rápido |
| **Superficie planetaria** | Módulo de aterrizaje, taladro | Minerales raros, cristales | Medio (gravedad, clima) | Lento |
| **Gas (gigantes gaseosos)** | Skimmer de gas, tanques | Helio-3, hidrógeno, deuterio | Alto (presión, tormentas) | Medio |
| **Anillos planetarios** | Red de captura, procesador | Hielo, minerales finos | Bajo | Rápido |
| **Ruinas/Naufragios** | Sonda de exploración, equipo de brecha | Tecnología, artefactos | Alto (trampas, hostiles) | Variable |
| **Núcleo de asteroide** | Taladro pesado, soporte vital | Elementos superpesados, antimateria | Extremo | Muy lento |
| **Extracción de plasma (estelar)** | Colector de plasma, escudo térmico | Plasma estelar, energía pura | Extremo (temperatura) | Muy lento |

---

## VOLUMEN 3: CADENA DE VALOR

```
EXTRACCIÓN → PROCESAMIENTO BRUTO → REFINADO → VENTA o CRAFTEO

Valor:        1×               3×                5-10×
Bodega:       10m³/unidad       3m³/unidad         1m³/unidad
```

### Ejemplo: Mineral de Hierro

| Etapa | Producto | Valor (créditos/t) | Bodega (m³/t) |
|-------|----------|:------------------:|:------------:|
| 1. Extracción | Mineral de hierro bruto | 50 | 10 |
| 2. Procesado | Lingotes de hierro | 150 | 3 |
| 3. Refinado | Acero de calidad | 500 | 1 |
| 4. Especializado | Acero reforzado | 1,200 | 1 |

**Conclusión**: Refinar a bordo multiplica tus ganancias ×10, pero requiere:
- Módulo de procesamiento (ocupa ranura)
- Tiempo (1h por lote)
- Energía (10 MW por hora)

---

## VOLUMEN 4: EQUIPO DE MINERÍA

### Cañones Mineros

| Calidad | Daño a roca | Alcance (UA) | Consumo MW | Velocidad extracción | Coste |
|:-------:|:----------:|:-----------:|:----------:|:-------------------:|:-----:|
| Estándar | 50 | 0.3 | 5 | 1 t/min | 5K |
| Pesado | 120 | 0.5 | 12 | 3 t/min | 25K |
| Resonante | 200 | 0.4 | 20 | 5 t/min | 100K (raro) |

### Módulos de Procesamiento

| Tipo | Capacidad (t/lote) | Tiempo | Consumo MW | Calidad de salida | Coste |
|:----:|:------------------:|:------:|:----------:|:-----------------:|:-----:|
| Trituradora básica | 10 | 15 min | 3 | Bruto → Procesado | 10K |
| Refinadora estándar | 5 | 30 min | 8 | Procesado → Refinado | 50K |
| Refinadora avanzada | 8 | 20 min | 15 | Procesado → Refinado (calidad +20%) | 200K |
| Fundidora de precisión | 3 | 45 min | 25 | Refinado → Especializado | 500K |
| Sintetizador molecular | 1 | 60 min | 50 | Crea materiales imposibles de minar | 2M |

### Equipo de Prospección

| Equipo | Efecto | Coste |
|--------|--------|:-----:|
| Escáner geológico | Revela composición de asteroides/planetas en 5 UA | 20K |
| Analizador de vetas | +30% probabilidad de encontrar vetas ricas | 50K |
| Sonda de profundidad | Revela depósitos subterráneos en planetas | 80K |
| Detector de rarezas | Señala recursos raros/legendarios en el sistema | 200K |

---

## VOLUMEN 5: RECURSOS MINERALES — TABLA COMPLETA

### Minerales Comunes

| Recurso | Dureza de veta | Valor bruto/t | Valor refinado/t | Usos principales |
|---------|:--------------:|:-------------:|:----------------:|------------------|
| Hierro | 30 | 50 | 500 | Cascos, blindaje básico, construcción |
| Cobre | 25 | 80 | 750 | Cableado, electrónica, motores |
| Carbón | 20 | 30 | 200 | Combustible base, filtros |
| Silicio | 35 | 60 | 600 | Chips, paneles solares, vidrio |
| Aluminio | 28 | 70 | 650 | Cascos ligeros, componentes estructurales |
| Titanio | 45 | 150 | 1,200 | Blindaje de calidad, componentes de alto estrés |

### Minerales Poco Comunes

| Recurso | Valor bruto/t | Valor refinado/t | Usos |
|---------|:------------:|:----------------:|------|
| Níquel | 120 | 1,000 | Aleaciones, blindaje |
| Cromo | 200 | 1,800 | Armaduras, recubrimientos |
| Uranio | 500 | 4,000 | Combustible nuclear, armas |
| Platino | 800 | 6,000 | Electrónica avanzada, catalizadores |
| Litio | 300 | 2,500 | Baterías, combustible de fusión |
| Cobalto | 250 | 2,000 | Aleaciones magnéticas, sensores |

### Minerales Raros

| Recurso | Valor bruto/t | Valor refinado/t | Usos |
|---------|:------------:|:----------------:|------|
| Deuterio | 1,000 | 8,000 | Combustible FTL, fusión fría |
| Helio-3 | 2,000 | 15,000 | Combustible de fusión limpio |
| Cristal de cuarzo puro | 3,000 | 20,000 | Óptica, sensores de precisión |
| Diamante industrial | 5,000 | 35,000 | Taladros, blindaje de punta |
| Elementos de tierras raras | 4,000 | 25,000 | Electrónica de alto rendimiento |

### Recursos Exóticos

| Recurso | Valor bruto/unidad | Valor refinado | Usos | Dónde encontrarlo |
|---------|:-----------------:|:-------------:|------|-------------------|
| Cristal de Resonancia | 50,000 | No refinable | Armas de resonancia, escudos Armón | Ruinas Xylo, Anomalías |
| Núcleo de Estrella | 500,000 | No refinable | Superarmas, reactores de titán | Solo en estrellas moribundas |
| Polvo de Vacío | 100,000/g | No refinable | Sigilo extremo, tecnología prohibida | Espacio interestelar profundo |
| Módulo de Memoria Xylo | 200,000 | No refinable | IA avanzada, datos históricos | Naves Xylo abandonadas |
| Esencia de Cantor | 1,000,000 | No refinable | Desconocido (múltiples teorías) | Solo en coronas estelares (imposible de extraer) |
| Cristal de Sombra | 300,000 | No refinable | Armas de Vacío, ocultación | Zonas de cuarentena del Enjambre |

---

## VOLUMEN 6: RIESGOS DE LA MINERÍA

| Riesgo | Probabilidad | Efecto | Cómo evitarlo |
|--------|:----------:|--------|---------------|
| Explosión de veta | 10% por veta | Daño 200 al casco, pérdida de 20% de mineral | Escáner de estabilidad |
| Tormenta de asteroides | 2% por hora en cinturón | Daño continuo 50/s, escombros | Huir, escudo activo |
| Piratas | Variable según zona | Robo de carga, destrucción | Escolta, armas, sigilo |
| Patrulla enemiga | Variable | Multa, confiscación, combate | Permiso de minería vigente |
| Colapso de túnel (superficie) | 5% por hora en planeta | Nave atrapada 30 min, daño | Refuerzos estructurales |
| Radiación de veta | Algunas vetas radioactivas | Daño a tripulación (enfermedad) | Traje blindado, escudo de radiación |

---

## VOLUMEN 7: VENTA Y COMERCIO DE RECURSOS

### Canales de Venta

| Canal | Precio | Velocidad | Riesgo |
|-------|:------:|:---------:|:------:|
| Puerto local (estación) | 80% del valor | Instantáneo | Bajo |
| Mercado del Sindicato | 100% del valor | 1h (subasta) | Bajo |
| Venta directa a facción | 120% (si necesitan) | Instantáneo | Medio (si tienen excedentes, pagan menos) |
| Mercado negro | 150% | 24h | Alto (posible trampa) |
| Trueque entre jugadores (Ghost Drift) | Variable | Oferta/48h | Medio |

### Contratos de Minería

| Tipo | Condiciones | Pago base | Bonificación |
|------|-------------|:--------:|:-----------:|
| Suministro regular | Entregar X por semana | 50K/semana | +10% si cumples 4 semanas seguidas |
| Expedición | Explorar y reportar vetas en zona desconocida | 100K + gastos | +50% por veta rara encontrada |
| Extracción urgente | X toneladas en Y horas | 200% precio | — |
| Limpieza de campo | Retirar escombros de batalla | 30K + material | Material gratuito |

---

## VOLUMEN 8: CRAFTEO DE COMPONENTES

Con los recursos refinados, el jugador puede fabricar componentes en un astillero equipado con taller de manufactura.

### Recetas — Ejemplos

| Componente | Recursos necesarios | Tiempo | Coste de manufactura |
|-----------|---------------------|:------:|:-------------------:|
| Cañón láser estándar (cal.1) | 5t acero, 2t cobre, 1t silicio | 30 min | 1K |
| Motor FTL comercial (cal.2) | 8t titanio, 3t platino, 1t deuterio | 2h | 5K |
| Escudo militar (cal.4) | 12t cromo, 5t cristal cuarzo, 2t tierras raras | 6h | 20K |
| Blindaje Armón | 1 cristal de resonancia, 5t titanio, 3t diamante | 24h | 100K |
| Cañón de resonancia | 3 cristales de resonancia, 10t platino, 2 núcleo Xylo | 72h | 500K |

### Ventajas de Fabricar vs Comprar

| Aspecto | Fabricar | Comprar |
|---------|:--------:|:-------:|
| Coste | 40–60% del precio de compra | 100% |
| Tiempo | Horas | Instantáneo |
| Calidad | Controlada (puedes elegir) | Sujeto a stock |
| Personalización | Posible modificar stats | Fijo |
| Receta | Requiere haberla conseguido | No requiere |
| Herramientas | Requiere taller | No requiere |

---

*Sistema de Minería y Recursos completo: 8 volúmenes, 7 tipos de minería, cadena de valor con multiplicador ×10, 30+ recursos en 4 categorías de rareza, equipo completo de extracción y procesamiento, riesgos, canales de venta, contratos, y crafteo de componentes.*
