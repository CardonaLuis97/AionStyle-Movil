# AionStyle Móvil

Aplicación Flutter para gestión de barberías: reserva de citas, pagos, QR y panel de barbero/propietario.

---

## 🚀 Setup inicial

### 1. Instalar Flutter
Descarga e instala Flutter SDK: https://docs.flutter.dev/get-started/install/windows

Verifica la instalación:
```bash
flutter doctor
```

### 2. Inicializar archivos nativos (Android / iOS)
Ejecuta **una sola vez** en la raíz del proyecto:
```bash
flutter create . --project-name aionstyle_movil --org com.aiondex --platforms android,ios
```
> Cuando pregunte si sobreescribir archivos existentes, responde **no** para conservar los ya creados.

### 3. Instalar dependencias
```bash
flutter pub get
```

### 4. Generar código (Freezed + json_serializable + Riverpod)
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. Fuentes tipográficas
Descarga **Poppins** desde https://fonts.google.com/specimen/Poppins  
Coloca los `.ttf` en `assets/fonts/`.

---

## 🏗 Arquitectura

```
Clean Architecture + Feature-First + MVVM
```

```
lib/
├── app/           → Router, Tema, Configuración
├── core/          → Red, Almacenamiento, Errores, Utilidades
└── features/
    └── {feature}/
        ├── datos/            → Modelos, Fuentes de datos, Repositorios impl.
        ├── dominio/          → Entidades, Repositorios (contrato), Casos de uso
        └── presentacion/     → Páginas, Widgets, Modelos Vista, Proveedores
```

## 📦 Stack tecnológico

| Capa | Tecnología |
|---|---|
| Estado | Riverpod |
| Navegación | GoRouter |
| HTTP | Dio |
| Modelos | Freezed + json_serializable |
| Almacenamiento seguro | flutter_secure_storage |
| Auth Google | google_sign_in |
| QR | mobile_scanner |
| Pagos | flutter_stripe |

## 🔑 Configuración
Edita `lib/app/config/configuracion_app.dart` para:
- URL base de la API (desarrollo / staging / producción)
- Clave pública de Stripe

---

## 🧪 Probar en local (modo desarrollo)

### 1. Preparar entorno en PowerShell (sesión actual)
```powershell
$env:PATH = "C:\flutter\bin;" + $env:PATH
cd D:\PROYECTOS\AiondeX\AionStyle-Movil
flutter pub get
```

### 2. Correr en web (Edge)
```powershell
flutter run -d edge
```

Opcional (puerto fijo):
```powershell
flutter run -d edge --web-port 7357
```

### 3. Correr en Windows desktop (si habilitas plataforma Windows)
Primera vez:
```powershell
flutter create . --platforms windows
```

Luego:
```powershell
flutter run -d windows
```

### 4. Correr en Android emulador/dispositivo
Ver dispositivos:
```powershell
flutter devices
```

Ejecutar en Android:
```powershell
flutter run -d android
```

### 5. Flujo rápido de desarrollo
- Hot reload: tecla r en la terminal donde corre flutter run
- Hot restart: tecla R
- Salir: tecla q

### 6. Si algo falla
```powershell
flutter clean
flutter pub get
flutter run -d edge
```

---

## 🚢 Despliegue (cuando quieras publicar)

Estos comandos son para generar builds de release. No afectan tu modo desarrollo.

### Web (release)
```bash
flutter build web --release
```
Salida: `build/web/`

### Android APK (release)
```bash
flutter build apk --release
```
Salida: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle para Play Store (release)
```bash
flutter build appbundle --release
```
Salida: `build/app/outputs/bundle/release/app-release.aab`

### iOS (release)
```bash
flutter build ios --release
```
Luego abre Xcode para firmar y publicar.

### Limpieza y rebuild completo (opcional)
```bash
flutter clean
flutter pub get
```
