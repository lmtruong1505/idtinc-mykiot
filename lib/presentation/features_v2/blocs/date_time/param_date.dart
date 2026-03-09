import 'package:pharmago/shared/ext/init_ext.dart';

class ParamDate {
  DateTime? startDate;
  DateTime? endDate;
  DateRangeEnum? dateRange;
  ParamDate({
    this.dateRange = DateRangeEnum.thisMonth,
    this.endDate,
    this.startDate,
  });

  Map<String, dynamic> toJson() {
    return {
      if (startDate != null && dateRange == DateRangeEnum.option)
        'created_at__gte': startDate.fomatCustom(fomat: 'yyyy-MM-dd'),
      if (endDate != null && dateRange == DateRangeEnum.option)
        'created_at__lte': endDate.fomatCustom(fomat: 'yyyy-MM-dd'),
      if (dateRange != null && dateRange != DateRangeEnum.option)
        'date_range': dateRange?.val,
    };
  }

  String toText() {
    return '$dateRange : $startDate : $endDate';
  }
}

enum DateRangeEnum {
  //["last_week", "this_week", "this_month", "last_month", "today", "yesterday"]
  all('all', 'Tất cả'),
  today('today', 'Hôm nay'),
  yesterday('yesterday', 'Hôm qua'),
  thisWeek('this_week', 'Tuần này'),
  lastWeek('last_week', 'Tuần trước'),
  thisMonth('this_month', 'Tháng này'),
  lastMonth('last_month', 'Tháng trước'),
  lastYear('last_year', 'Năm trước'),
  thisYear('this_year', 'Năm nay'),
  option('option', 'Tuỳ chỉnh');

  final String val;
  final String title;
  const DateRangeEnum(this.val, this.title);
}

extension DateRangeEnumExt on DateRangeEnum? {
  String get toName => _convertName();

  String _convertName() {
    switch (this) {
      case DateRangeEnum.today:
        return 'Hôm nay';
      case DateRangeEnum.yesterday:
        return 'Hôm qua';
      case DateRangeEnum.thisWeek:
        return 'Tuần này';
      case DateRangeEnum.lastWeek:
        return 'Tuần trước';
      case DateRangeEnum.thisMonth:
        return 'Tháng này';
      case DateRangeEnum.lastMonth:
        return 'Tháng trước';
      case DateRangeEnum.thisYear:
        return 'Năm nay';
      case DateRangeEnum.lastYear:
        return 'Năm trước';
      case DateRangeEnum.option:
        return 'Tuỳ chọn';
      default:
        return 'Tất cả thời gian';
    }
  }
}
