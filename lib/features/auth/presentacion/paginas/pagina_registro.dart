import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/enrutador.dart';
import '../../../../app/theme/colores.dart';
import '../../../../core/utils/ubicacion_obligatoria.dart';
import '../../dominio/entidades/tipo_documento.dart';
import '../modelos_vista/estado_auth.dart';
import '../proveedores/proveedores_auth.dart';
import '../widgets/campo_contrasena.dart';

class PaginaRegistro extends ConsumerStatefulWidget {
  const PaginaRegistro({super.key});

  @override
  ConsumerState<PaginaRegistro> createState() => _PaginaRegistroState();
}

class _PaginaRegistroState extends ConsumerState<PaginaRegistro> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _documentoCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _contrasenaCtrl = TextEditingController();
  final _confirmarCtrl = TextEditingController();
  String _codigoPaisSeleccionado = '+504';
  TipoDocumento _tipoDocumento = TipoDocumento.dni;
  bool _redirigiendoInicio = false;

  Future<void> _abrirSelectorPais() async {
    final busquedaCtrl = TextEditingController();
    var resultados = List<_CodigoPais>.from(_codigosPais);

    final seleccionado = await showModalBottomSheet<_CodigoPais>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColoresApp.primario,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: busquedaCtrl,
                      autofocus: true,
                      style: const TextStyle(color: ColoresApp.secundario),
                      decoration: const InputDecoration(
                        labelText: 'Buscar país',
                        labelStyle: TextStyle(color: ColoresApp.secundario),
                        hintStyle: TextStyle(color: ColoresApp.secundario),
                        filled: true,
                        fillColor: ColoresApp.primario,
                        prefixIcon: Icon(
                          Icons.search,
                          color: ColoresApp.secundario,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColoresApp.dorado),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: ColoresApp.dorado,
                            width: 1.6,
                          ),
                        ),
                      ),
                      onChanged: (valor) {
                        final q = valor.trim().toLowerCase();
                        setModalState(() {
                          resultados = _codigosPais
                              .where(
                                (item) =>
                                    item.pais.toLowerCase().contains(q) ||
                                    item.codigo.toLowerCase().contains(q),
                              )
                              .toList();
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 320,
                      child: resultados.isEmpty
                          ? const Center(
                              child: Text(
                                'No se encontraron países.',
                                style: TextStyle(color: ColoresApp.dorado),
                              ),
                            )
                          : ListView.builder(
                              itemCount: resultados.length,
                              itemBuilder: (context, index) {
                                final item = resultados[index];
                                return ListTile(
                                  tileColor:
                                      ColoresApp.primario,
                                  title: Text(
                                    item.pais,
                                    style: const TextStyle(
                                      color: ColoresApp.dorado,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    item.codigo,
                                    style: const TextStyle(
                                      color: ColoresApp.dorado,
                                    ),
                                  ),
                                  onTap: () => Navigator.of(context).pop(item),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    busquedaCtrl.dispose();

    if (seleccionado != null && mounted) {
      setState(() {
        _codigoPaisSeleccionado = seleccionado.codigo;
      });
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _documentoCtrl.dispose();
    _telefonoCtrl.dispose();
    _correoCtrl.dispose();
    _contrasenaCtrl.dispose();
    _confirmarCtrl.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;
    final documentoLimpio = _documentoCtrl.text.replaceAll('-', '');
    final telefonoLocal = _telefonoCtrl.text.trim();
    final telefonoCompleto = '$_codigoPaisSeleccionado $telefonoLocal';
    await ref.read(viewModelAuthProvider.notifier).registrar(
          nombreCompleto: _nombreCtrl.text.trim(),
          tipoDocumento: _tipoDocumento,
          numeroDocumento: documentoLimpio,
          telefono: telefonoCompleto,
          correo: _correoCtrl.text.trim(),
          contrasena: _contrasenaCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(viewModelAuthProvider);

    ref.listen<EstadoAuth>(viewModelAuthProvider, (_, siguiente) {
      siguiente.maybeWhen(
        autenticado: (_) async {
          if (_redirigiendoInicio) return;
          _redirigiendoInicio = true;
          final permitido = await exigirUbicacionAntesDeInicio(context);
          if (!mounted) return;
          if (permitido) {
            context.go(Rutas.inicio);
          }
          _redirigiendoInicio = false;
        },
        error: (msg) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg))),
        orElse: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
        backgroundColor: ColoresApp.primario,
        foregroundColor: ColoresApp.secundario,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nombreCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Ingresa tu nombre completo' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TipoDocumento>(
                  initialValue: _tipoDocumento,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de documento',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  items: TipoDocumento.values
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(t.etiqueta),
                          ))
                      .toList(),
                  onChanged: (valor) {
                    if (valor != null) setState(() => _tipoDocumento = valor);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _documentoCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Número de documento',
                    prefixIcon: Icon(Icons.numbers_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(13),
                    _FormateadorDocumentoDni(),
                  ],
                  validator: (v) {
                    final limpio = (v ?? '').replaceAll('-', '');
                    if (limpio.isEmpty) {
                      return 'Ingresa tu número de documento';
                    }
                    if (!RegExp(r'^\d{13}$').hasMatch(limpio)) {
                      return 'Debe contener 13 dígitos';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        key: ValueKey(_codigoPaisSeleccionado),
                        initialValue: _codigoPaisSeleccionado,
                        readOnly: true,
                        onTap: _abrirSelectorPais,
                        decoration: InputDecoration(
                          labelText: 'Código país',
                          prefixIcon: const Icon(Icons.flag_outlined),
                          suffixIcon: const Icon(Icons.keyboard_arrow_down),
                          hintText: 'Selecciona un país',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        controller: _telefonoCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Número de celular',
                          hintText: '3348-1474',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(8),
                          _FormateadorTelefonoLocal(),
                        ],
                        validator: (v) {
                          final limpio = (v ?? '').replaceAll('-', '');
                          if (limpio.isEmpty) {
                            return 'Ingresa tu celular';
                          }
                          if (!RegExp(r'^\d{8}$').hasMatch(limpio)) {
                            return 'Debe contener 8 dígitos';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _correoCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (v) {
                    final correo = (v ?? '').trim();
                    if (correo.isEmpty) return 'Ingresa tu correo';
                    if (!correo.contains('@') || !correo.contains('.')) {
                      return 'Debe contener @ y .';
                    }
                    if (!RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$')
                        .hasMatch(correo)) {
                      return 'Correo inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CampoContrasena(controlador: _contrasenaCtrl),
                const SizedBox(height: 16),
                CampoContrasena(
                  controlador: _confirmarCtrl,
                  etiqueta: 'Confirmar contraseña',
                  validador: (v) => v != _contrasenaCtrl.text
                      ? 'Las contraseñas no coinciden'
                      : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: estado.maybeWhen(
                    cargando: () => null,
                    orElse: () => _registrar,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColoresApp.dorado,
                    foregroundColor: ColoresApp.primario,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: estado.maybeWhen(
                    cargando: () => const CircularProgressIndicator(
                      color: ColoresApp.secundario,
                    ),
                    orElse: () => const Text('Crear cuenta'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormateadorDocumentoDni extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitos = newValue.text.replaceAll('-', '');
    final buffer = StringBuffer();

    for (var i = 0; i < digitos.length; i++) {
      if (i == 4 || i == 8) {
        buffer.write('-');
      }
      buffer.write(digitos[i]);
    }

    final texto = buffer.toString();
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}

class _FormateadorTelefonoLocal extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitos = newValue.text.replaceAll('-', '');
    final buffer = StringBuffer();

    for (var i = 0; i < digitos.length; i++) {
      if (i == 4) {
        buffer.write('-');
      }
      buffer.write(digitos[i]);
    }

    final texto = buffer.toString();
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}

class _CodigoPais {
  const _CodigoPais({required this.pais, required this.codigo});

  final String pais;
  final String codigo;
}

const List<_CodigoPais> _codigosPais = [
  _CodigoPais(pais: 'Afganistan', codigo: '+93'),
  _CodigoPais(pais: 'Albania', codigo: '+355'),
  _CodigoPais(pais: 'Alemania', codigo: '+49'),
  _CodigoPais(pais: 'Andorra', codigo: '+376'),
  _CodigoPais(pais: 'Angola', codigo: '+244'),
  _CodigoPais(pais: 'Antigua y Barbuda', codigo: '+1-268'),
  _CodigoPais(pais: 'Arabia Saudita', codigo: '+966'),
  _CodigoPais(pais: 'Argelia', codigo: '+213'),
  _CodigoPais(pais: 'Argentina', codigo: '+54'),
  _CodigoPais(pais: 'Armenia', codigo: '+374'),
  _CodigoPais(pais: 'Australia', codigo: '+61'),
  _CodigoPais(pais: 'Austria', codigo: '+43'),
  _CodigoPais(pais: 'Azerbaiyan', codigo: '+994'),
  _CodigoPais(pais: 'Bahamas', codigo: '+1-242'),
  _CodigoPais(pais: 'Banglades', codigo: '+880'),
  _CodigoPais(pais: 'Barbados', codigo: '+1-246'),
  _CodigoPais(pais: 'Belgica', codigo: '+32'),
  _CodigoPais(pais: 'Belice', codigo: '+501'),
  _CodigoPais(pais: 'Benin', codigo: '+229'),
  _CodigoPais(pais: 'Bielorrusia', codigo: '+375'),
  _CodigoPais(pais: 'Bolivia', codigo: '+591'),
  _CodigoPais(pais: 'Bosnia y Herzegovina', codigo: '+387'),
  _CodigoPais(pais: 'Botsuana', codigo: '+267'),
  _CodigoPais(pais: 'Brasil', codigo: '+55'),
  _CodigoPais(pais: 'Brunei', codigo: '+673'),
  _CodigoPais(pais: 'Bulgaria', codigo: '+359'),
  _CodigoPais(pais: 'Burkina Faso', codigo: '+226'),
  _CodigoPais(pais: 'Burundi', codigo: '+257'),
  _CodigoPais(pais: 'Cabo Verde', codigo: '+238'),
  _CodigoPais(pais: 'Camboya', codigo: '+855'),
  _CodigoPais(pais: 'Camerun', codigo: '+237'),
  _CodigoPais(pais: 'Canada', codigo: '+1'),
  _CodigoPais(pais: 'Catar', codigo: '+974'),
  _CodigoPais(pais: 'Chad', codigo: '+235'),
  _CodigoPais(pais: 'Chile', codigo: '+56'),
  _CodigoPais(pais: 'China', codigo: '+86'),
  _CodigoPais(pais: 'Chipre', codigo: '+357'),
  _CodigoPais(pais: 'Colombia', codigo: '+57'),
  _CodigoPais(pais: 'Comoras', codigo: '+269'),
  _CodigoPais(pais: 'Corea del Norte', codigo: '+850'),
  _CodigoPais(pais: 'Corea del Sur', codigo: '+82'),
  _CodigoPais(pais: 'Costa de Marfil', codigo: '+225'),
  _CodigoPais(pais: 'Costa Rica', codigo: '+506'),
  _CodigoPais(pais: 'Croacia', codigo: '+385'),
  _CodigoPais(pais: 'Cuba', codigo: '+53'),
  _CodigoPais(pais: 'Dinamarca', codigo: '+45'),
  _CodigoPais(pais: 'Dominica', codigo: '+1-767'),
  _CodigoPais(pais: 'Ecuador', codigo: '+593'),
  _CodigoPais(pais: 'Egipto', codigo: '+20'),
  _CodigoPais(pais: 'El Salvador', codigo: '+503'),
  _CodigoPais(pais: 'Emiratos Arabes Unidos', codigo: '+971'),
  _CodigoPais(pais: 'Eritrea', codigo: '+291'),
  _CodigoPais(pais: 'Eslovaquia', codigo: '+421'),
  _CodigoPais(pais: 'Eslovenia', codigo: '+386'),
  _CodigoPais(pais: 'Espana', codigo: '+34'),
  _CodigoPais(pais: 'Estados Unidos', codigo: '+1'),
  _CodigoPais(pais: 'Estonia', codigo: '+372'),
  _CodigoPais(pais: 'Etiopia', codigo: '+251'),
  _CodigoPais(pais: 'Filipinas', codigo: '+63'),
  _CodigoPais(pais: 'Finlandia', codigo: '+358'),
  _CodigoPais(pais: 'Fiyi', codigo: '+679'),
  _CodigoPais(pais: 'Francia', codigo: '+33'),
  _CodigoPais(pais: 'Gabon', codigo: '+241'),
  _CodigoPais(pais: 'Gambia', codigo: '+220'),
  _CodigoPais(pais: 'Georgia', codigo: '+995'),
  _CodigoPais(pais: 'Ghana', codigo: '+233'),
  _CodigoPais(pais: 'Granada', codigo: '+1-473'),
  _CodigoPais(pais: 'Grecia', codigo: '+30'),
  _CodigoPais(pais: 'Guatemala', codigo: '+502'),
  _CodigoPais(pais: 'Guinea', codigo: '+224'),
  _CodigoPais(pais: 'Guinea-Bisau', codigo: '+245'),
  _CodigoPais(pais: 'Guinea Ecuatorial', codigo: '+240'),
  _CodigoPais(pais: 'Guyana', codigo: '+592'),
  _CodigoPais(pais: 'Haiti', codigo: '+509'),
  _CodigoPais(pais: 'Honduras', codigo: '+504'),
  _CodigoPais(pais: 'Hungria', codigo: '+36'),
  _CodigoPais(pais: 'India', codigo: '+91'),
  _CodigoPais(pais: 'Indonesia', codigo: '+62'),
  _CodigoPais(pais: 'Irak', codigo: '+964'),
  _CodigoPais(pais: 'Iran', codigo: '+98'),
  _CodigoPais(pais: 'Irlanda', codigo: '+353'),
  _CodigoPais(pais: 'Islandia', codigo: '+354'),
  _CodigoPais(pais: 'Islas Marshall', codigo: '+692'),
  _CodigoPais(pais: 'Islas Salomon', codigo: '+677'),
  _CodigoPais(pais: 'Israel', codigo: '+972'),
  _CodigoPais(pais: 'Italia', codigo: '+39'),
  _CodigoPais(pais: 'Jamaica', codigo: '+1-876'),
  _CodigoPais(pais: 'Japon', codigo: '+81'),
  _CodigoPais(pais: 'Jordania', codigo: '+962'),
  _CodigoPais(pais: 'Kazajistan', codigo: '+7'),
  _CodigoPais(pais: 'Kenia', codigo: '+254'),
  _CodigoPais(pais: 'Kirguistan', codigo: '+996'),
  _CodigoPais(pais: 'Kiribati', codigo: '+686'),
  _CodigoPais(pais: 'Kuwait', codigo: '+965'),
  _CodigoPais(pais: 'Laos', codigo: '+856'),
  _CodigoPais(pais: 'Lesoto', codigo: '+266'),
  _CodigoPais(pais: 'Letonia', codigo: '+371'),
  _CodigoPais(pais: 'Libano', codigo: '+961'),
  _CodigoPais(pais: 'Liberia', codigo: '+231'),
  _CodigoPais(pais: 'Libia', codigo: '+218'),
  _CodigoPais(pais: 'Liechtenstein', codigo: '+423'),
  _CodigoPais(pais: 'Lituania', codigo: '+370'),
  _CodigoPais(pais: 'Luxemburgo', codigo: '+352'),
  _CodigoPais(pais: 'Macedonia del Norte', codigo: '+389'),
  _CodigoPais(pais: 'Madagascar', codigo: '+261'),
  _CodigoPais(pais: 'Malasia', codigo: '+60'),
  _CodigoPais(pais: 'Malaui', codigo: '+265'),
  _CodigoPais(pais: 'Maldivas', codigo: '+960'),
  _CodigoPais(pais: 'Mali', codigo: '+223'),
  _CodigoPais(pais: 'Malta', codigo: '+356'),
  _CodigoPais(pais: 'Marruecos', codigo: '+212'),
  _CodigoPais(pais: 'Mauricio', codigo: '+230'),
  _CodigoPais(pais: 'Mauritania', codigo: '+222'),
  _CodigoPais(pais: 'Mexico', codigo: '+52'),
  _CodigoPais(pais: 'Micronesia', codigo: '+691'),
  _CodigoPais(pais: 'Moldavia', codigo: '+373'),
  _CodigoPais(pais: 'Monaco', codigo: '+377'),
  _CodigoPais(pais: 'Mongolia', codigo: '+976'),
  _CodigoPais(pais: 'Montenegro', codigo: '+382'),
  _CodigoPais(pais: 'Mozambique', codigo: '+258'),
  _CodigoPais(pais: 'Myanmar', codigo: '+95'),
  _CodigoPais(pais: 'Namibia', codigo: '+264'),
  _CodigoPais(pais: 'Nauru', codigo: '+674'),
  _CodigoPais(pais: 'Nepal', codigo: '+977'),
  _CodigoPais(pais: 'Nicaragua', codigo: '+505'),
  _CodigoPais(pais: 'Niger', codigo: '+227'),
  _CodigoPais(pais: 'Nigeria', codigo: '+234'),
  _CodigoPais(pais: 'Noruega', codigo: '+47'),
  _CodigoPais(pais: 'Nueva Zelanda', codigo: '+64'),
  _CodigoPais(pais: 'Oman', codigo: '+968'),
  _CodigoPais(pais: 'Paises Bajos', codigo: '+31'),
  _CodigoPais(pais: 'Pakistan', codigo: '+92'),
  _CodigoPais(pais: 'Palaos', codigo: '+680'),
  _CodigoPais(pais: 'Panama', codigo: '+507'),
  _CodigoPais(pais: 'Papua Nueva Guinea', codigo: '+675'),
  _CodigoPais(pais: 'Paraguay', codigo: '+595'),
  _CodigoPais(pais: 'Peru', codigo: '+51'),
  _CodigoPais(pais: 'Polonia', codigo: '+48'),
  _CodigoPais(pais: 'Portugal', codigo: '+351'),
  _CodigoPais(pais: 'Reino Unido', codigo: '+44'),
  _CodigoPais(pais: 'Republica Centroafricana', codigo: '+236'),
  _CodigoPais(pais: 'Republica Checa', codigo: '+420'),
  _CodigoPais(pais: 'Republica Dominicana', codigo: '+1-809'),
  _CodigoPais(pais: 'Republica del Congo', codigo: '+242'),
  _CodigoPais(pais: 'Republica Democratica del Congo', codigo: '+243'),
  _CodigoPais(pais: 'Ruanda', codigo: '+250'),
  _CodigoPais(pais: 'Rumania', codigo: '+40'),
  _CodigoPais(pais: 'Rusia', codigo: '+7'),
  _CodigoPais(pais: 'Samoa', codigo: '+685'),
  _CodigoPais(pais: 'San Cristobal y Nieves', codigo: '+1-869'),
  _CodigoPais(pais: 'San Marino', codigo: '+378'),
  _CodigoPais(pais: 'San Vicente y las Granadinas', codigo: '+1-784'),
  _CodigoPais(pais: 'Santa Lucia', codigo: '+1-758'),
  _CodigoPais(pais: 'Santo Tome y Principe', codigo: '+239'),
  _CodigoPais(pais: 'Senegal', codigo: '+221'),
  _CodigoPais(pais: 'Serbia', codigo: '+381'),
  _CodigoPais(pais: 'Seychelles', codigo: '+248'),
  _CodigoPais(pais: 'Sierra Leona', codigo: '+232'),
  _CodigoPais(pais: 'Singapur', codigo: '+65'),
  _CodigoPais(pais: 'Siria', codigo: '+963'),
  _CodigoPais(pais: 'Somalia', codigo: '+252'),
  _CodigoPais(pais: 'Sri Lanka', codigo: '+94'),
  _CodigoPais(pais: 'Suazilandia', codigo: '+268'),
  _CodigoPais(pais: 'Sudafrica', codigo: '+27'),
  _CodigoPais(pais: 'Sudan', codigo: '+249'),
  _CodigoPais(pais: 'Sudan del Sur', codigo: '+211'),
  _CodigoPais(pais: 'Suecia', codigo: '+46'),
  _CodigoPais(pais: 'Suiza', codigo: '+41'),
  _CodigoPais(pais: 'Surinam', codigo: '+597'),
  _CodigoPais(pais: 'Tailandia', codigo: '+66'),
  _CodigoPais(pais: 'Taiwan', codigo: '+886'),
  _CodigoPais(pais: 'Tanzania', codigo: '+255'),
  _CodigoPais(pais: 'Tayikistan', codigo: '+992'),
  _CodigoPais(pais: 'Timor Oriental', codigo: '+670'),
  _CodigoPais(pais: 'Togo', codigo: '+228'),
  _CodigoPais(pais: 'Tonga', codigo: '+676'),
  _CodigoPais(pais: 'Trinidad y Tobago', codigo: '+1-868'),
  _CodigoPais(pais: 'Tunez', codigo: '+216'),
  _CodigoPais(pais: 'Turkmenistan', codigo: '+993'),
  _CodigoPais(pais: 'Turquia', codigo: '+90'),
  _CodigoPais(pais: 'Tuvalu', codigo: '+688'),
  _CodigoPais(pais: 'Ucrania', codigo: '+380'),
  _CodigoPais(pais: 'Uganda', codigo: '+256'),
  _CodigoPais(pais: 'Uruguay', codigo: '+598'),
  _CodigoPais(pais: 'Uzbekistan', codigo: '+998'),
  _CodigoPais(pais: 'Vanuatu', codigo: '+678'),
  _CodigoPais(pais: 'Vaticano', codigo: '+379'),
  _CodigoPais(pais: 'Venezuela', codigo: '+58'),
  _CodigoPais(pais: 'Vietnam', codigo: '+84'),
  _CodigoPais(pais: 'Yemen', codigo: '+967'),
  _CodigoPais(pais: 'Yibuti', codigo: '+253'),
  _CodigoPais(pais: 'Zambia', codigo: '+260'),
  _CodigoPais(pais: 'Zimbabue', codigo: '+263'),
];
