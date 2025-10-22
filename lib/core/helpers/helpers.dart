import 'package:intl/intl.dart';

class Helpers {
  static String formatTime(DateTime? dateTime) {
    // DateTime dateTime = DateTime.parse(dateTimeString);
    if (dateTime != null) {
      return DateFormat('HH:mm').format(dateTime);
    }
    return '';
  }

  static String formatedDateTime(DateTime? dateIso) {
    if (dateIso == null){
      return '';
    }
    // final date = DateTime.parse(dateIso);
    final dia = dateIso.day.toString().padLeft(2, '0');
    final mes = dateIso.month.toString().padLeft(2, '0');
    final anio = dateIso.year.toString().substring(
      2,
    ); // Solo los últimos dos dígitos
    final hora = dateIso.hour.toString().padLeft(2, '0');
    final minuto = dateIso.minute.toString().padLeft(2, '0');
    return '$dia/$mes/$anio $hora:$minuto';
  }
}
