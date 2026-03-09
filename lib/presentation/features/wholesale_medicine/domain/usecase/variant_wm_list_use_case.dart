import 'package:injectable/injectable.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../../data/mapper/variant_wm_mapper.dart';
import '../entities/variant_wm_entity.dart';
import '../repositories/variant_wm_repository.dart';

@injectable
class VariantWmListUseCase
    extends BaseFutureUseCase<VariantWmListInput, VariantWmListOutput> {
  VariantWmListUseCase(
    this._variantRepository,
    this._variantCreateOrderMapper,
  );
  final VariantWmRepository _variantRepository;
  final VariantWmMapper _variantCreateOrderMapper;
  @override
  Future<VariantWmListOutput> buildUseCase(VariantWmListInput input) async {
    final res = await _variantRepository.getList(
      input.page,
      input.limit,
      input.searchKey,
      input.tag,
      input.status,
      input.customer,
      input.account,
    );
    final dataEntity = _variantCreateOrderMapper.mapToListEntity(res.data);
    return VariantWmListOutput(
      BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
      BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
  }
}

class VariantWmListInput extends BaseInput {
  final int? page;
  final int? limit;
  final String? searchKey;
  final String? tag;
  final bool? status;
  final int? customer;
  final int? account;
  VariantWmListInput({
    this.limit,
    this.page,
    this.searchKey,
    this.tag,
    this.status,
    this.customer,
    this.account,
  });
}

class VariantWmListOutput extends BaseOutput {
  final BaseResponseModel<List<VariantWmEntity>> response;
  final BaseResponseModel<List<VariantWmEntity>> responseEntity;
  VariantWmListOutput(this.response, this.responseEntity);
}
