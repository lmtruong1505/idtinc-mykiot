import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/apis/end_point.dart';
import '../../../../../data/config/dio.dart';
import '../../../../../data/models/base/response.dart';
import '../../domain/repositories/promotion_wm_repository.dart';
import '../models/promotion_model.dart';

@LazySingleton(as: PromotionRepository)
class PromotionRepositoryImpl extends PromotionRepository {
  final BaseDio _baseDio;
  PromotionRepositoryImpl(this._baseDio);

  @override
  Future<BaseResponseModel<List<PromotionDetailModel>>> getListPromotion({
    required int company,
    int? variantId,
    int? orderValue,
    int? customer,
  }) async {
    try {
      final query = {
        'customer_id': customer,
        'company': company,
        'variant_id': variantId,
        'order_value': orderValue,
        'promotion_type__code': 'GTDH',
        'tag': 'PMG',
      };
      query.removeWhere((key, value) => value == null || value == '');
      final res = await _baseDio.getWithUrl(
        Api.promotions,
        data: query,
      );
      final data = (res.data['data'] as List)
          .map((e) => PromotionDetailModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(
        code: 400,
        message: 'err : $e',
      );
    }
  }

  @override
  Future<BaseResponseModel<PromotionDetailModel>> getDetailPromotion(
    int id,
  ) async {
    try {
      final res = await _baseDio.getWithUrl('${Api.promotions}$id/');
      final data = PromotionDetailModel.fromJson(res.data['data']);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: 'err: $e',
      );
    }
  }

  @override
  Future<BaseResponseModel<List<PromotionDetailModel>>> getListDetailPromotion({
    int? idVariant,
    String? tag,
    int? orderValue,
  }) async {
    final payload = {
      'variant_id': idVariant,
      'status__code': 'ĐAD',
      'tag': tag,
      'order_value': orderValue,
      'promotion_type__code': 'GTDH',
    };
    payload.removeWhere((key, value) => value == null);
    if (orderValue == null) {
      payload.remove('promotion_type__code');
    }
    try {
      final res = await _baseDio.getWithUrl(
        Api.promotions,
        data: payload,
      );
      final data = (res.data['data'] as List)
          .map((e) => PromotionDetailModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(
        code: 400,
        message: 'err : $e',
      );
    }
  }
}
