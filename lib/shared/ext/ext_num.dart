import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension extNum on num? {
  num get validator => this ?? 0;
  String formatDate({
    String? valDefault,
    String? format,
  }) {
    try {
      final double time = double.tryParse(toString()) ?? 0;
      if (time <= 0) {
        return valDefault ?? '';
      }
      return DateFormat(format ?? 'dd/MM/yyyy')
          .format(DateTime.fromMillisecondsSinceEpoch(time.round() * 1000));
    } catch (e) {
      return valDefault ?? '';
    }
  }

  String get formatNumber {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '',
      decimalDigits: 0,
    );
    return formatter.format(this);
  }

  String formatPrice({
    String type = '',
    bool isDefault = true,
  }) {
    if (validator < 0) {
      if (!isDefault) {
        return '';
      }
      return '0$type';
    }
    final formatCurrency = NumberFormat('#,###,###.##', 'vi');
    final String format = formatCurrency.format(validator);
    return format + type;
  }

  String get formatVND {
    if (this == null) {
      return '0đ';
    }

    final formatCurrency = NumberFormat('#,###,###.##', 'vi');
    final String format = formatCurrency.format(this!);
    return '$formatđ';
  }

  String formatPercent({
    String type = '',
    bool isDefault = true,
  }) {
    if (!isDefault && validator <= 0) {
      return '';
    }
    final formatCurrency = NumberFormat('#,###,###.##', 'en');
    final String format = formatCurrency.format(this ?? 0);
    return format + type;
  }

  String get formatCurrency {
    final oCcy = NumberFormat('#,##0', 'vi_VN');
    return oCcy.format(this ?? 0);
  }

  String get formatSecondsToDays {
    return '${(validator / (24 * 60 * 60)).round()}';
  }

  String toStringAsFixedFormat(int fractionDigits) {
    if (this == null) {
      return '';
    }
    if (this == this?.toInt()) {
      return this!.toInt().toString();
    }
    return this!.toStringAsFixed(fractionDigits);
  }

  BorderRadius get radius => BorderRadius.circular(validator.toDouble());
  BorderRadius get radiusTop =>
      BorderRadius.vertical(top: Radius.circular(validator.toDouble()));
  BorderRadius get radiusBottom =>
      BorderRadius.vertical(bottom: Radius.circular(validator.toDouble()));
  BorderRadius get radiusLeft =>
      BorderRadius.horizontal(left: Radius.circular(validator.toDouble()));
  BorderRadius get radiusRight =>
      BorderRadius.horizontal(right: Radius.circular(validator.toDouble()));

  Widget get height => SizedBox(height: validator.toDouble());
  Widget get width => SizedBox(width: validator.toDouble());

  EdgeInsets get padingTop => EdgeInsets.only(top: validator.toDouble());
  EdgeInsets get padingLeft => EdgeInsets.only(left: validator.toDouble());
  EdgeInsets get padingRight => EdgeInsets.only(right: validator.toDouble());
  EdgeInsets get padingBottom => EdgeInsets.only(bottom: validator.toDouble());
  EdgeInsets get padingVer =>
      EdgeInsets.symmetric(vertical: validator.toDouble());
  EdgeInsets get padingHor =>
      EdgeInsets.symmetric(horizontal: validator.toDouble());
  EdgeInsets get pading => EdgeInsets.all(validator.toDouble());
  Duration get milliseconds => Duration(milliseconds: validator.toInt());
  Duration get seconds => Duration(seconds: validator.toInt());
}
