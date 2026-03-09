import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/company/cubit/auth_ws_manager_cubit/auth_ws_manager_state.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';

import '../../../../data/models/date_range.model.dart';
import '../../../features/company/cubit/auth_ws_manager_cubit/auth_ws_manager_cubit.dart';
import '../../../features/company/cubit/create_company_cubit/create_company_state.dart';
import '../../blocs/enum/enum_bloc.dart';
import '../../models/dashboard/band.dart';
import '../../models/dashboard/customer_top.dart';
import '../../models/dashboard/employee.dart';
import '../../models/dashboard/order.dart';
import '../../models/dashboard/prd.dart';

class DashboardRepository {
  final _dio = getIt<BaseDio>();

  Future<BaseResponseModel<DashboardOrderModel>> order({
    DateRangeModel? dates,
  }) async {
    try {
      final res = await _dio.get(
        Api.dashboardOrder,
        data: {
          'company': getCompany,
          'type_warehouse__code':
              getIt.get<AuthWsManagerCubit>().state.typeCodeWarehouse,
          ...dates?.toJson ?? {},
        },
      );

      return BaseResponseModel(
        code: res.statusCode,
        data: DashboardOrderModel.fromJson(res.data['details'] ?? {}),
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<DashboardCustomerTopModel>> customerTop(
    SortCustomerDashboard sort,
  ) async {
    try {
      final res = await _dio.get(
        Api.dashboardCustomer,
        data: {'company': getCompany, 'sort': sort.code},
      );

      return BaseResponseModel(
        code: res.statusCode,
        data: DashboardCustomerTopModel.fromJson(res.data['details'] ?? {}),
      );
    } catch (e) {
      print(e);
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<List<PrdDashboardModel>>> prdTop(
    SortPrdDashboard sort,
  ) async {
    try {
      final res = await _dio.get(
        Api.dashboardProduct,
        data: {'company': getCompany, 'sort': sort.code},
      );
      final List<PrdDashboardModel> list = [];
      if (res.data['details'] is List) {
        for (final json in res.data['details']) {
          list.add(PrdDashboardModel.fromJson(json));
        }
      }

      return BaseResponseModel(
        code: res.statusCode,
        data: list,
        extra: int.tryParse(res.data['count'].toString()),
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<List<BrandDashboardModel>>> brand(
    TypeCompany type,
  ) async {
    try {
      final res = await _dio.get(
        Api.dashboardBrand,
        data: {'company': getCompany, 'type': type.code},
      );
      final List<BrandDashboardModel> list = [];
      if (res.data['details'] is List) {
        for (final json in res.data['details']) {
          list.add(BrandDashboardModel.fromJson(json));
        }
      }

      return BaseResponseModel(
        code: res.statusCode,
        data: list,
      );
    } catch (e) {
      print(e);
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<List<DashboardEmployeeModel>>> dataEmployee({
    required SortEmployeeDashboard sort,
    DateRangeModel? dates,
    int? productId,
  }) async {
    try {
      final res = await _dio.get(
        Api.dashboardEmployee,
        data: {
          'company': getCompany,
          'order_by': sort.code,
          'product_id': productId,
          'type_warehouse__code':
              getIt.get<AuthWsManagerCubit>().state.typeCodeWarehouse,
          ...dates?.toJson ?? {},
        },
      );
      final data = (res.data['details'] as List)
          .map((e) => DashboardEmployeeModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.statusCode,
        data: data,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
