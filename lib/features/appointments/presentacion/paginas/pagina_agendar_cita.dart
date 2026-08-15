import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/enrutador.dart';
import '../../../../app/theme/colores.dart';

enum MetodoPagoCita { efectivo, visa }

class PaginaAgendarCita extends StatefulWidget {
  const PaginaAgendarCita({
    super.key,
    required this.negocioNombre,
    required this.barberoNombre,
    required this.especialidades,
  });

  final String negocioNombre;
  final String barberoNombre;
  final List<String> especialidades;

  @override
  State<PaginaAgendarCita> createState() => _PaginaAgendarCitaState();
}

class _PaginaAgendarCitaState extends State<PaginaAgendarCita> {
  final _formKey = GlobalKey<FormState>();
  final _numeroTarjetaCtrl = TextEditingController();
  final _nombreTitularCtrl = TextEditingController();
  final _vencimientoCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  int _panelActivo = 0;
  DateTime? _fechaSeleccionada;
  TimeOfDay? _horaSeleccionada;
  MetodoPagoCita _metodoPago = MetodoPagoCita.efectivo;
  String? _corteSeleccionado;

  @override
  void dispose() {
    _numeroTarjetaCtrl.dispose();
    _nombreTitularCtrl.dispose();
    _vencimientoCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  bool get _corteCompleto =>
      _corteSeleccionado != null && _corteSeleccionado!.isNotEmpty;

  bool get _fechaCompleta => _fechaSeleccionada != null;

  bool get _horaCompleta => _horaSeleccionada != null;

  bool get _pagoCompleto {
    if (_metodoPago == MetodoPagoCita.efectivo) return true;
    final numero = _numeroTarjetaCtrl.text.replaceAll(' ', '');
    final vencimientoValido = RegExp(r'^(0[1-9]|1[0-2])\/(\d{2})$')
        .hasMatch(_vencimientoCtrl.text.trim());
    final cvvValido = RegExp(r'^\d{3,4}$').hasMatch(_cvvCtrl.text.trim());
    return numero.length >= 13 &&
        _nombreTitularCtrl.text.trim().isNotEmpty &&
        vencimientoValido &&
        cvvValido;
  }

  Map<String, double> get _cortesConPrecio {
    final mapa = <String, double>{};
    for (var i = 0; i < widget.especialidades.length; i++) {
      final corte = widget.especialidades[i];
      mapa[corte] = 12 + (i * 4.5);
    }
    return mapa;
  }

  double get _precioSeleccionado {
    if (_corteSeleccionado == null) return 0;
    return _cortesConPrecio[_corteSeleccionado] ?? 0;
  }

  String get _fechaTexto {
    if (_fechaSeleccionada == null) return 'Pendiente';
    return '${_fechaSeleccionada!.day.toString().padLeft(2, '0')}/${_fechaSeleccionada!.month.toString().padLeft(2, '0')}/${_fechaSeleccionada!.year}';
  }

  String get _horaTexto {
    if (_horaSeleccionada == null) return 'Pendiente';
    return _formatearHora12(_horaSeleccionada!);
  }

  String _formatearHora12(TimeOfDay hora) {
    final hora12 = hora.hourOfPeriod == 0 ? 12 : hora.hourOfPeriod;
    final minuto = hora.minute.toString().padLeft(2, '0');
    final periodo = hora.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hora12:$minuto $periodo';
  }

  String get _metodoPagoTexto {
    return _metodoPago == MetodoPagoCita.efectivo ? 'Efectivo' : 'Visa';
  }

  List<TimeOfDay> get _horasDisponibles {
    final base = <TimeOfDay>[];
    for (var h = 9; h <= 19; h++) {
      base.add(TimeOfDay(hour: h, minute: 0));
      if (h != 19) {
        base.add(TimeOfDay(hour: h, minute: 30));
      }
    }
    if (_fechaSeleccionada == null) return base;

    final dia = _fechaSeleccionada!.weekday;
    if (dia == DateTime.sunday) {
      return base
          .where((t) => t.hour >= 10 && t.hour <= 15)
          .toList(growable: false);
    }
    return base;
  }

  Future<void> _seleccionarFecha() async {
    final ahora = DateTime.now();
    DateTime? fecha;
    try {
      fecha = await showDatePicker(
        context: context,
        locale: const Locale('es', 'ES'),
        initialDate: _fechaSeleccionada ?? ahora,
        firstDate: ahora,
        lastDate: ahora.add(const Duration(days: 60)),
        helpText: 'Selecciona fecha de cita',
        builder: (context, child) {
          final tema = Theme.of(context);
          final esquema = tema.colorScheme;
          return Theme(
            data: tema.copyWith(
              colorScheme: esquema.copyWith(
                surface: tema.brightness == Brightness.dark
                    ? ColoresApp.primario
                    : ColoresApp.secundario,
                onSurface: tema.brightness == Brightness.dark
                    ? ColoresApp.secundario
                    : ColoresApp.texto,
              ),
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
      );
    } catch (_) {
      // Fallback si el locale es-ES no esta registrado en el host.
      fecha = await showDatePicker(
        context: context,
        initialDate: _fechaSeleccionada ?? ahora,
        firstDate: ahora,
        lastDate: ahora.add(const Duration(days: 60)),
        helpText: 'Selecciona fecha de cita',
      );
    }
    if (fecha != null) {
      setState(() {
        _fechaSeleccionada = fecha;
        _horaSeleccionada = null;
      });
    }
  }

  Future<void> _seleccionarHora() async {
    if (_fechaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero selecciona la fecha.')),
      );
      return;
    }

    final disponible = _horasDisponibles;
    final propuesta = await showTimePicker(
      context: context,
      initialTime: disponible.first,
      helpText: 'Selecciona hora de llegada',
      builder: (context, child) {
        final tema = Theme.of(context);
        final esquema = tema.colorScheme;
        return Theme(
          data: tema.copyWith(
            colorScheme: esquema.copyWith(
              surface: tema.brightness == Brightness.dark
                  ? ColoresApp.primario
                  : ColoresApp.secundario,
              onSurface: tema.brightness == Brightness.dark
                  ? ColoresApp.secundario
                  : ColoresApp.texto,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (propuesta == null) return;

    final esValida = disponible.any(
      (t) => t.hour == propuesta.hour && t.minute == propuesta.minute,
    );

    if (!esValida) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hora no disponible para ese dia.')),
      );
      return;
    }

    setState(() {
      _horaSeleccionada = propuesta;
    });
  }

  void _confirmarCita() {
    final formularioValido = _formKey.currentState?.validate() ?? false;
    if (!formularioValido) return;

    if (_fechaSeleccionada == null || _horaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa fecha y hora para confirmar.')),
      );
      return;
    }

    if (_corteSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona el corte del cliente.')),
      );
      return;
    }

    if (_metodoPago == MetodoPagoCita.visa && !_pagoCompleto) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa los datos de Visa para continuar.'),
        ),
      );
      return;
    }

    final marca = DateTime.now().millisecondsSinceEpoch.toString();
    final codigoQr =
        'AIONSTYLE|$marca|${widget.negocioNombre}|${widget.barberoNombre}|${_corteSeleccionado!}|$_fechaTexto|$_horaTexto|${_precioSeleccionado.toStringAsFixed(2)}';

    context.pushReplacement(
      '${Rutas.confirmacionCita}?negocio=${Uri.encodeComponent(widget.negocioNombre)}&barbero=${Uri.encodeComponent(widget.barberoNombre)}&corte=${Uri.encodeComponent(_corteSeleccionado!)}&precio=${_precioSeleccionado.toStringAsFixed(2)}&fecha=${Uri.encodeComponent(_fechaTexto)}&hora=${Uri.encodeComponent(_horaTexto)}&pago=${Uri.encodeComponent(_metodoPagoTexto)}&qr=${Uri.encodeComponent(codigoQr)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        title: const Text('Agendar cita'),
        backgroundColor: ColoresApp.primario,
        foregroundColor: ColoresApp.secundario,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Reserva con ${widget.barberoNombre}',
              style: tema.textTheme.titleMedium?.copyWith(
                color: ColoresApp.primario,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.negocioNombre,
              style: tema.textTheme.bodySmall?.copyWith(
                color: ColoresApp.textoClaro,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            _itemAcordeon(
              indice: 0,
              titulo: 'Corte del cliente',
              completo: _corteCompleto,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _corteSeleccionado,
                    style: tema.textTheme.bodyMedium?.copyWith(
                      color: ColoresApp.secundario,
                    ),
                    dropdownColor: ColoresApp.primario,
                    iconEnabledColor: ColoresApp.secundario,
                    decoration: InputDecoration(
                      hintText: 'Selecciona un corte',
                      filled: true,
                      fillColor: ColoresApp.secundario.withValues(alpha: 0.10),
                      hintStyle: tema.textTheme.bodySmall?.copyWith(
                        color: ColoresApp.secundario.withValues(alpha: 0.72),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: ColoresApp.secundario.withValues(alpha: 0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: ColoresApp.secundario.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: ColoresApp.secundario.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                    items: _cortesConPrecio.entries.map((entrada) {
                      return DropdownMenuItem<String>(
                        value: entrada.key,
                        child: Text(
                          '${entrada.key} - USD ${entrada.value.toStringAsFixed(2)}',
                        ),
                      );
                    }).toList(),
                    onChanged: (valor) {
                      setState(() {
                        _corteSeleccionado = valor;
                      });
                    },
                    validator: (valor) {
                      if (valor == null || valor.isEmpty) {
                        return 'Selecciona un corte';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            _itemAcordeon(
              indice: 1,
              titulo: 'Fecha de cita',
              completo: _fechaCompleta,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.calendar_month_outlined,
                  color: ColoresApp.secundario,
                ),
                title: Text(
                  _fechaTexto == 'Pendiente' ? 'Seleccionar fecha' : _fechaTexto,
                  style: tema.textTheme.bodyMedium?.copyWith(
                    color: ColoresApp.secundario,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Ver disponibilidad del barbero',
                  style: tema.textTheme.bodySmall?.copyWith(
                    color: ColoresApp.secundario.withValues(alpha: 0.72),
                  ),
                ),
                trailing: TextButton.icon(
                  onPressed: _seleccionarFecha,
                  icon: const Icon(
                    Icons.calendar_month_outlined,
                    size: 16,
                    color: ColoresApp.secundario,
                  ),
                  label: const Text('Elegir'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(
                      color: ColoresApp.secundario.withValues(alpha: 0.45),
                    ),
                    foregroundColor: ColoresApp.secundario,
                  ),
                ),
              ),
            ),
            _itemAcordeon(
              indice: 2,
              titulo: 'Hora de llegada',
              completo: _horaCompleta,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.access_time_outlined,
                      color: ColoresApp.secundario,
                    ),
                    title: Text(
                      _horaTexto == 'Pendiente' ? 'Seleccionar hora' : _horaTexto,
                      style: tema.textTheme.bodyMedium?.copyWith(
                        color: ColoresApp.secundario,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Disponibilidad segun fecha elegida',
                      style: tema.textTheme.bodySmall?.copyWith(
                        color: ColoresApp.secundario.withValues(alpha: 0.72),
                      ),
                    ),
                    trailing: TextButton.icon(
                      onPressed: _seleccionarHora,
                      icon: const Icon(
                        Icons.schedule_outlined,
                        size: 16,
                        color: ColoresApp.secundario,
                      ),
                      label: const Text('Elegir'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: ColoresApp.secundario.withValues(alpha: 0.45),
                        ),
                        foregroundColor: ColoresApp.secundario,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _horasDisponibles.take(8).map((hora) {
                      return Chip(
                        label: Text(
                          _formatearHora12(hora),
                          style: tema.textTheme.bodySmall?.copyWith(
                            color: ColoresApp.secundario,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: ColoresApp.secundario.withValues(
                          alpha: 0.12,
                        ),
                        side: BorderSide(
                          color: ColoresApp.secundario.withValues(alpha: 0.3),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            _itemAcordeon(
              indice: 3,
              titulo: 'Metodo de pago',
              completo: _pagoCompleto,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 220,
                      child: SegmentedButton<MetodoPagoCita>(
                        showSelectedIcon: false,
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return ColoresApp.primario;
                            }
                            return ColoresApp.secundario;
                          }),
                          backgroundColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return ColoresApp.terceario;
                            }
                            return ColoresApp.secundario.withValues(alpha: 0.12);
                          }),
                          side: WidgetStateProperty.all(
                            BorderSide(
                              color: ColoresApp.secundario.withValues(alpha: 0.35),
                            ),
                          ),
                        ),
                        segments: const [
                          ButtonSegment<MetodoPagoCita>(
                            value: MetodoPagoCita.efectivo,
                            label: Text('Efectivo'),
                          ),
                          ButtonSegment<MetodoPagoCita>(
                            value: MetodoPagoCita.visa,
                            label: Text('Visa'),
                          ),
                        ],
                        selected: {_metodoPago},
                        onSelectionChanged: (valores) {
                          setState(() {
                            _metodoPago = valores.first;
                          });
                        },
                      ),
                    ),
                  ),
                  if (_metodoPago == MetodoPagoCita.visa) ...[
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _numeroTarjetaCtrl,
                    keyboardType: TextInputType.number,
                    style: tema.textTheme.bodyMedium?.copyWith(
                      color: ColoresApp.secundario,
                    ),
                    decoration: _decoracionCampoVisa(
                      tema,
                      'Numero de tarjeta',
                    ),
                    onChanged: (_) => setState(() {}),
                    validator: (valor) {
                      if (_metodoPago != MetodoPagoCita.visa) return null;
                      final limpio = (valor ?? '').replaceAll(' ', '');
                      if (limpio.length < 13) {
                        return 'Ingresa un numero valido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nombreTitularCtrl,
                    style: tema.textTheme.bodyMedium?.copyWith(
                      color: ColoresApp.secundario,
                    ),
                    decoration: _decoracionCampoVisa(
                      tema,
                      'Nombre del titular',
                    ),
                    onChanged: (_) => setState(() {}),
                    validator: (valor) {
                      if (_metodoPago != MetodoPagoCita.visa) return null;
                      if ((valor ?? '').trim().isEmpty) {
                        return 'Ingresa el titular';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _vencimientoCtrl,
                          keyboardType: TextInputType.number,
                          style: tema.textTheme.bodyMedium?.copyWith(
                            color: ColoresApp.secundario,
                          ),
                          decoration: _decoracionCampoVisa(
                            tema,
                            'MM/AA',
                          ),
                          onChanged: (_) => setState(() {}),
                          validator: (valor) {
                            if (_metodoPago != MetodoPagoCita.visa) return null;
                            final v = (valor ?? '').trim();
                            if (!RegExp(r'^(0[1-9]|1[0-2])\/(\d{2})$')
                                .hasMatch(v)) {
                              return 'Formato invalido';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _cvvCtrl,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          style: tema.textTheme.bodyMedium?.copyWith(
                            color: ColoresApp.secundario,
                          ),
                          decoration: _decoracionCampoVisa(
                            tema,
                            'CVV',
                          ),
                          onChanged: (_) => setState(() {}),
                          validator: (valor) {
                            if (_metodoPago != MetodoPagoCita.visa) return null;
                            if (!RegExp(r'^\d{3,4}$')
                                .hasMatch((valor ?? '').trim())) {
                              return 'CVV invalido';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 10),
            _TarjetaFormulario(
              titulo: 'Resumen de agenda',
              child: Column(
                children: [
                  _filaResumen('Negocio', widget.negocioNombre),
                  _filaResumen('Barbero', widget.barberoNombre),
                  _filaResumen('Corte', _corteSeleccionado ?? 'Pendiente'),
                  _filaResumen(
                    'Precio',
                    _corteSeleccionado == null
                        ? 'Pendiente'
                        : 'USD ${_precioSeleccionado.toStringAsFixed(2)}',
                  ),
                  _filaResumen('Fecha', _fechaTexto),
                  _filaResumen('Hora', _horaTexto),
                  _filaResumen('Pago', _metodoPagoTexto),
                ],
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _confirmarCita,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresApp.primario,
                foregroundColor: ColoresApp.secundario,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Confirmar cita'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemAcordeon({
    required int indice,
    required String titulo,
    required bool completo,
    required Widget child,
  }) {
    final abierto = _panelActivo == indice;
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              _panelActivo = indice;
            });
          },
          child: _encabezadoSeccion(
            titulo: titulo,
            abierto: abierto,
            completo: completo,
          ),
        ),
        if (abierto) _cuerpoSeccion(child),
      ],
    );
  }

  Widget _encabezadoSeccion({
    required String titulo,
    required bool abierto,
    required bool completo,
  }) {
    final tema = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: abierto ? 0 : 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: abierto
            ? ColoresApp.terceario.withValues(alpha: 0.85)
            : ColoresApp.terceario.withValues(alpha: 0.62),
        borderRadius: abierto
            ? const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              )
            : BorderRadius.circular(16),
        border: Border.all(
          color: ColoresApp.primario,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              titulo,
              style: tema.textTheme.labelLarge?.copyWith(
                color: ColoresApp.primario,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _BadgeRequerido(completo: completo),
        ],
      ),
    );
  }

  Widget _cuerpoSeccion(Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: ColoresApp.primario,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: child,
    );
  }

  Widget _filaResumen(String etiqueta, String valor) {
    final tema = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: ColoresApp.secundario,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              etiqueta,
              style: tema.textTheme.bodySmall?.copyWith(
                color: ColoresApp.textoClaro,
                fontSize: 10,
              ),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              textAlign: TextAlign.end,
              style: tema.textTheme.bodySmall?.copyWith(
                color: ColoresApp.primario,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoracionCampoVisa(ThemeData tema, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: tema.textTheme.bodySmall?.copyWith(
        color: ColoresApp.secundario.withValues(alpha: 0.72),
      ),
      filled: true,
      fillColor: ColoresApp.secundario.withValues(alpha: 0.10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: ColoresApp.secundario.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: ColoresApp.secundario.withValues(alpha: 0.8)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColoresApp.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColoresApp.error),
      ),
    );
  }
}

class _TarjetaFormulario extends StatelessWidget {
  const _TarjetaFormulario({required this.titulo, required this.child});

  final String titulo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColoresApp.secundario,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColoresApp.terceario.withValues(alpha: 0.55),
        ),
        boxShadow: [
          BoxShadow(
            color: ColoresApp.primario.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: tema.textTheme.labelLarge?.copyWith(
              color: ColoresApp.primario,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _BadgeRequerido extends StatelessWidget {
  const _BadgeRequerido({required this.completo});

  final bool completo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: completo ? ColoresApp.primario : ColoresApp.error,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        completo ? 'Completado' : 'Requerido',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: ColoresApp.secundario,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
