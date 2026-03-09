import 'package:pharmago/shared/ext/init_ext.dart';

class DateRangeModel {
  final DateTime? startDate;
  final DateTime? endDate;

  DateRangeModel({
    this.startDate,
    this.endDate,
  });

  DateRangeModel copyWith({
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      DateRangeModel(
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
      );
}

extension HelperMethods on DateRangeModel {
  DateRangeModel? fromListDateTime(List<DateTime?> dates) {
    if (dates.length < 2) return null;
    return DateRangeModel(
      endDate: dates[1],
      startDate: dates[0],
    );
  }

  Map<String, dynamic> get toJson {
    return {
      'start_date': startDate?.fomatDateTimeExt(),
      'end_date': endDate?.fomatDateTimeExt(),
    };
  }
}
