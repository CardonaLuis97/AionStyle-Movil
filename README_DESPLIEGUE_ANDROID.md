# Despliegue Android - AionStyle

Guia para dejar el proyecto listo para generar el AAB en Android Studio y publicar en Play Console.

## 1) Requisitos

- Android Studio actualizado
- SDK de Android instalado (API 35 o la que pida tu entorno)
- JDK 17
- Flutter en PATH

Verificacion:

```bash
flutter doctor
```

## 2) Crear llave de firma (upload keystore)

Desde la raiz del proyecto, ejecuta:

```bash
keytool -genkeypair -v -keystore upload-keystore.jks -alias upload -keyalg RSA -keysize 2048 -validity 10000
```

Esto crea el archivo `upload-keystore.jks` en la raiz del proyecto.

## 3) Configurar key.properties

1. Copia `android/key.properties.example` a `android/key.properties`.
2. Completa valores reales en tu maquina local.

Contenido esperado:

```properties
storePassword=TU_STORE_PASSWORD
keyPassword=TU_KEY_PASSWORD
keyAlias=upload
storeFile=../upload-keystore.jks
```

Notas:
- `android/key.properties` no debe subirse al repositorio.
- `upload-keystore.jks` no debe subirse al repositorio.

## 4) Versionado para Play Store y para el login

Edita `pubspec.yaml` en esta linea:

```yaml
version: X.Y.Z+N
```

Significado:
- `X.Y.Z` = version visible para usuario (en login se muestra como `vX.Y.Z`)
- `N` = build interno para Play Store (`versionCode`) y siempre debe aumentar

Reglas obligatorias antes de cada subida:
- Si subes una nueva release a Play Store, aumenta `N` siempre (nunca repetirlo).
- Si hubo cambios funcionales visibles para usuarios, aumenta tambien `X.Y.Z`.
- Si solo fue ajuste interno sin impacto visible, puedes mantener `X.Y.Z` y subir solo `N`.

Ejemplos reales de despliegue:
- Release inicial: `version: 1.0.0+1` -> login muestra `v1.0.0`
- Correccion menor: `version: 1.0.1+2` -> login muestra `v1.0.1`
- Nueva funcionalidad: `version: 1.1.0+3` -> login muestra `v1.1.0`
- Cambio grande: `version: 2.0.0+10` -> login muestra `v2.0.0`

Checklist rapido de versionado por release:
1. Editar `pubspec.yaml` y actualizar `version: X.Y.Z+N`.
2. Validar que `N` sea mayor al ultimo subido en Play Console.
3. Ejecutar `flutter pub get`.
4. Generar AAB release.

## 5) Configuracion de Android ya preparada

Este proyecto ya esta preparado para usar firma release via `android/key.properties` en:

- `android/app/build.gradle.kts`

Si `key.properties` existe, usa firma release.
Si no existe, usa firma debug para pruebas locales.

## 6) Validar compilacion release

En terminal, desde la raiz:

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

Salida esperada:

- `build/app/outputs/bundle/release/app-release.aab`

## 7) Generar AAB desde Android Studio

1. Abrir carpeta `android/` en Android Studio.
2. Esperar sincronizacion de Gradle.
3. Ir a Build > Generate Signed Bundle / APK.
4. Elegir Android App Bundle.
5. Seleccionar:
   - Keystore path: `upload-keystore.jks`
   - Alias: `upload`
6. Build type: `release`.
7. Confirmar y generar.

## 8) Subida a Play Console

1. Crear aplicacion en Play Console.
2. Ir a Testing interno o Produccion.
3. Crear release y subir `app-release.aab`.
4. Completar checklist:
   - Politica de privacidad (URL)
   - Data Safety
   - Clasificacion de contenido
   - Publico objetivo
   - Ficha de Play Store (icono, descripcion, capturas)

## 9) Problemas frecuentes

- Error de firma: revisa `android/key.properties` y ruta de `storeFile`.
- Error de versionCode repetido: aumenta el `+N` en `pubspec.yaml`.
- Error de SDK/Gradle: ejecuta `flutter doctor` y sincroniza Gradle.

## 10) Comando rapido final

```bash
flutter build appbundle --release
```

Si termina sin error, el AAB esta listo para Play Store.
