import 'package:injectable/injectable.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/presentation/features/customer/data/mapper/customer_group_entity_mapper.dart';
import 'package:pharmago/presentation/features/customer/domain/repositories/customer_group_repository.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../entities/customer_group_entity.dart';

@injectable
class CustomerGroupDetailUseCase extends BaseFutureUseCase<
    CustomerGroupDetailInput, CustomerGroupDetailOutput> {
  CustomerGroupDetailUseCase(
    this._customerGroupRepository,
    this._customerGroupEntityMapper,
  );

  final CustomerGroupRepository _customerGroupRepository;
  final CustomerGroupEntityMapper _customerGroupEntityMapper;

  @override
  Future<CustomerGroupDetailOutput> buildUseCase(
      CustomerGroupDetailInput input) async {
    final res = await _customerGroupRepository.getDetail(id: input.id);
    final dataEntity = _customerGroupEntityMapper.mapToEntity(res.data);
    final output = CustomerGroupDetailOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class CustomerGroupDetailInput extends BaseInput {
  final int id;

  CustomerGroupDetailInput({required this.id});
}

class CustomerGroupDetailOutput extends BaseOutput {
  final BaseResponseModel<CustomerGroupEntity> response;

  CustomerGroupDetailOutput({required this.response});
}
