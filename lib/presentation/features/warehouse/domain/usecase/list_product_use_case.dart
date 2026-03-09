import 'package:injectable/injectable.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/receipt_import_detail_model.dart';
import 'package:pharmago/presentation/features/warehouse/domain/repositories/warehouse_repository.dart';

@injectable
class ProductsWarehouseUseCase {
  final WarehouseRepository _repository;
  ProductsWarehouseUseCase(
    this._repository,
  );

  Future<List<ProductV3Model>> getProductsWarehouse(
    ProductsWarehouseInput input,
  ) async {
    final res = await _repository.getProductsWarehouse(input);
    return res.data == null ? List.empty() : res.data!;
  }
}

class ProductsWarehouseInput extends BaseInput {
  final int? page;
  final int? company;
  final String? search;

  ProductsWarehouseInput({
    this.page,
    this.company,
    this.search,
  });
}
