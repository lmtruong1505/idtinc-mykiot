import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/product/data/models/unit_model.dart';
import 'package:pharmago/presentation/features/product/data/models/variant_model.dart';
import 'package:pharmago/presentation/features/product/data/models/variant_warehouse_model.dart';

abstract class VariantRepositoty {
  Future<BaseResponseModel<List<VariantModel>>> getVariants({
    required int page,
    required int limit,
    required String search,
    required int company,
    String? filter,
    bool? active,
  });

  Future<BaseResponseModel<List<VariantWarehouseModel>>> getVariantsWarehouse({
    required int page,
    required int limit,
    required String search,
    required int company,
  });

  Future<BaseResponseModel<UnitModel>> getUnit({
    required int product,
  });

  Future<BaseResponseModel> importVariant({
    required Map data,
  });
}
