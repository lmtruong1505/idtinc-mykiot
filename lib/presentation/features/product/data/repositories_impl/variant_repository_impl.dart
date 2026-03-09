import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/product/data/models/unit_model.dart';
import 'package:pharmago/presentation/features/product/data/models/variant_model.dart';
import 'package:pharmago/presentation/features/product/data/models/variant_warehouse_model.dart';

import '../../../../../data/apis/end_point.dart';
import '../../domain/repositories/variant_repository.dart';

@LazySingleton(as: VariantRepositoty)
class VariantRepositotyImpl extends VariantRepositoty {
  VariantRepositotyImpl(this._dio);
  final BaseDio _dio;

  @override
  Future<BaseResponseModel<List<VariantModel>>> getVariants({
    required int page,
    required int limit,
    required String search,
    required int company,
    String? filter,
    bool? active,
  }) async {
    try {
      final res = await _dio.get(
        '${Api.product}/variant/list',
        data: {
          'page': page,
          'limit': limit,
          'search': search,
          'company': company,
          'filter': filter,
          'active': active,
        },
      );
      final data = (res.data['details'] as List)
          .map((e) => VariantModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<List<VariantWarehouseModel>>> getVariantsWarehouse({
    required int page,
    required int limit,
    required String search,
    required int company,
  }) async {
    try {
      final res = await _dio.get(
        Api.brand,
        data: {
          'page': page,
          'limit': limit,
          'search': search,
          'company': company,
        },
      );
      final data = (res.data['details'] as List)
          .map((e) => VariantWarehouseModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<UnitModel>> getUnit({required int product}) async {
    try {
      final res = await _dio.get(Api.brand, data: {'product': product});
      final data = UnitModel.fromJson(res.data['details']);
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
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel> importVariant({required Map data}) async {
    try {
      final res = await _dio.post(Api.brand, data: data);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }
}
