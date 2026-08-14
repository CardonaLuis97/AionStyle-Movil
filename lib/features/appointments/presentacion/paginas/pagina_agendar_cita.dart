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

    context.pushReplacement(
      '${Rutas.confirmacionCita}?negocio=${Uri.encodeComponent(widget.negocioNombre)}&barbero=${Uri.encodeComponent(widget.barberoNombre)}&corte=${Uri.encodeComponent(_corteSeleccionado!)}&precio=${_precioSeleccionado.toStringAsFixed(2)}&fecha=${Uri.encodeComponent(_fechaTexto)}&hora=${Uri.encodeComponent(_horaTexto)}&pago=${Uri.encodeComponent(_metodoPagoTexto)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
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
            _TarjetaFormulario(
              titulo: 'Corte del cliente',
              child: Column(
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
                        child: Text('${entrada.key} - USD ${entrada.value.toStringAsFixed(2)}'),
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
            const SizedBox(height: 10),
            _TarjetaFormulario(
              titulo: 'Fecha de cita',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_month_outlined),
                title: Text(
                  _fechaTexto == 'Pendiente' ? 'Seleccionar fecha' : _fechaTexto,
                  style: tema.textTheme.bodyMedium,
                ),
                subtitle: Text(
                  'Ver disponibilidad del barbero',
                  style: tema.textTheme.bodySmall,
                ),
                trailing: TextButton(
                  onPressed: _seleccionarFecha,
                  child: const Text('Elegir'),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _TarjetaFormulario(
              titulo: 'Hora de llegada',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.access_time_outlined),
                    title: Text(
                      _horaTexto == 'Pendiente' ? 'Seleccionar hora' : _horaTexto,
                      style: tema.textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      'Disponibilidad segun fecha elegida',
                      style: tema.textTheme.bodySmall,
                    ),
                    trailing: TextButton(
                      onPressed: _seleccionarHora,
                      child: const Text('Elegir'),
                    ),
                  ),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _horasDisponibles.take(8).map((hora) {
                      return Chip(
                        label: Text(hora.format(context)),
                        backgroundColor: ColoresApp.fondo,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _TarjetaFormulario(
              titulo: 'Metodo de pago',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SegmentedButton<MetodoPagoCita>(
                    showSelectedIcon: false,
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return ColoresApp.secundario;
                        }
                        return ColoresApp.primario;
                      }),
                      backgroundColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return ColoresApp.primario;
                        }
                        return ColoresApp.secundario;
                      }),
                      side: WidgetStateProperty.all(
                        BorderSide(color: ColoresApp.terceario.withValues(alpha: 0.25)),
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
              ),
              child: const Text('Confirmar cita'),
            ),
          ],
        ),
      ),
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
                color: ColoresApp.texto,
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
        border: Border.all(color: ColoresApp.terceario.withValues(alpha: 0.2)),
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
