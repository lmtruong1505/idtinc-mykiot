import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/product/data/mapper/variant_entity_mapper.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_entity.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/variant_repository.dart';

@injectable
class VariantListUseCase
    extends BaseFutureUseCase<VariantListInput, VariantListOutput> {
  VariantListUseCase(this._variantEntityMapper, this._variantRepositoty);
  final VariantEntityMapper _variantEntityMapper;
  final VariantRepositoty _variantRepositoty;

  @override
  Future<VariantListOutput> buildUseCase(VariantListInput input) async {
    final res = await _variantRepositoty.getVariants(
      page: input.page,
      limit: input.limit,
      search: input.search,
      company: input.company,
      filter: input.filter,
      active: true,
    );
    final dataEntity = _variantEntityMapper.mapToListEntity(res.data);
    final output = VariantListOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class VariantListInput extends BaseInput {
  final int page;
  final int limit;
  final String search;
  final int company;
  String? filter;
  VariantListInput({
    required this.company,
    required this.limit,
    required this.page,
    required this.search,
    this.filter,
  });
}

class VariantListOutput extends BaseOutput {
  final BaseResponseModel<List<VariantEntity>> response;
  VariantListOutput({required this.response});
}
