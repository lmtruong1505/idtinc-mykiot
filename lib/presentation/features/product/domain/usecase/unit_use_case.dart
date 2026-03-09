import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/product/data/mapper/unit_entity_mapper.dart';
import 'package:pharmago/presentation/features/product/domain/entities/unit_entity.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/variant_repository.dart';

@injectable
class UnitUseCase extends BaseFutureUseCase<UnitInput, UnitOutput> {
  UnitUseCase(
    this._variantRepositoty,
    this._unitEntityMapper,
  );

  final VariantRepositoty _variantRepositoty;
  final UnitEnityMapper _unitEntityMapper;

  @override
  Future<UnitOutput> buildUseCase(UnitInput input) async {
    final res = await _variantRepositoty.getUnit(
      product: input.idProduct,
    );
    final dataEntity = _unitEntityMapper.mapToEntity(res.data);
    final output = UnitOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class UnitInput extends BaseInput {
  final int idProduct;
  UnitInput({required this.idProduct});
}

class UnitOutput extends BaseOutput {
  final BaseResponseModel<UnitEntity> response;
  UnitOutput({required this.response});
}
