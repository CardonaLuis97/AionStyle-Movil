import 'package:flutter/material.dart';
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

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cita confirmada'),
          content: Text(
            'Tu cita con ${widget.barberoNombre} en ${widget.negocioNombre} ha sido registrada.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
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
              titulo: 'Fecha de cita',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_month_outlined),
                title: Text(
                  _fechaSeleccionada == null
                      ? 'Seleccionar fecha'
                      : '${_fechaSeleccionada!.day.toString().padLeft(2, '0')}/${_fechaSeleccionada!.month.toString().padLeft(2, '0')}/${_fechaSeleccionada!.year}',
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
                      _horaSeleccionada == null
                          ? 'Seleccionar hora'
                          : _horaSeleccionada!.format(context),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _lineaResumen('Negocio', widget.negocioNombre),
                  _lineaResumen('Barbero', widget.barberoNombre),
                  _lineaResumen('Especialidades', widget.especialidades.join(', ')),
                  _lineaResumen(
                    'Fecha',
                    _fechaSeleccionada == null
                        ? 'Pendiente'
                        : '${_fechaSeleccionada!.day.toString().padLeft(2, '0')}/${_fechaSeleccionada!.month.toString().padLeft(2, '0')}/${_fechaSeleccionada!.year}',
                  ),
                  _lineaResumen(
                    'Hora',
                    _horaSeleccionada == null
                        ? 'Pendiente'
                        : _horaSeleccionada!.format(context),
                  ),
                  _lineaResumen(
                    'Pago',
                    _metodoPago == MetodoPagoCita.efectivo ? 'Efectivo' : 'Visa',
                  ),
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

  Widget _lineaResumen(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: ColoresApp.texto,
                fontSize: 11,
              ),
          children: [
            TextSpan(
              text: '$etiqueta: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: valor),
          ],
        ),
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
