import 'package:injectable/injectable.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/customer_group_entity.dart';
import 'package:pharmago/presentation/features/customer/domain/repositories/customer_group_repository.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/io/output.dart';

@injectable
class CustomerGroupUpdateUseCase extends BaseFutureUseCase<
    CustomerGroupUpdateInput, CustomerGroupUpdateOutput> {
  CustomerGroupUpdateUseCase(this._customerGroupRepository);

  final CustomerGroupRepository _customerGroupRepository;

  @override
  Future<CustomerGroupUpdateOutput> buildUseCase(
    CustomerGroupUpdateInput input,
  ) async {
    final payload = {
      'name': input.payload.name,
      'code': input.payload.code,
      'note': input.payload.note,
      'customers': input.customerIds,
    };

    final res = await _customerGroupRepository.update(
      input.payload.id!,
      payload,
    );
    final output = CustomerGroupUpdateOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: null,
      ),
    );
    return output;
  }
}

class CustomerGroupUpdateInput extends BaseInput {
  final CustomerGroupEntity payload;
  final List<int> customerIds;

  CustomerGroupUpdateInput({required this.payload, required this.customerIds});
}

class CustomerGroupUpdateOutput extends BaseOutput {
  final BaseResponseModel<CustomerGroupEntity> response;

  CustomerGroupUpdateOutput({required this.response});
}
