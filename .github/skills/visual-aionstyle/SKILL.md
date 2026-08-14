---
name: visual-aionstyle
description: "Diseño visual de AionStyle Móvil. Úsame cuando crees o modifiques Widgets, colores, tipografía, estilos de botones, cards, barras de navegación o cualquier elemento visual. Aplica la paleta global (primario/secundario/terceario) y las guías de UI/UX de la app."
---

# SKILL: Visual AionStyle

## Cuándo se aplica

- Crear o editar cualquier Widget de presentacion
- Definir colores, tipografía o tamaños
- Diseñar páginas, cards, botones, formularios, navegación
- Revisar que ningún color esté hardcodeado

---

## Paleta de colores global

**Siempre** usa la clase `ColoresApp` de `lib/app/theme/colores.dart`. Nunca hardcodees valores de color.

| Token semántico | Uso |
|----------------|-----|
| `ColoresApp.primario` | Color principal de la app (negro por defecto) |
| `ColoresApp.secundario` | Color de contraste / fondos claros (blanco por defecto) |
| `ColoresApp.terceario` | Elementos neutros / secundarios (gris por defecto) |
| `ColoresApp.acento` | Llamadas a la acción, highlights |
| `ColoresApp.exito` | Confirmaciones, pagos exitosos |
| `ColoresApp.error` | Errores, cancelaciones |
| `ColoresApp.advertencia` | Alertas, estados pendientes |
| `ColoresApp.texto` | Texto principal sobre fondo claro |
| `ColoresApp.textoClaro` | Texto secundario, hints |
| `ColoresApp.fondo` | Fondo general de pantallas |

> Para cambiar la paleta de la app, edita únicamente `colores.dart` — el resto de la app se actualiza automáticamente.

---

## Reglas de diseño

1. **Nunca** escribir `Color(0xFF...)`, `Colors.black`, `Colors.white` directamente en widgets
2. Usar siempre el tema de la app vía `Theme.of(context)` para textStyles base
3. Los botones primarios van con `ColoresApp.primario` de fondo y `ColoresApp.secundario` como texto
4. Los botones secundarios van con fondo transparente, borde `ColoresApp.primario` y texto `ColoresApp.primario`
5. Las cards usan `ColoresApp.secundario` de fondo con sombra sutil (elevación 2–4)

---

## Tipografía

Fuente base: **Poppins** (definida en `pubspec.yaml` y `tema.dart`)

| Jerarquía | Uso recomendado |
|-----------|----------------|
| `titleLarge` | Títulos de página |
| `titleMedium` | Títulos de sección / nombre de barbería |
| `bodyLarge` | Texto principal |
| `bodyMedium` | Texto secundario |
| `labelLarge` | Texto de botones |
| `labelSmall` | Etiquetas pequeñas, badges |

---

## Separación visual por categoría de negocio

La app muestra **barberías** y **salones de belleza** en la misma pantalla pero separados visualmente.
Usa el campo `categoria` de la entidad negocio para aplicar:

| Categoría | Indicador visual sugerido |
|-----------|--------------------------|
| `barberia` | Badge / tag con `ColoresApp.primario` |
| `salon_belleza` | Badge / tag con `ColoresApp.acento` |

---

## Estructura de un Widget correcto

```dart
// Ejemplo de card de negocio
Container(
  color: ColoresApp.secundario,
  child: Text(
    negocio.nombre,
    style: Theme.of(context).textTheme.titleMedium?.copyWith(
      color: ColoresApp.primario,
    ),
  ),
)
```

---

## Checklist antes de marcar un Widget como completo

- [ ] No hay colores hardcodeados
- [ ] Se usa `ColoresApp.*` para todos los colores
- [ ] Tipografía usando `Theme.of(context).textTheme.*`
- [ ] El Widget funciona en modo claro (no hay contraste roto con `ColoresApp.secundario` como fondo)
