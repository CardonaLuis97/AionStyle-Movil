import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/colores.dart';
import '../../../../app/router/enrutador.dart';
import '../../../../app/widgets/logo_aionstyle.dart';
import '../modelos_vista/estado_auth.dart';
import '../proveedores/proveedores_auth.dart';
import '../widgets/campo_email.dart';
import '../widgets/campo_contrasena.dart';
import '../widgets/boton_google.dart';

class PaginaLogin extends ConsumerStatefulWidget {
  const PaginaLogin({super.key});

  @override
  ConsumerState<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends ConsumerState<PaginaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _contrasenaCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _contrasenaCtrl.dispose();
    super.dispose();
  }

  Future<void> _loginConCorreo() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(viewModelAuthProvider.notifier).loginConCorreo(
          correo: _emailCtrl.text.trim(),
          contrasena: _contrasenaCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(viewModelAuthProvider);
    final tema = Theme.of(context);

    ref.listen<EstadoAuth>(viewModelAuthProvider, (_, siguiente) {
      siguiente.maybeWhen(
        autenticado: (_) => context.go(Rutas.inicio),
        perfilIncompleto: (_) => context.go(Rutas.completarPerfil),
        error: (msg) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg))),
        orElse: () {},
      );
    });

    return Scaffold(
      backgroundColor: ColoresApp.primario,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                children: [
                  const SizedBox(height: 36),
                  const LogoAionStyle(ancho: 250, alto: 200),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.fromLTRB(28, 30, 28, 28),
                    decoration: const BoxDecoration(
                      color: ColoresApp.acento,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(42),
                        topRight: Radius.circular(42),
                        bottomLeft: Radius.circular(34),
                        bottomRight: Radius.circular(34),
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Inicia sesión en tu cuenta',
                            style: tema.textTheme.titleLarge?.copyWith(
                              color: ColoresApp.primario,
                              fontWeight: FontWeight.w700,
                              fontSize: 36,
                            ),
                          ),
                          const SizedBox(height: 30),
                          CampoEmail(
                            controlador: _emailCtrl,
                            mostrarIcono: false,
                          ),
                          const SizedBox(height: 14),
                          CampoContrasena(
                            controlador: _contrasenaCtrl,
                            mostrarIcono: false,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: estado.maybeWhen(
                              cargando: () => null,
                              orElse: () => _loginConCorreo,
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(58),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: estado.maybeWhen(
                              cargando: () => const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: ColoresApp.secundario,
                                ),
                              ),
                              orElse: () => Text(
                                'Iniciar sesión',
                                style: tema.textTheme.labelLarge?.copyWith(
                                  color: ColoresApp.secundario,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: ColoresApp.primario,
                                  thickness: 1.2,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                child: Text(
                                  'o',
                                  style: tema.textTheme.titleMedium?.copyWith(
                                    color: ColoresApp.primario,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: ColoresApp.primario,
                                  thickness: 1.2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          BotonGoogle(
                            onPresionado: estado.maybeWhen(
                              cargando: () => null,
                              orElse: () => () => ref
                                  .read(viewModelAuthProvider.notifier)
                                  .loginConGoogle(),
                            ),
                          ),
                          const SizedBox(height: 18),
                          TextButton(
                            onPressed: () => context.push(Rutas.registro),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: tema.textTheme.titleMedium?.copyWith(
                                  color: ColoresApp.primario,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 19,
                                ),
                                children: const [
                                  TextSpan(text: 'No tienes cuenta '),
                                  TextSpan(
                                    text: 'Regístrate',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
