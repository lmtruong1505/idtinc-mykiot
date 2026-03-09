import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/product/data/mapper/variant_warehouse_entity_mapper.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_warehouse_entity.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/variant_repository.dart';

@injectable
class VariantWarehouseListUseCase extends BaseFutureUseCase<
    VariantWarehouseListInput, VariantWarehouseListOutput> {
  VariantWarehouseListUseCase(
      this._variantRepositoty, this._variantWarehouseEntityMapper);

  final VariantRepositoty _variantRepositoty;
  final VariantWarehouseEntityMapper _variantWarehouseEntityMapper;

  @override
  Future<VariantWarehouseListOutput> buildUseCase(
      VariantWarehouseListInput input) async {
    final res = await _variantRepositoty.getVariantsWarehouse(
      page: input.page,
      limit: input.limit,
      search: input.search,
      company: input.company,
    );
    final dataEntity = _variantWarehouseEntityMapper.mapToListEntity(res.data);
    final output = VariantWarehouseListOutput(
        response: BaseResponseModel(
      code: res.code,
      message: res.message,
      data: dataEntity,
    ));
    return output;
  }
}

class VariantWarehouseListInput extends BaseInput {
  final int page;
  final int limit;
  final String search;
  final int company;
  VariantWarehouseListInput({
    required this.company,
    required this.limit,
    required this.page,
    required this.search,
  });
}

class VariantWarehouseListOutput extends BaseOutput {
  final BaseResponseModel<List<VariantWarehouseEntity>> response;
  VariantWarehouseListOutput({
    required this.response,
  });
}
