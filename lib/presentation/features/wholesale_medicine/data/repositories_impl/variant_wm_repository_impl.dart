import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/apis/end_point.dart';
import '../../../../../data/config/dio.dart';
import '../../../../../data/models/base/response.dart';
import '../../domain/entities/variant_wm_entity.dart';
import '../../domain/repositories/variant_wm_repository.dart';
import '../mapper/variant_wm_mapper.dart';
import '../models/variant_wm_model.dart';

@LazySingleton(as: VariantWmRepository)
class VariantWmRepositoryImpl extends VariantWmRepository {
  VariantWmRepositoryImpl(this._dio, this._mapper);

  final BaseDio _dio;
  final VariantWmMapper _mapper;

  @override
  Future<BaseResponseModel<List<VariantWmModel>>> getList(
    int? page,
    int? limit,
    String? searchKey,
    String? tag,
    bool? status,
    int? customer,
    int? account,
  ) async {
    try {
      final query = {
        'search': searchKey,
        'tag': tag,
      };
      query.removeWhere((key, value) => value == '' || value == null);
      final res = await _dio.getWithUrl(Api.variantWm, data: query);
      final dataModel = (res.data['data'] as List)
          .map((e) => VariantWmModel.fromJson(e))
          .toList();
      return BaseResponseModel<List<VariantWmModel>>(
        code: res.statusCode,
        message: res.statusMessage,
        data: dataModel,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel<List<VariantWmModel>>(
        code: 500,
        message: e.toString(),
        data: [],
      );
    }
  }

  @override
  Future<BaseResponseModel<VariantWmEntity>> getVariantDetail(int id) async {
    final res = await _dio.get('${Api.variantDetailWm}$id/');
    VariantWmModel? dataModel;
    if (res.data['code'] == 200) {
      dataModel = VariantWmModel.fromJson(res.data['data']);
    }
    return BaseResponseModel<VariantWmEntity>(
      code: res.data['code'],
      message: res.data['message'],
      data: _mapper.mapToEntity(dataModel),
    );
  }

  @override
  Future<BaseResponseModel<List<VariantWmModel>>> getListPromotion({
    required int page,
    required int limit,
    required String searchKey,
  }) async {
    final res = await _dio.get(
        '${Api.variantPromotionWm}?limit=$limit&page=$page&title__icontains=$searchKey');
    return BaseResponseModel(
      code: res.data['code'],
      message: res.data['message'],
      data: (res.data['data'] as List)
          .map((e) => VariantWmModel.fromJson(e))
          .toList(),
    );
  }
}
