import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';
import 'package:pharmago/presentation/features_v2/models/customer/file_model.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../models/customer/product_customer_mode.dart';
import '../../models/customer/service_customer_model.dart';
import '../../models/customer/v2/create_model.dart';
import '../../models/customer/v2/customer_model.dart';
import '../../models/customer/v2/customer_point_item_model.dart';

@injectable
class CustomerRepositoryV2 {
  final _dio = getIt<BaseDio>();

  Future<BaseResponseModel<int>> create(CreateCustomerV2Model param) async {
    try {
      final res = await _dio.post(
        Api.customerCreate,
        data: param.toJson(),
      );

      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'].toString(),
        data: int.tryParse(res.data['details'].toString()),
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<int>> update(
    int id,
    CreateCustomerV2Model param,
  ) async {
    try {
      final res = await _dio.put(
        Api.customerDetail + id.toString(),
        data: param.toJson(),
      );

      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'].toString(),
        data: int.tryParse(res.data['details'].toString()),
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<int>> delete(
    int id,
  ) async {
    try {
      final res = await _dio.delete(
        Api.customerDetail + id.toString(),
      );

      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'].toString(),
        data: int.tryParse(res.data['details'].toString()),
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<List<CustomerV2Model>>> getList({
    required int companyId,
    int page = 1,
    int limit = 20,
    String? search,
    bool? isZalo,
    String? typeOrder,
    int? maxPrice,
    int? minPrice,
    String? type,
    bool? isDebt,
    int? parentCustomer,
  }) async {
    try {
      final param = {
        'company': companyId,
        'page': page,
        'limit': limit,
        'search': search,
        'type_order': typeOrder,
        'max_price': maxPrice,
        'min_price': minPrice,
        'is_care_zalooa': isZalo,
        'type': type,
        'is_debt': isDebt,
        'parent_customer': parentCustomer,
      };

      param.removeWhere(
        (key, value) => value.toString().isEmptyOrNull,
      );
      final res = await _dio.get(Api.customerList, data: param);
      final List<CustomerV2Model> list = [];

      if (res.data['details'] is List) {
        for (final json in res.data['details']) {
          list.add(CustomerV2Model.fromJson(json));
        }
      }
      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'].toString(),
        data: list,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<CustomerV2Model>> detail(int id) async {
    try {
      final res = await _dio.get(
        Api.customerDetail + id.toString(),
      );

      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'].toString(),
        data: CustomerV2Model.fromJson(res.data['details'] ?? {}),
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<List<CustomerPointItemModel>>> customerPoint(
    int id,
    int page,
  ) async {
    try {
      final res = await _dio.get(
        Api.customerPoint,
        data: {
          'customer': id,
          'workspace': getCompany,
          'page': page,
          'limit': 20,
        },
      );
      final data = (res.data['data'] as List)
          .map((e) => CustomerPointItemModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'].toString(),
        data: data,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<List<ServiceCustomerModel>>> getService({
    required int page,
    required int customerId,
    int limit = 20,
  }) async {
    try {
      final res = await _dio.get(
        '${Api.customerDetail}$customerId/service-used',
        data: {
          'page': page,
          'limit': limit,
        },
      );
      final List<ServiceCustomerModel> list = [];
      if (res.data['details'] is List) {
        for (final json in res.data['details']) {
          list.add(ServiceCustomerModel.fromJson(json));
        }
      }
      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'].toString(),
        data: list,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<List<ProductCustomerModel>>> getProduct({
    required int page,
    required int customerId,
    int limit = 20,
  }) async {
    try {
      final res = await _dio.get(
        '${Api.customerDetail}$customerId/product-used',
        data: {
          'page': page,
          'limit': limit,
        },
      );
      final List<ProductCustomerModel> list = [];
      if (res.data['details'] is List) {
        for (final json in res.data['details']) {
          list.add(ProductCustomerModel.fromJson(json));
        }
      }
      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'],
        data: list,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<List<FileModel>>> getFiles({
    required int customerId,
    required int companyId,
    String? uuidBill,
    String? uuidEvent,
    TypeFileCustomer? type,
  }) async {
    try {
      final payload = {
        'customer': customerId,
        'company': companyId,
        'type': type?.code,
        'medical_bill': uuidBill,
        'appointmentSchedule': uuidEvent,
      };
      payload.removeWhere(
        (key, value) => value == null,
      );

      final res = await _dio.get(
        Api.getMedicalRecord,
        data: payload,
      );

      final List<FileModel> list = [];
      if (res.data['details'] is List) {
        for (final json in res.data['details']) {
          list.add(FileModel.fromJson(json));
        }
      }
      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'],
        data: list,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
