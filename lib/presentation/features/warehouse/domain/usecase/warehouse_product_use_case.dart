import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/product/data/mapper/product_entity_mapper.dart';
import 'package:pharmago/presentation/features/warehouse/domain/repositories/warehouse_repository.dart';

import '../../../product/domain/entities/product_entity.dart';

@injectable
class WarehouseProductUseCase
    extends BaseFutureUseCase<WarehouseProductInput, WarehouseProductOutput> {
  WarehouseProductUseCase(
    this._warehouseRepository,
    this._productEntityMapper,
  );

  final WarehouseRepository _warehouseRepository;
  final ProductEntityMapper _productEntityMapper;

  @override
  Future<WarehouseProductOutput> buildUseCase(WarehouseProductInput input) async {
    final res = await _warehouseRepository.getProductWarehouse(input.id);
    final dataEnity = _productEntityMapper.mapToListEntity(res.data);
    final output = WarehouseProductOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEnity,
      ),
    );
    return output;
  }
}

class WarehouseProductInput extends BaseInput {
  final int id;
  WarehouseProductInput({required this.id});
}

class WarehouseProductOutput extends BaseOutput {
  final BaseResponseModel<List<ProductEntity>> response;
  WarehouseProductOutput({required this.response});
}
