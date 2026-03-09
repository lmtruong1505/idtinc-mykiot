import 'package:pharmago/shared/ext/ext_num.dart';

class DashboardOrderModel {
  int? currentMonth;
  int? lastMonth;
  num? percentage;
  num salesMonth = 0;
  num salesLastMonth = 0;
  num revenueMonth = 0;
  num revenueLastMonth = 0;
  num totalDebt = 0;

  DashboardOrderModel({
    this.currentMonth,
    this.lastMonth,
    this.percentage,
    this.salesLastMonth = 0,
    this.salesMonth = 0,
    this.revenueLastMonth = 0,
    this.revenueMonth = 0,
    this.totalDebt = 0,
  });

  DashboardOrderModel.fromJson(Map<String, dynamic> json) {
    currentMonth = json['current_month'];
    lastMonth = json['last_month'];
    percentage = json['percentage'];
    salesMonth = json['sales_month'] ?? 0;
    salesLastMonth = json['sales_last_month'] ?? 0;
    revenueMonth = json['revenue_month'] ?? 0;
    revenueLastMonth = json['revenue_last_month'] ?? 0;
    totalDebt = json['total_debt'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_month'] = currentMonth;
    data['last_month'] = lastMonth;
    data['percentage'] = percentage;
    return data;
  }
}

extension Get on DashboardOrderModel {
  String get percentRevenue {
    if (revenueLastMonth == 0) return '100';
    return ((revenueMonth - revenueLastMonth) * 100 / revenueLastMonth)
        .toStringAsFixed(2);
  }

  String get percentSales {
    if (salesLastMonth == 0) return '100';
    return ((salesMonth - salesLastMonth) * 100 / salesLastMonth)
        .toStringAsFixed(2);
  }

  String get percentOrder {
    if (lastMonth == 0) return '100';
    return (((currentMonth ?? 0) - lastMonth!) * 100 / lastMonth!)
        .toStringAsFixedFormat(2);
  }

  String get revenueMonthConvert {
    final lengthNum = (revenueMonth.toInt()).toString().length;
    switch (lengthNum) {
      case > 7:
        return '${(revenueMonth / 1000000).toStringAsFixed(2)} triệu';
      case > 10:
        return '${(revenueMonth / 1000000000).toStringAsFixed(2)} tỷ';
      default:
        return revenueMonth.formatCurrency;
    }
  }

  String get salesMonthConvert {
    final lengthNum = (salesMonth.toInt()).toString().length;
    switch (lengthNum) {
      case > 7:
        return '${(salesMonth / 1000000).toStringAsFixed(2)} triệu';
      case > 10:
        return '${(salesMonth / 1000000000).toStringAsFixed(2)} tỷ';
      default:
        return salesMonth.formatCurrency;
    }
  }
}
