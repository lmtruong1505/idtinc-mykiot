import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/report/data/models/item_report_model.dart';

import '../../data/models/home_report_model.dart';
import '../../data/models/revenue_report_model.dart';

abstract class ReportRepository {
  Future<BaseResponseModel<HomeReportModel>> homeReport({
    required int company,
  });

  Future<BaseResponseModel<List<RevenueReportModel>>> revenueReport({
    required int company,
    required String filter,
  });


  Future<BaseResponseModel<List<ItemReportModel>>> orderReport({
    required int company,
    String? filter,
    String? startDate,
    String? endDate,
  });

  Future<BaseResponseModel<List<ItemReportModel>>> customerReport({
    required int company,
    String? filter,
    String? startDate,
    String? endDate,
  });

  Future<BaseResponseModel<ReportCustomerRevenueModel>> customerRevenueReport({
    required int company,
    String? filter,
    String? startDate,
    String? endDate,
  });
}
