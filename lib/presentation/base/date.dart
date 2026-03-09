import 'package:intl/intl.dart';

class Date {
  static DateTime parseDate(String? dateStr) {
    DateTime result = DateTime.now();
    try {
      result = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').parse(dateStr ?? '');
    } on Exception {}
    return result;
  }

  static String formatDate(DateTime? date) {
    String result = '';
    try {
      result = DateFormat("yyyy-MM-ddTHH:mm:ss.000'Z'")
          .format(date ?? DateTime.now());
    } on Exception {}
    return result;
  }

  static String formatDateDay(DateTime? date) {
    String result = '';
    try {
      result = DateFormat('dd/MM/yyyy').format(date ?? DateTime.now());
    } on Exception {}
    return result;
  }

  static String formatDateTime(DateTime? date) {
    String result = '';
    try {
      result = DateFormat('HH:mm - dd/MM/yyyy').format(date ?? DateTime.now());
    } on Exception {}
    return result;
  }

  static int convertDayToSecond(int day) {
    return day * 24 * 60 * 60;
  }

  static int convertSecondToDay(int second) {
    return second ~/ (24 * 60 * 60);
  }

}
