import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/wholesale_medicine/data/models/order_wm_model.dart';
import 'package:pharmago/presentation/features/wholesale_medicine/data/models/order_wm_payload_model.dart';

import '../../../../../data/apis/end_point.dart';
import '../../../../../data/config/dio.dart';
import '../../../../../data/models/base/response.dart';
import '../../domain/repositories/order_wm_repository.dart';
import '../models/order_wm_count_filter_model.dart';

@LazySingleton(as: OrderWmRepository)
class OrderWmRepositoryImpl extends OrderWmRepository {
  final BaseDio baseDio;

  OrderWmRepositoryImpl(this.baseDio);

  @override
  Future<BaseResponseModel<int>> createOrder(
    OrderWmPayloadModel payload,
  ) async {
    try {
      final data = payload.toJson();
      for (final item in data['orderitem'] as List<dynamic>) {
        item.removeWhere((key, value) => value == null);
      }
      final res = await baseDio.postWithUrl(Api.orderWm, data: data);
      var resModel = BaseResponseModel<int>(
        code: res.data['code'],
        message: res.data['message'],
        data: null,
      );
      if (res.data['code'] == 200) {
        resModel = resModel.copyWith(
          data: res.data['data']['id'],
        );
      }
      return resModel;
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      return BaseResponseModel<int>(
        code: 400,
        message: e.toString(),
        data: null,
      );
    }
  }

  @override
  Future<BaseResponseModel<List<OrderWmDetailModel>>> list({
    int? page,
    int? limit,
    String? search,
    int? status,
  }) async {
    try {
      final data = {
        'page': page,
        'limit': limit,
        'search': search,
        'status': status,
        'tag': 'PMG',
      };
      data.removeWhere((key, value) => value == null);
      final res = await baseDio.getWithUrl(Api.orderWm, data: data);
      final dataRes = (res.data['data'] as List)
          .map((e) => OrderWmDetailModel.fromJson(e))
          .toList();
      return BaseResponseModel<List<OrderWmDetailModel>>(
        code: res.data['code'],
        message: res.data['message'],
        data: dataRes,
      );
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      return BaseResponseModel<List<OrderWmDetailModel>>(
        code: 400,
        message: e.toString(),
      );
    }
  }
  
  @override
  Future<BaseResponseModel<OrderWmDetailModel>> detail({required int id}) async {
    try {
      final data = {
        'tag': 'PMG',
      };
      final res = await baseDio.getWithUrl('${Api.orderWm}$id', data: data);
      final dataRes = OrderWmDetailModel.fromJson(res.data['data']);
      print(res.data['data']['discount_order']);
      print(dataRes.discountOrder);
      return BaseResponseModel<OrderWmDetailModel>(
        code: res.data['code'],
        message: res.data['message'],
        data: dataRes,
      );
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      return BaseResponseModel<OrderWmDetailModel>(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<List<OrderCountFilterModel>>>
      getCountFilter() async {
    final res =
        await baseDio.getWithUrl('${Api.orderCountFilter}?tag=PMG');
    final data = (res.data['data'] as List)
        .map((e) => OrderCountFilterModel.fromJson(e))
        .toList();
    return BaseResponseModel(
      code: res.data['code'],
      message: res.data['message'],
      data: data,
    );
  }
}
