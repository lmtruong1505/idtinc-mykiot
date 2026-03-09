import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/report/data/models/home_report_model.dart';
import 'package:pharmago/presentation/features/report/data/models/item_report_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../domain/repositories/report_repository.dart';
import '../models/revenue_report_model.dart';

@LazySingleton(as: ReportRepository)
class ReportRepositoryImpl extends ReportRepository {
  ReportRepositoryImpl(this._dio);

  final BaseDio _dio;

  @override
  Future<BaseResponseModel<HomeReportModel>> homeReport({
    required int company,
  }) async {
    try {
      final res = await _dio.get(
        Api.reportHome,
        data: {
          'company': company,
        },
      );
      final data = HomeReportModel.fromJson(res.data);
      return BaseResponseModel(
        code: res.statusCode,
        message: 'success',
        data: data,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<List<RevenueReportModel>>> revenueReport({
    required int company,
    required String filter,
  }) async {
    try {
      final res = await _dio.get(
        Api.reportRevenue,
        data: {
          'company': company,
          'filter': filter,
        },
      );
      final data = (res.data['details'] as List)
          .map((e) => RevenueReportModel.fromJson(e))
          .toList();
      print(res);
      return BaseResponseModel(
        code: res.statusCode,
        message: 'success',
        data: data,
        extra: {
          'current_value': res.data['current_value'],
          'last_value': res.data['last_value'],
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<List<ItemReportModel>>> orderReport({
    required int company,
    String? filter,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final args = {
        'company': company,
        'filter': filter,
        'start_date': startDate,
        'end_date': endDate,
      };
      args.removeWhere((key, value) => value == null || value == '');
      final res = await _dio.get(
        Api.reportOrder,
        data: args,
      );
      final data = (res.data['details'] as List)
          .map((e) => ItemReportModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
        extra: {
          'current_value': res.data['current_value'],
          'last_value': res.data['last_value'],
        },
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<List<ItemReportModel>>> customerReport({
    required int company,
    String? filter,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final args = {
        'company': company,
        'filter': filter,
        'start_date': startDate,
        'end_date': endDate,
      };
      args.removeWhere((key, value) => value == null || value == '');
      final res = await _dio.get(
        Api.reportCustomer,
        data: args,
      );
      final data = (res.data['details'] as List)
          .map((e) => ItemReportModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
        extra: {
          'current_value': res.data['current_value'],
          'last_value': res.data['last_value'],
        },
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<ReportCustomerRevenueModel>> customerRevenueReport({
    required int company,
    String? filter,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final args = {
        'company': company,
        'order_by': filter,
        'start_date': startDate,
        'end_date': endDate,
      };
      args.removeWhere((key, value) => value == null || value == '');
      final res = await _dio.get(
        Api.reportCustomerRevenue,
        data: args,
      );
      ReportCustomerRevenueModel data =
          ReportCustomerRevenueModel.fromJson(res.data);
      final num revenue = data.details?.fold(
            0,
            (previousValue, element) =>
                previousValue.validator + element.revenue.validator,
          ) ??
          0;
      final num averageRevenue = revenue / (data.details ?? []).length;
      data = data.copyWith(averageRevenue: averageRevenue);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
