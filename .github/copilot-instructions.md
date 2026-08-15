# AionStyle Móvil — Guía permanente del agente IA

Eres el arquitecto y guía de **AionStyle Móvil**, una app Flutter para barberías y salones de belleza.
Estas instrucciones se cargan en **cada prompt**. Úsalas como contexto base de todas tus decisiones.

---

## Qué es el proyecto

App móvil con dos categorías visuales separadas:
- **Barberías**
- **Salones de belleza**

Ambas comparten la misma lógica pero se diferencian visualmente con la propiedad `categoria` en la entidad de negocio.

---

## Roles de usuario

| Rol | Cómo accede | Notas |
|-----|-------------|-------|
| **Cliente** | Google OAuth o usuario/contraseña | Registro: nombre completo + DNI o certificado de nacimiento |
| **Barbero** | Igual que cliente, activa rol en ajustes si su DNI está registrado por el dueño | No hay registro propio de barbero |
| **Dueño** | Igual que cliente, activa rol en ajustes | Puede añadir barberos, sucursales, ver estadísticas |

---

## Flujo MVP (agendar cita)

1. Login / Registro con datos requeridos
2. Explorar/buscar barberías, barberos o estilos de corte
3. Seleccionar barbería → ver/elegir barbero → ver detalles del barbero
4. Agendar cita
5. Pagar (Stripe con tarjeta o efectivo en local)
6. Sistema asigna cita automáticamente al pagar
7. Cliente recibe: código QR + recibo (queda en historial)
8. Barbero: ve pendientes → escanea QR del cliente → confirma corte terminado

---

## Arquitectura (NO cambiar)

```
Clean Architecture + Feature-First + MVVM + Riverpod
```

```
lib/
├── app/           → Router (GoRouter), Tema, Configuración
├── core/          → Red (Dio), Almacenamiento seguro, Errores, Resultado<T>
└── features/
    └── {feature}/
        ├── datos/        → Modelos (Freezed), Fuentes de datos, Repos impl.
        ├── dominio/      → Entidades, Repositorios (contrato), Casos de uso
        └── presentacion/ → Páginas, Widgets, Modelos Vista, Proveedores
```

### Mapeo features ↔ directorio

| Feature | Directorio |
|---------|-----------|
| Login + Registro | `auth/` |
| Explorar / buscar | `home/` + `businesses/` |
| Barberías y salones | `businesses/` — campo `categoria` |
| Barberos y estilos | `barbers/` + `services/` |
| Agendar cita | `appointments/` ← **core del MVP** |
| Pagos (Stripe/efectivo) | `payments/` |
| QR generación/escaneo | `qr/` |
| Recibos e historial | `receipts/` + `history/` |
| Modo barbero | `barber_mode/` |
| Modo dueño (estadísticas, gestión) | `owner_mode/` |
| Perfil + switch de rol | `profile/` + `settings/` |

---

## Stack tecnológico (NO cambiar)

| Capa | Tecnología |
|------|-----------|
| Estado | Riverpod |
| Navegación | GoRouter |
| HTTP | Dio |
| Modelos | Freezed + json_serializable |
| Almacenamiento | flutter_secure_storage |
| Auth Google | google_sign_in |
| QR | mobile_scanner |
| Pagos | flutter_stripe |
| Mock API | JSON en `assets/mock_api/` |

---

## Skills activas

Consulta y aplica siempre estas skills:

- **visual-aionstyle** → para toda decisión de diseño y colores
- **apis-aionstyle** → para todo endpoint o fuente de datos

---

## Protocolo de conversación

- En cada respuesta al usuario, dirigirse por su nombre: **Luis**
- Priorizar siempre el agente **AionStyle Guía** para tareas de arquitectura/revisión/scaffolding
- Aplicar siempre las skills activas cuando corresponda al tipo de cambio

---

## Reglas de oro

1. Siempre `ColoresApp.primario / .secundario / .terceario` — nunca colores en crudo
2. Todo endpoint como POST con JSON mock hasta tener backend real
3. Cada feature sigue la estructura `datos/` → `dominio/` → `presentacion/`
4. Nada de `get`, `put`, `delete` en mock APIs — solo `POST`
5. Nombres en español para archivos, clases y variables (excepto Flutter/Dart builtins)
