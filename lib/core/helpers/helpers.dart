import 'package:intl/intl.dart';

class Helpers {
  
  static String formatTime(DateTime? dateTime) {
    // DateTime dateTime = DateTime.parse(dateTimeString);
    if(dateTime != null){
      return DateFormat('HH:mm').format(dateTime);
    }
    return '';
    
  }
}