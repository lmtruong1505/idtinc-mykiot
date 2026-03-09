import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/di/di.dart';

import '../../../../data/apis/end_point.dart';
import '../../models/kafa/kafa_order_detail.dart';
import '../../models/kafa/kafa_order_model.dart';

class KafaRepository {
  final _dio = getIt<BaseDio>();
  Future<BaseResponseModel<List<KafaOrderModel>>> getOrder({
    required int company,
    String? search,
    String? statusOrder,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final req = {
        'company': company,
        'page': page,
        'limit': limit,
        'search': search,
        'status': statusOrder,
      };
      req.removeWhere(
        (key, value) => value == null,
      );
      final res = await _dio.get(
        Api.kafaOrder,
        data: req,
      );
      final List<KafaOrderModel> list = [];

      if (res.data['details'] is List) {
        for (final json in res.data['details']) {
          list.add(KafaOrderModel.fromJson(json));
        }
      }
      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
        data: list,
        extra: res.data['count'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<KafaOrderDetailModel>> detail(int id) async {
    try {
      final res = await _dio.get(
        '${Api.kafaOrder}/$id',
      );

      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
        data: KafaOrderDetailModel.fromJson(res.data['details'] ?? {}),
      );
    } catch (e) {
      print(e);
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> cancel(int id) async {
    try {
      final res = await _dio.delete(
        '${Api.kafaOrder}/$id',
      );

      return BaseResponseModel(
        code: res.data['code'] ?? res.statusCode,
        message: res.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
