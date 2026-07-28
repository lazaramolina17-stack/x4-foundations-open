# Tutorial y Onboarding — *Aprender Haciendo*

> No hay tutorial separado. El juego asume que eres adulto.
> El mundo te enseña mientras vives en él.

---

## VOLUMEN 1: FILOSOFÍA

El juego no tiene:
- Pantalla de tutorial
- Misiones tutorial marcadas como "tutorial"
- Pop-ups que pausan el juego para explicar mecánicas
- Video instructivo

En su lugar:
- El primer sistema es seguro y simple (Aether-3)
- La interfaz muestra lo que puedes hacer (iconos, tooltips contextuales)
- Las primeras acciones tienen retroalimentación inmediata y clara
- El tablero de misiones tiene misiones etiquetadas con nivel de dificultad
- El juego no penaliza el fracaso en las primeras 2 horas (nave asegurada)

---

## VOLUMEN 2: PRIMEROS 30 MINUTOS

### Minuto 0–2: Despertar

```
> DESPERTAR EN ESTACIÓN PUERTA LIMINAR
  Sistema: Aether-3 | Región: Brazo Interior

  "Tu nombre es [generado]. Tienes una deuda de 10,000cr con el Sindicato
  de Transportistas. Tu nave, una Corbeta Mark-7, te espera en el hangar.
  El tablero de avisos tiene trabajo. El resto depende de ti."

  [OK — LEVANTARSE] → Teletransportas al hangar
```

- Sin control de movimiento de personaje. Estás en el hangar, en tu nave.
- La interfaz muestra la nave y los controles básicos.
- No hay preguntas. No hay "tutorial de movimiento".

### Minuto 2–5: Primeros Controles

```
INTERFAZ MOSTRADA EN PANTALLA:
  [WASD] Movimiento | [Mouse] Apuntar | [Click Izq] Disparar
  [Tab] Mapa | [M] Misiones | [E] Interactuar

  "Prueba los controles en la zona de pruebas del hangar."
  (Zona de pruebas: 3 objetivos estáticos, nadie te ataca)
```

- El jugador dispara a objetivos estáticos 20s.
- No hay medallas, no hay "bien hecho". Simplemente funciona.

### Minuto 5–10: Primer Despegue

```
CONTROL DE TRÁFICO:
  "Corbeta Mark-7, autorizado despegue. Buena suerte ahí fuera."
  
  [E] → Despegar
```

- Animación de 3s de despegue.
- El jugador está ahora en el espacio, cerca de la estación.

### Minuto 10–30: Primera Misión

```
TABLERO DE AVISOS:
  1. [Fácil] Transporte médico → Nueva Esperanza [800cr] [+10 Rep Sindicato]
  2. [Fácil] Contrato minero → Cinturón de Aether [500cr + 20% vetas]
  3. [Fácil] Datos geológicos → Universidad de Tharsis [300cr]
  4. (Recordatorio) Deuda: 500cr en 7 días

  (Tooltip: "Las misiones con [Fácil] son recomendadas para empezar.")
```

El jugador elige una misión. Al completarla:
- Efecto visual: "+800cr" flota hacia arriba
- Notificación verde: "Misión completada"
- El dinero aparece en el contador de créditos
- La reputación sube (+10 Sindicato)

---

## VOLUMEN 3: INSTRUCCIÓN POR CONTEXTO

Cada elemento de la interfaz tiene un tooltip que aparece al pasar el ratón 1.5s:

| Elemento | Tooltip |
|----------|---------|
| Barra de combustible | "Combustible para saltos FTL. Se consume al saltar. Reabastece en estaciones." |
| Barra de escudo | "Escudo de nave. Absorbe daño. Se recarga automáticamente fuera de combate." |
| Botón de misión | "Aceptar misión. Las misiones tienen tiempo límite. Fallar penaliza reputación." |
| Botón de mapa | "Mapa galáctico. Navega entre sistemas pulsando en ellos." |
| Créditos | "Tu saldo. Gánalos con misiones, comercio, minería. Gástalos sabiamente." |

---

## VOLUMEN 4: PRIMERAS 2 HORAS — ZONA DE SEGURIDAD

Durante las primeras 2 horas (reales), el jugador está en "zona de新手 protección":

| Protección | Descripción |
|:----------:|:-----------|
| Sin muerte permanente | Si tu nave explota, apareces en la última estación con la nave intacta (una vez) |
| Sin piratas agresivos | Los piratas en sistemas iniciales huyen si les disparas |
| Sin deuda por reposición | La primera muerte no genera deuda adicional |
| Precios estables | El mercado no fluctuará salvajemente en sistemas iniciales |
| Misiones fáciles | Al menos 3 misiones [Fácil] siempre disponibles en el sistema inicial |

Después de 2 horas:
- La protección se desactiva gradualmente (no de golpe)
- El mensaje: "La galaxia ya no te tiene consideración. Buena suerte."
- A partir de aquí, el juego es completo y despiadado

---

## VOLUMEN 5: CURVA DE APRENDIZAJE IMPLÍCITA

| Hora de juego | Concepto aprendido | Cómo lo aprende |
|:-------------:|:-------------------|:----------------|
| 0–0.5 | Moverse, disparar, interactuar | Zona de pruebas + primera misión |
| 0.5–1 | Misiones, tablero, recompensas | Completa 2–3 misiones fáciles |
| 1–2 | Navegación FTL, mapa galáctico | Viaja a sistema vecino para misión |
| 2–4 | Economía: comprar/vender | Vende carga de misión, compra combustible |
| 4–8 | Reputación: afecta precios y acceso | Una facción le cierra el acceso por baja rep |
| 8–15 | Personalización de nave | Compra primer componente en astillero |
| 15–30 | Gestión de tripulación | Contrata primer tripulante |
| 30–50 | Construcción de estación | Compra permiso y construye puesto |
| 50–100 | Cadenas de misiones | Encuentra primera cadena legendaria |

---

*Sistema de Tutorial y Onboarding completo: no hay tutorial separado, zona de新手 protección de 2h, aprendizaje implícito por acción, tooltips contextuales, curva de 100h.*
