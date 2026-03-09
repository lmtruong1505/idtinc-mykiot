import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/inventory_model.dart';
import 'package:pharmago/presentation/features/warehouse/domain/repositories/inventory_repository.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/inventory_use_case.dart';

@LazySingleton(as: InventoryRepository)
class InventoryRepositoryImpl extends InventoryRepository {
  InventoryRepositoryImpl(this._dio);
  final BaseDio _dio;

  @override
  Future<BaseResponseModel<List<InventoryModel>>> getList(
      InventoryInput input) async {
    try {
      final query = {
        'page': input.page,
        'limit': input.limit,
        'company': input.company,
        'search': input.search,
        'warehouse': input.warehouseId,
      };
      final res = await _dio.get(Api.inventoryList, data: query);
      final data = (res.data['details'] as List)
          .map((e) => InventoryModel.fromJson(e))
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
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }
}
