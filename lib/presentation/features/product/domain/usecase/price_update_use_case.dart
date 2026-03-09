import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/product/data/mapper/price_entity_mapper.dart';
import 'package:pharmago/presentation/features/product/domain/entities/price_entity.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/price_repository.dart';

@injectable
class PriceUpdateUseCase
    extends BaseFutureUseCase<PriceUpdateInput, PriceUpdateOutput> {
  PriceUpdateUseCase(
    this._priceRepository,
    this._priceEntityMapper,
  );
  final PriceRepository _priceRepository;
  final PriceEntityMapper _priceEntityMapper;
  @override
  Future<PriceUpdateOutput> buildUseCase(PriceUpdateInput input) async {
    final res = await _priceRepository.updatePrice(input);
    final dataEntity = _priceEntityMapper.mapToEntity(res.data);
    final output = PriceUpdateOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class PriceUpdateInput extends BaseInput {
  final int id;
  final int priceImportNew;
  final int priceSellNew;
  PriceUpdateInput(this.id, this.priceImportNew, this.priceSellNew);
}

class PriceUpdateOutput extends BaseOutput {
  final BaseResponseModel<PriceEntity> response;
  PriceUpdateOutput({required this.response});
}
