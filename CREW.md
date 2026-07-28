# Sistema de Tripulación — *No Vuelas Solo*

> Contratación, gestión, habilidades, lealtad, y muerte de tripulantes
> Cada miembro es un individuo con historia, personalidad, y habilidades únicas

---

## VOLUMEN 1: FILOSOFÍA

Tu tripulación no es un bonus estadístico. Son personas con nombres, historias, y motivaciones propias. Pueden morir. Pueden traicionarte. Pueden volverse leyendas.

- Cada tripulante tiene nombre generado proceduralmente
- Cada tripulante tiene personalidad (5 arquetipos)
- Cada tripulante tiene habilidades que mejoran con el tiempo
- La tripulación cuesta créditos (sueldos) y requiere espacio vital
- Tripulantes descontentos se van (o se revelan)

---

## VOLUMEN 2: TIPOS DE TRIPULANTE

### Roles de Tripulación

| Rol | Clase mínima de nave | Sueldo base/día | Efecto principal |
|:---:|:--------------------:|:---------------:|------------------|
| **Piloto** | I | 200cr | +velocidad, +maniobra |
| **Ingeniero** | II | 250cr | −desgaste, +eficiencia |
| **Artillero** | II | 200cr | +precisión, +daño |
| **Médico** | III | 300cr | Recuperación tripulación, tratar heridas |
| **Científico** | III | 350cr | +datos, +análisis |
| **Marine** | III | 250cr | Defensa en abordajes, ataque en abordajes |
| **Comerciante** | II | 200cr | +precio venta, −precio compra |
| **Navegante** | I | 150cr | −combustible por salto, rutas óptimas |
| **Operador de guerra electrónica** | III | 300cr | +sigilo, +contramedidas |
| **Capitán** (NPC) | IV | 500cr | +moral, +liderazgo (automatiza la nave si tú no estás) |

---

## VOLUMEN 3: GENERACIÓN DE TRIPULANTES

Cada tripulante se genera con:

```rust
struct CrewMember {
    id: u32,
    name: String,            // nombre generado
    species: RaceId,         // especie
    age: u8,                 // 20–80 años
    background: Background,  // historia previa
    personality: Personality, // 5 arquetipos
    role: CrewRole,
    skills: Vec<Skill>,      // habilidades específicas
    level: u8,               // 1–20
    experience: f64,         // XP hacia siguiente nivel
    salary: f64,             // créditos/día
    loyalty: f32,            // 0.0–1.0
    morale: f32,             // 0.0–1.0
    health: f32,             // 0.0–1.0
    special_trait: Option<Trait>, // rasgo único
}
```

### Arquetipos de Personalidad

| Arquetipo | Efecto en lealtad | Efecto en moral | Diálogos |
|:---------:|:-----------------:|:---------------:|----------|
| **Leal** | +0.1/día, nunca traiciona | +5% moral grupal | "Estoy aquí hasta el final, capitán." |
| **Ambicioso** | −0.05/día si no asciende | +10% cuando gana nivel | "¿Cuándo me toca ser jefe de sala?" |
| **Cobarde** | +0.1 cuando no hay peligro | −20% en combate | "¿Seguro que tenemos que ir por ahí?" |
| **Fanático** | +0.2 si compartes su facción | +10% en combate | "¡Por la gloria de la Liga!" |
| **Mercenario** | −0.1/día, +0.3 si le pagas extra | No afecta | "Mientras pagues, no me quejo." |

### Trasfondos (Backgrounds)

| Trasfondo | Efecto |
|-----------|--------|
| **Ex-militar Hegemónico** | +1 nivel inicial en combate, +10 lealtad a facciones Hegemónicas |
| **Minero arruinado** | +1 nivel inicial en minería, −10% sueldo pedido inicial |
| **Científico del Círculo** | +1 nivel inicial en ciencia, pide 20% más sueldo |
| **Prófugo pirata** | +1 nivel inicial en combate/sigilo, −20 lealtad a facciones |
| **Refugiado de frontera** | −20% sueldo pedido, +1 nivel en supervivencia |
| **Ingeniero de astillero** | +2 niveles iniciales en ingeniería |
| **Navegante hereditario** | −10% consumo combustible, +1 nivel navegación |
| **Médico de guerra** | +2 niveles medicina, −20% moral en combate |

---

## VOLUMEN 4: GESTIÓN DE TRIPULACIÓN

### Contratación

| Fuente | Coste | Riesgo | Tiempo |
|--------|:-----:|:------:|:------:|
| Bolsa de trabajo (estación) | 1K–5K | Bajo | 1h |
| Contacto personal | 0 (si tienes reputación) | Bajo | Variable |
| Rescate de prisioneros | 0 (misiones) | Alto | Durante misión |
| Reclutamiento pirata | 0 (pero requieren prueba) | Alto | 1 misión |
| Mercado de esclavos (ilegal) | −50% sueldo | Muy alto (legal) | 1h |
| Academia de facción | 10K–50K | Ninguno | 7 días reales |

### Sueldos y Costes

| Nivel del tripulante | Sueldo base/día | Multiplicador por nivel |
|:--------------------:|:---------------:|:----------------------:|
| 1–5 (Novato) | 100–300cr | 1.0× |
| 6–10 (Experimentado) | 300–800cr | 1.5× |
| 11–15 (Veterano) | 800–2,000cr | 2.0× |
| 16–20 (Leyenda) | 2,000–5,000cr | 3.0× |

Coste total mensual estimado para tripulación completa:

| Clase de nave | Tripulación mínima | Tripulación óptima | Coste mensual (óptima) |
|:-------------:|:------------------:|:------------------:|:----------------------:|
| I (Caza) | 1 | 1 | 3K–6K |
| II (Corbeta) | 2 | 3 | 10K–20K |
| III (Fragata) | 4 | 8 | 30K–80K |
| IV (Destructor) | 10 | 20 | 100K–300K |
| V (Crucero) | 30 | 60 | 500K–1.5M |
| VI (Acorazado) | 100 | 200 | 2M–6M |
| VII (Portanaves) | 200 | 500 | 5M–15M |

---

## VOLUMEN 5: MORAL Y LEALTAD

### Factores que Afectan la Moral

| Evento | Cambio en moral |
|--------|:---------------:|
| Combate ganado | +5% |
| Combate perdido (huida) | −10% |
| Tripulante muerto | −15% (toda la tripulación) |
| Victoria decisiva | +10% |
| Pago puntual de sueldos | +2% |
| Sueldo atrasado 1 día | −5% |
| Sueldo atrasado 5 días | −20% + posible motín |
| Buena alimentación | +1% día |
| Mala alimentación | −2% día |
| Estación con permisos | +5% |
| Derrota humillante | −25% |

### Factores que Afectan la Lealtad

| Evento | Cambio en lealtad |
|--------|:-----------------:|
| Salvar la vida del tripulante | +0.15 |
| Ignorar sus consejos seguido | −0.05/vez |
| Ascenderlo de rango | +0.10 |
| Comprarle equipo personal | +0.05 |
| Dejarlo morir (escapar sin él) | −0.30 |
| Compartir botín generosamente | +0.10 |
| Pagar extra (bonus) | +0.05 |
| Mentirle | −0.20 si descubre |

### Estados de Lealtad

| Lealtad | Estado | Comportamiento |
|:-------:|--------|---------------|
| 0.8–1.0 | Devoto | Permanece contigo en cualquier situación |
| 0.5–0.8 | Leal | Obedece órdenes, puede quejarse pero no traiciona |
| 0.3–0.5 | Neutral | Cumple su trabajo, pero no arriesga su vida |
| 0.1–0.3 | Descontento | Puede negarse a órdenes peligrosas, busca otra oferta |
| 0.0–0.1 | Rebelde | Motín, fuga, sabotaje, o traición |

---

## VOLUMEN 6: MUERTE Y REEMPLAZO

### Cuando un Tripulante Muere

1. Pérdida permanente: el tripulante desaparece del juego
2. Moral grupal: −15%
3. Puedes encontrar un reemplazo en la estación más cercana
4. El reemplazo siempre es de nivel −2 respecto al fallecido (los novatos son más baratos)

### Funeral Espacial (Opción RPG)

Si el jugador lo desea, puede realizar un funeral espacial (animación de 30s, cuerpo eyectado al vacío). Esto da +5% moral a la tripulación restante (sentido de honor).

---

## VOLUMEN 7: TRIPULACIÓN AUTOMÁTICA (AI)

Si no quieres gestionar tripulación, puedes contratar un **Núcleo de IA de Gestión** (500K créditos, requiere ranura de electrónica). La IA:

- Tripula la nave con bots mínimos (−50% eficiencia, −80% coste)
- Nunca se queja, nunca traiciona
- No sube de nivel
- Es detectable por sensores (+20% firma)

---

*Sistema de Tripulación completo: 10 roles, generación procedural con personalidad y trasfondo, sistema de moral y lealtad con factores detallados, costes por clase de nave, reglas de muerte y reemplazo.*
