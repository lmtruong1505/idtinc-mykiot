import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_item_entity.dart';
import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../../data/mapper/address_item_mapper.dart';
import '../repositories/address_repository.dart';

@injectable
class GetProvinceUseCase
    extends BaseFutureUseCase<GetProvinceInput, GetProvinceOutput> {
  GetProvinceUseCase(this._addressRepository, this._addressItemMapper);
  final AddressRepository _addressRepository;
  final AddressItemMapper _addressItemMapper;

  @override
  Future<GetProvinceOutput> buildUseCase(GetProvinceInput input) async {
    final res = await _addressRepository.getProvinces();
    final dataEntity = _addressItemMapper.mapToListEntity(res.data);
    final output = GetProvinceOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class GetProvinceInput extends BaseInput {}

class GetProvinceOutput extends BaseOutput {
  final BaseResponseModel<List<AddressItemEntity>> response;
  GetProvinceOutput({required this.response});
}
