import 'package:dio/dio.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features_v2/models/service/service.dart';

class ServiceV2Repository {
  final _dio = getIt<BaseDio>();

  Future<BaseResponseModel<List<ServiceV2Model>>> getList({
    required int? companyId,
    int page = 1,
    int limit = 20,
    String? search,
    String? type,
    bool? isActive,
    int? priceMin,
    int? priceMax,
    List<int>? ids,
    bool? splitUnit,
  }) async {
    try {
      final Map<String, dynamic> params = {
        'workspace': companyId,
        'page': page,
        'limit': limit,
        'search': search,
        'active': isActive,
        'price_min': priceMin,
        'price_max': priceMax,
        'service_type': type,
        'ids': ids,
        'split_unit': splitUnit,
      };
      params.removeWhere(
        (key, value) => value == null || value == '',
      );
      final List<ServiceV2Model> list = [];
      final res = await _dio.get(
        Api.serviceList,
        data: params,
      );
      if (res.data['details'] is List) {
        for (final json in res.data['details']) {
          list.add(ServiceV2Model.fromJson(json));
        }
      }
      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'],
        data: list,
        extra: res.data['count'],
      );
    } catch (e) {
      print(e);
      return BaseResponseModel(
        code: 500,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<List<ServiceTypeV2Model>>> getType() async {
    try {
      final List<ServiceTypeV2Model> list = [];
      final res = await _dio.get(
        Api.serviceTypes,
      );
      if (res.data['details'] is List) {
        if (res.data['details'] is List) {
          for (final json in res.data['details']) {
            final model = ServiceTypeV2Model.fromJson(json);
            if (model.type == 'SINGLE') {
              model.description =
                  'Dịch vụ cho phép sử dụng dịch vụ một lần duy nhất\nVD: Lượt khám, lượt tập';
            } else if (model.type == 'MEMBERSHIP') {
              model.description =
                  'Dịch vụ cho phép sử dụng trong một khoảng thời gian nhất định. Có thể giới hạn lượt sử dụng hoặc không.\nVD: Vé giờ, vé ngày, vé tháng...';
            } else if (model.type == 'TREATMENT') {
              model.description =
                  'Dịch vụ bao gồm nhiều lượt sử dụng dịch vụ, theo kế hoạch cố định để hoàn thành một liệu trình.\nVD: Liệu trình điều trị, khóa học.';
            }
            list.add(model);
          }
        }
      }

      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'],
        data: list,
      );
    } catch (e) {
      print(e);
      return BaseResponseModel(
        code: 500,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> create(CreateServiceV2Model param) async {
    try {
      final payload = param.toMap();
      payload.removeWhere(
        (key, value) => value == null || value == '',
      );

      final data = FormData.fromMap(payload);

      final res = await _dio.post(
        Api.createService,
        data: data,
      );

      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'],
        data: res.data['details'],
      );
    } catch (e) {
      print(e);

      return BaseResponseModel(
        code: 500,
        message: e is DioException ? e.message : e.toString(),
      );
    }
  }

  Future<BaseResponseModel> update(int id, CreateServiceV2Model param) async {
    try {
      final payload = param.toMap();
      payload.removeWhere(
        (key, value) => value == null || value == '',
      );

      final data = FormData.fromMap(payload);

      final res = await _dio.put(
        '${Api.serviceDetail}/$id',
        data: data,
      );

      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'],
        data: res.data['details'],
      );
    } catch (e) {
      print(e);

      return BaseResponseModel(
        code: 500,
        message: e is DioException ? e.message : e.toString(),
      );
    }
  }

  Future<BaseResponseModel> updateStatus(int id) async {
    try {
      final res = await _dio.patch(
        '${Api.serviceDetail}/$id',
      );

      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'],
        data: res.data['details'],
      );
    } catch (e) {
      print(e);

      return BaseResponseModel(
        code: 500,
        message: e is DioException ? e.message : e.toString(),
      );
    }
  }

  Future<BaseResponseModel> remove(int id) async {
    try {
      final res = await _dio.delete(
        '${Api.serviceDetail}/$id',
      );

      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'],
        data: res.data['details'],
      );
    } catch (e) {
      print(e);

      return BaseResponseModel(
        code: 500,
        message: e is DioException ? e.message : e.toString(),
      );
    }
  }

  Future<BaseResponseModel<DetailServiceV2Model>> detail(int id) async {
    try {
      final res = await _dio.get(
        '${Api.serviceDetail}/$id',
      );

      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'],
        data: res.data['details'] != null
            ? DetailServiceV2Model.fromJson(res.data['details'] ?? {})
            : null,
      );
    } catch (e) {
      print(e);

      return BaseResponseModel(
        code: 500,
        message: e is DioException ? e.message : e.toString(),
      );
    }
  }
}
