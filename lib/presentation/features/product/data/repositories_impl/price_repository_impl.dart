import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/product/data/models/price_model.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/price_repository.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/price_update_use_case.dart';

@LazySingleton(as: PriceRepository)
class PriceRepositoryImpl extends PriceRepository {
  PriceRepositoryImpl(this._dio);
  final BaseDio _dio;

  @override
  Future<BaseResponseModel<List<PriceModel>>> getPriceList({
    required String search,
    required int limit,
    required int page,
    required int? company,
  }) async {
    try {
      final query = {
        'page': page,
        'limit': limit,
        'company': company,
        'search': search,
      };
      final res = await _dio.get(Api.priceList, data: query);
      final data = (res.data['details'] as List)
          .map((e) => PriceModel.fromJson(e))
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
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<PriceModel>> updatePrice(
      PriceUpdateInput input) async {
    try {
      final payload = {
        'id': input.id,
        'priceImport': input.priceImportNew,
        'priceSell': input.priceSellNew,
      };
      final res = await _dio.put(Api.priceUpdate, data: payload);
      PriceModel? data;
      final dataRes = res.data['details'];
      if (dataRes != null) {
        data = PriceModel.fromJson(res.data['details']);
      }
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
}
