import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/presentation/features/product/data/models/drug_filter_model.dart';
import 'package:pharmago/presentation/features/product/data/models/media_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/wholesale_drug_maket/wholesale_drug_market_v2_bloc.dart';
import 'package:pharmago/presentation/features_v2/models/variant_kafa/variant_kafa_model.dart';

import '../../../../data/config/dio.dart';
import '../../../../data/models/base/response.dart';
import '../../../di/di.dart';

@injectable
class WholesaleDrugRepo {
  final _dio = getIt<BaseDio>();
  Future<BaseResponseModel<List<VariantKafaPreviewModel>>> getVariants({
    String? search,
    int? page,
    int? limit,
    String? sort,
    String? orderBy,
    double? maxPrice,
    double? minPrice,
    int? category,
    int? group,
    DrugPrdV2Type? type,
    int? brand,
    int? customer,
    List<int>? services,
    bool? isPromotion = false,
  }) async {
    try {
      final params = {
        'search': search,
        'page': page,
        'limit': limit,
        'sort': sort,
        'tag': 'PMG',
        'price_sell__lte': maxPrice,
        'price_sell__gte': minPrice,
        'product__brand': brand,
        'promotion__isnull': isPromotion == true ? false : null,
        'product__category': category,
        'product__productgroup': group,
        'order_by': orderBy,
      };
      params.removeWhere((key, value) => value == null || value == '');
      final res = await _dio.get(Api.variantKafa, data: params);
      final models = res.data['details']
          .map<VariantKafaPreviewModel>(
            (e) => VariantKafaPreviewModel.fromJson(e),
          )
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

  Future<BaseResponseModel<List<MediaDatum>>> getBanners() async {
    try {
      final res = await _dio.get(Api.banners);
      final models = (res.data['data'] as List)
          .map((e) => MediaDatum.fromJson(e))
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

  Future<BaseResponseModel<DrugFilterModel>> getDrugFilter() async {
    try {
      final res = await _dio.get(Api.drugFilter);
      final models = DrugFilterModel.fromJson(res.data['details']);
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
      );
    }
  }
}
