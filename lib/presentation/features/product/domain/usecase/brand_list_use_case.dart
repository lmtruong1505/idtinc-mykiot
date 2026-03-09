import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/product/data/mapper/brand_entity_mapper.dart';
import 'package:pharmago/presentation/features/product/domain/entities/brand_entity.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/brand_repository.dart';

@injectable
class BrandListUseCase
    extends BaseFutureUseCase<BrandListInput, BrandListOutput> {
  BrandListUseCase(
    this._brandRepository,
    this._brandEntityMapper,
  );
  final BrandRepository _brandRepository;
  final BrandEntityMapper _brandEntityMapper;

  @override
  Future<BrandListOutput> buildUseCase(BrandListInput input) async {
    final res = await _brandRepository.getList(
      search: input.search,
      limit: input.limit,
      page: input.page,
      company: input.company,
    );
    final dataEntity = _brandEntityMapper.mapToListEntity(res.data);
    final output = BrandListOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class BrandListInput extends BaseInput {
  final int? company;
  final String? search;
  final int? page;
  final int? limit;

  BrandListInput({
    this.company,
    this.limit,
    this.page,
    this.search,
  });
}

class BrandListOutput extends BaseOutput {
  final BaseResponseModel<List<BrandEntity>> response;
  BrandListOutput({required this.response});
}
