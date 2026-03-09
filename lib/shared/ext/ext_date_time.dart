import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension extDateTime on DateTime? {
  String get fomatDefaulft =>
      this == null ? '' : DateFormat('dd/MM/yyyy').format(this!);

  String fomatDateTimeExt({String fomat = "yyyy-MM-dd'T'HH:mm:ss"}) {
    if (this != null) {
      return DateFormat(fomat, 'vi').format(this!);
    }
    return '';
  }

  TimeOfDay? get toTime => this == null
      ? null
      : TimeOfDay(
          hour: this!.hour,
          minute: this!.minute,
        );

  String fomatCustom({String fomat = 'dd/MM/yyyy'}) {
    if (this != null) {
      return DateFormat(fomat, 'vi').format(this!);
    }
    return '';
  }

  String get formatDateTimeVi {
    if (this == null) return '';

    final String dayOfWeek = DateFormat('EEEE', 'vi').format(this!);
    final String day = DateFormat('dd', 'vi').format(this!);
    final String month = DateFormat('MM', 'vi').format(this!);
    final String year = DateFormat('yyyy', 'vi').format(this!);

    return '$dayOfWeek, Ngày $day, Tháng $month năm $year';
  }

  String get formatDateTimeFull {
    if (this == null) return '';

    final String hour = DateFormat('HH', 'vi').format(this!);
    final String minute = DateFormat('mm', 'vi').format(this!);
    final String day = DateFormat('dd', 'vi').format(this!);
    final String month = DateFormat('MM', 'vi').format(this!);
    final String year = DateFormat('yyyy', 'vi').format(this!);

    return '$hour giờ $minute phút, ngày $day tháng $month năm $year';
  }

  String get formatDayOfWeek {
    if (this == null) return '';

    final String dayOfWeek = DateFormat('EEEE', 'vi').format(this!);

    return dayOfWeek;
  }

  DateTime? get startDay {
    return this?.copyWith(
      hour: 0,
      minute: 0,
      second: 0,
    );
  }

  DateTime? get endDay {
    return this?.copyWith(
      hour: 23,
      minute: 59,
      second: 59,
    );
  }
}
