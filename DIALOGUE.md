# Diálogos y Narrativa — *La Galaxia Habla*

> Banco de líneas por facción, sistema contextual, eventos narrativos
> Sin cinemáticas, sin cortes de gameplay

---

## V1: BANCO DE LÍNEAS POR FACCIÓN

### Hegemonía de Sol

| Contexto | Línea |
|:---------|:------|
| Saludo neutral | "Nave no identificada, identifíquese o será escoltada." |
| Saludo aliado | "Bienvenido, [nombre]. Su presencia está registrada." |
| Misión | "La Hegemonía solicita sus servicios. Pago más bonificación." |
| Amenaza | "Violando el Tratado de Unificación. Deténgase o abriremos fuego." |
| Agradecimiento | "La Hegemonía reconoce su servicio. Expediente actualizado." |
| Despedida | "La luz de Sol le guíe, capitán." |

### Liga Rojana

| Contexto | Línea |
|:---------|:------|
| Saludo neutral | "Habla." |
| Saludo aliado | "[nombre]. Tus hazañas te preceden." |
| Misión | "Necesito a alguien sin miedo. ¿Eres ese alguien?" |
| Amenaza | "Huye antes de que te recuerde por qué soy peligrosa." |
| Agradecimiento | "Valor demostrado. No lo olvidaremos." |
| Despedida | "Que tu puntería sea certera." |

### Sindicato

| Contexto | Línea |
|:---------|:------|
| Saludo neutral | "Bienvenido. ¿Efectivo o crédito?" |
| Saludo aliado | "[nombre]! Oferta imperdible. Pase a mi oficina." |
| Misión | "Carga urgente, pago inmediato. ¿Trato?" |
| Amenaza | "Interfiriendo con comercio. El Sindicato cobra deudas." |
| Agradecimiento | "Transacción completada. Negocio redondo." |
| Despedida | "Ganancias altas, riesgos bajos." |

### Iglesia de la Resonancia

| Contexto | Línea |
|:---------|:------|
| Saludo neutral | "La Resonancia le observa. ¿Ha escuchado el pulso?" |
| Saludo aliado | "Hermano [nombre]. El Anillo late por usted." |
| Misión | "El Eco nos habló. Su fe en acción." |
| Amenaza | "Blasfemo. El Silencio lo consumirá." |
| Agradecimiento | "Su alma brilla más hoy." |
| Despedida | "Escuche el silencio." |

### Círculo Científico

| Contexto | Línea |
|:---------|:------|
| Saludo neutral | "Nave no registrada. ¿Datos de investigación?" |
| Saludo aliado | "[nombre]. Sus datos fueron fascinantes." |
| Misión | "Anomalía en [sistema]. Muestras. Riesgo alto. ¿Interesado?" |
| Amenaza | "Interfiriendo con investigación. Cese o reportamos." |
| Agradecimiento | "Datos recibidos. Conocimiento avanzado." |
| Despedida | "Siga mirando las estrellas." |

### Piratas

| Contexto | Línea |
|:---------|:------|
| Saludo neutral | "Cartera o vida." |
| Saludo aliado | "[nombre]! Tienes pelotas. La ronda la pago." |
| Misión | "Carguero Hegemónico en [sistema]. Escolta ligera. ¿Te apuntas?" |
| Amenaza | "Entrega todo o decoro el espacio con tus restos." |
| Agradecimiento | "Buen botín. Vuelve cuando quieras dinero de verdad." |
| Despedida | "No te mueras antes de gastarlo." |

### Culto del Vacío

| Contexto | Línea |
|:---------|:------|
| Cualquiera | (silencio) |
| Amenaza | "El Vacío te espera. Todos volvemos." |

## V2: SISTEMA CONTEXTUAL

```rust
enum DialogTrigger {
    EnterSystem, DockAtStation, AcceptMission, CompleteMission,
    KillShip, KillCount(u32), Discovery, LowHealth, LowFuel,
    HighBounty, FirstContact, EnterRestrictedZone,
}
```

**Reglas**: sin repetición en misma sesión, prioridad amenaza > misión > saludo, solo 1 cada 30s.

## V3: EVENTOS NARRATIVOS

| Evento | Trigger | Texto |
|:-------|:--------|:------|
| Ataque pirata | Baja seguridad | "¡Piratas! 3 naves rodean un carguero. [AYUDAR] [IGNORAR]" |
| Patrulla sospechosa | Sin licencia | "Patrulla solicita inspección. [ACEPTAR] [HUIR]" |
| Señal auxilio | Aleatorio | "Señal de auxilio. [INVESTIGAR] [IGNORAR]" |
| Descubrimiento | Primer escaneo | "Estructura no natural en superficie. [INVESTIGAR] [IGNORAR]" |
| Oferta misteriosa | Alta reputación | "Mensaje cifrado: coordenadas adjuntas. Venga solo. [ACUDIR] [IGNORAR]" |

---

*Diálogos: 7 facciones × 6 contextos = 42 líneas, sistema contextual con triggers, 5 eventos narrativos con decisión binaria.*
