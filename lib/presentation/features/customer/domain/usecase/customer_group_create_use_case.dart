import 'package:injectable/injectable.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/customer_group_entity.dart';
import 'package:pharmago/presentation/features/customer/domain/repositories/customer_group_repository.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/io/output.dart';

@injectable
class CustomerGroupCreateUseCase extends BaseFutureUseCase<
    CustomerGroupCreateInput, CustomerGroupCreateOutput> {
  CustomerGroupCreateUseCase(this._customerGroupRepository);

  final CustomerGroupRepository _customerGroupRepository;

  @override
  Future<CustomerGroupCreateOutput> buildUseCase(
      CustomerGroupCreateInput input) async {
    final payload = {
      'company': input.payload.company,
      'name': input.payload.name,
      'code': input.payload.code,
      'note': input.payload.note,
      'customers': input.customerIds,
    };

    final res = await _customerGroupRepository.create(payload: payload);
    final output = CustomerGroupCreateOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: null,
      ),
    );
    return output;
  }
}

class CustomerGroupCreateInput extends BaseInput {
  final CustomerGroupEntity payload;
  final List<int> customerIds;

  CustomerGroupCreateInput({required this.payload, required this.customerIds});
}

class CustomerGroupCreateOutput extends BaseOutput {
  final BaseResponseModel<CustomerGroupEntity> response;

  CustomerGroupCreateOutput({required this.response});
}
