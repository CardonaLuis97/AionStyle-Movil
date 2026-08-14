import 'package:intl/intl.dart';

extension StringX on String {
  bool get esEmailValido =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);

  bool get esContrasenaValida => length >= 8;

  String get capitalizar =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';

  String get capitalizarPalabras =>
      split(' ').map((p) => p.capitalizar).join(' ');
}

extension DateTimeX on DateTime {
  String get formatoFecha => DateFormat('dd/MM/yyyy', 'es').format(this);
  String get formatoHora => DateFormat('HH:mm', 'es').format(this);
  String get formatoFechaHora => DateFormat('dd/MM/yyyy HH:mm', 'es').format(this);
  String get formatoRelativo {
    final diferencia = DateTime.now().difference(this);
    if (diferencia.inMinutes < 1) return 'Ahora mismo';
    if (diferencia.inHours < 1) return 'Hace ${diferencia.inMinutes} min';
    if (diferencia.inDays < 1) return 'Hace ${diferencia.inHours} h';
    if (diferencia.inDays < 7) return 'Hace ${diferencia.inDays} días';
    return formatoFecha;
  }
}

extension DoubleX on double {
  String get formatoMoneda => NumberFormat.currency(locale: 'es', symbol: '\$').format(this);
}
