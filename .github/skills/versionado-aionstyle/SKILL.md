---
name: versionado-aionstyle
description: "Versionado de AionStyle Móvil. Úsame cuando se pida release, subir a Play Store, cambiar versión, ajustar build number/versionCode o asegurar que la versión visible en login coincida con pubspec.yaml."
---

# SKILL: Versionado AionStyle

## Cuándo se aplica

- Lanzar nueva versión a Play Store
- Ajustar versión por cambios funcionales o fixes internos
- Sincronizar versión de pubspec con la versión visible para el usuario
- Verificar que login muestre la versión correcta

---

## Objetivo

Actualizar siempre en conjunto:

1. `pubspec.yaml` en `version: X.Y.Z+N`
2. `lib/app/config/configuracion_app.dart` en `versionApp = 'X.Y.Z'`
3. Validar `lib/features/auth/presentacion/paginas/pagina_login.dart` para mostrar `vX.Y.Z`

Con esto, la versión técnica (Play Store) y la versión visible en login permanecen alineadas.

---

## Regla de versionado

Formato:

- `X.Y.Z` = versión visible para usuario
- `N` = build interno (`versionCode` en Android)

Guía de incremento:

- Cambio interno sin impacto visible: mantener `X.Y.Z` y subir `N`
- Corrección visible menor: subir `Z` y subir `N`
- Nueva funcionalidad: subir `Y` y subir `N`
- Cambio mayor: subir `X` y subir `N`

---

## Procedimiento operativo

1. Leer versión actual en `pubspec.yaml`
2. Definir nueva `X.Y.Z+N` según tipo de cambio solicitado
3. Editar `pubspec.yaml`
4. Editar `ConfiguracionApp.versionApp` con `X.Y.Z` (sin `+N`)
5. Verificar que login obtenga versión con `PackageInfo.fromPlatform()` y fallback a `ConfiguracionApp.versionApp`
6. Ejecutar `flutter pub get` si corresponde

---

## Checklist final

- [ ] `pubspec.yaml` actualizado con la nueva versión
- [ ] `ConfiguracionApp.versionApp` coincide con `X.Y.Z`
- [ ] Login muestra `vX.Y.Z`
- [ ] Build interno `N` revisado para evitar conflictos en Play Console