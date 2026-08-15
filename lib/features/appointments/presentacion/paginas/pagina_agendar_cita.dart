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
  int _panelActivo = 0;
  DateTime? _fechaSeleccionada;
  TimeOfDay? _horaSeleccionada;
  MetodoPagoCita _metodoPago = MetodoPagoCita.efectivo;
  String? _corteSeleccionado;

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
    return _horaSeleccionada!.format(context);
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
    final fecha = await showDatePicker(
      context: context,
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
      backgroundColor: ColoresApp.secundario,
      appBar: AppBar(title: const Text('Agendar cita')),
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
              ),
            ),
            const SizedBox(height: 16),
            ExpansionPanelList.radio(
              initialOpenPanelValue: _panelActivo,
              elevation: 0,
              expandedHeaderPadding: EdgeInsets.zero,
              dividerColor: Colors.transparent,
              animationDuration: const Duration(milliseconds: 220),
              expansionCallback: (_, __) {},
              children: [
                ExpansionPanelRadio(
                  value: 0,
                  canTapOnHeader: true,
                  backgroundColor: ColoresApp.secundario,
                  headerBuilder: (context, isExpanded) => _encabezadoSeccion(
                    titulo: 'Corte del cliente',
                    abierto: isExpanded,
                  ),
                  body: _cuerpoSeccion(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: _corteSeleccionado,
                          decoration: const InputDecoration(
                            hintText: 'Selecciona un corte',
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
                        const SizedBox(height: 8),
                        Text(
                          _corteSeleccionado == null
                              ? 'Precio pendiente'
                              : 'Precio del corte: USD ${_precioSeleccionado.toStringAsFixed(2)}',
                          style: tema.textTheme.bodySmall?.copyWith(
                            color: ColoresApp.textoClaro,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ExpansionPanelRadio(
                  value: 1,
                  canTapOnHeader: true,
                  backgroundColor: ColoresApp.secundario,
                  headerBuilder: (context, isExpanded) => _encabezadoSeccion(
                    titulo: 'Fecha de cita',
                    abierto: isExpanded,
                  ),
                  body: _cuerpoSeccion(
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.calendar_month_outlined,
                        color: ColoresApp.primario,
                      ),
                      title: Text(
                        _fechaTexto == 'Pendiente'
                            ? 'Seleccionar fecha'
                            : _fechaTexto,
                        style: tema.textTheme.bodyMedium,
                      ),
                      subtitle: Text(
                        'Ver disponibilidad del barbero',
                        style: tema.textTheme.bodySmall,
                      ),
                      trailing: TextButton.icon(
                        onPressed: _seleccionarFecha,
                        icon: const Icon(Icons.calendar_month_outlined, size: 16),
                        label: const Text('Elegir'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          side: BorderSide(
                            color: ColoresApp.primario.withValues(alpha: 0.45),
                          ),
                          foregroundColor: ColoresApp.primario,
                        ),
                      ),
                    ),
                  ),
                ),
                ExpansionPanelRadio(
                  value: 2,
                  canTapOnHeader: true,
                  backgroundColor: ColoresApp.secundario,
                  headerBuilder: (context, isExpanded) => _encabezadoSeccion(
                    titulo: 'Hora de llegada',
                    abierto: isExpanded,
                  ),
                  body: _cuerpoSeccion(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            Icons.access_time_outlined,
                            color: ColoresApp.primario,
                          ),
                          title: Text(
                            _horaTexto == 'Pendiente'
                                ? 'Seleccionar hora'
                                : _horaTexto,
                            style: tema.textTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            'Disponibilidad segun fecha elegida',
                            style: tema.textTheme.bodySmall,
                          ),
                          trailing: TextButton.icon(
                            onPressed: _seleccionarHora,
                            icon: const Icon(Icons.schedule_outlined, size: 16),
                            label: const Text('Elegir'),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              side: BorderSide(
                                color:
                                    ColoresApp.primario.withValues(alpha: 0.45),
                              ),
                              foregroundColor: ColoresApp.primario,
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: _horasDisponibles.take(8).map((hora) {
                            return Chip(
                              label: Text(
                                hora.format(context),
                                style: tema.textTheme.bodySmall?.copyWith(
                                  color: ColoresApp.primario,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              backgroundColor: ColoresApp.fondo,
                              side: BorderSide(
                                color:
                                    ColoresApp.primario.withValues(alpha: 0.25),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                ExpansionPanelRadio(
                  value: 3,
                  canTapOnHeader: true,
                  backgroundColor: ColoresApp.secundario,
                  headerBuilder: (context, isExpanded) => _encabezadoSeccion(
                    titulo: 'Metodo de pago',
                    abierto: isExpanded,
                  ),
                  body: _cuerpoSeccion(
                    SegmentedButton<MetodoPagoCita>(
                      showSelectedIcon: false,
                      style: ButtonStyle(
                        foregroundColor:
                            WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return ColoresApp.secundario;
                          }
                          return ColoresApp.primario;
                        }),
                        backgroundColor:
                            WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return ColoresApp.primario;
                          }
                          return ColoresApp.secundario;
                        }),
                        side: WidgetStateProperty.all(
                          BorderSide(
                            color: ColoresApp.primario.withValues(alpha: 0.28),
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
              ],
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
              ),
              child: const Text('Confirmar cita'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _encabezadoSeccion({required String titulo, required bool abierto}) {
    final tema = Theme.of(context);
    return ListTile(
      tileColor: ColoresApp.fondo,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: ColoresApp.primario.withValues(alpha: 0.18)),
      ),
      title: Row(
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
          const _BadgeRequerido(),
        ],
      ),
    );
  }

  Widget _cuerpoSeccion(Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: ColoresApp.secundario,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        border: Border.all(color: ColoresApp.primario.withValues(alpha: 0.12)),
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
        color: ColoresApp.fondo,
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
          color: ColoresApp.primario.withValues(alpha: 0.12),
        ),
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
  const _BadgeRequerido();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: ColoresApp.primario,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'Requerido',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: ColoresApp.secundario,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
