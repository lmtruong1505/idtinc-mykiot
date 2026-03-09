import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/product/data/mapper/price_entity_mapper.dart';
import 'package:pharmago/presentation/features/product/domain/entities/price_entity.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/price_repository.dart';

@injectable
class PriceListUseCase
    extends BaseFutureUseCase<PriceListInput, PriceListOutput> {
  PriceListUseCase(
    this._priceRepository,
    this._priceEntityMapper,
  );

  final PriceRepository _priceRepository;
  final PriceEntityMapper _priceEntityMapper;
  @override
  Future<PriceListOutput> buildUseCase(PriceListInput input) async {
    final res = await _priceRepository.getPriceList(
      search: input.search,
      limit: input.limit,
      page: input.page,
      company: input.company,
    );
    final dataEntity = _priceEntityMapper.mapToListEntity(res.data);
    final output = PriceListOutput(
        response: BaseResponseModel(
      code: res.code,
      message: res.message,
      data: dataEntity,
    ));
    return output;
  }
}

class PriceListInput extends BaseInput {
  final String search;
  final int limit;
  final int page;
  final int? company;

  PriceListInput({
    required this.search,
    required this.limit,
    required this.page,
    required this.company,
  });
}

class PriceListOutput extends BaseOutput {
  final BaseResponseModel<List<PriceEntity>> response;

  PriceListOutput({required this.response});
}
