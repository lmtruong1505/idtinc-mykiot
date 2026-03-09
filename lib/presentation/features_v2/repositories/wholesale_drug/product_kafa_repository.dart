import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/apis/end_point.dart';
import '../../../../data/config/dio.dart';
import '../../../../data/models/base/response.dart';
import '../../../di/di.dart';
import '../../models/variant_kafa/promotion_kafa_model.dart';

@injectable
class VariantKafaRepository {
  final _dio = getIt<BaseDio>();

  Future<BaseResponseModel<List<PromotionDetailModel>>> getListProduct({
    required int variant,
  }) async {
    try {
      final res = await _dio.get(Api.promotions);
      final models = (res.data['data'] as List)
          .map((e) => PromotionDetailModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        data: models,
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: [],
      );
    }
  }
}
