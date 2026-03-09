import 'package:injectable/injectable.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../repositories/customer_group_repository.dart';

@injectable
class CustomerGroupDeleteUseCase extends BaseFutureUseCase<
    CustomerGroupDeleteInput, CustomerGroupDeleteOutput> {

  CustomerGroupDeleteUseCase(this._customerGroupRepository);

  final CustomerGroupRepository _customerGroupRepository;

  @override
  Future<CustomerGroupDeleteOutput> buildUseCase(CustomerGroupDeleteInput input) {
    return _customerGroupRepository.delete(input.id).then((res) {
      final output = CustomerGroupDeleteOutput(
        response: BaseResponseModel(
          code: res.code,
          message: res.message,
        ),
      );
      return output;
    });
  }
}

class CustomerGroupDeleteInput extends BaseInput {
  final int id;

  CustomerGroupDeleteInput({required this.id});
}

class CustomerGroupDeleteOutput extends BaseOutput {
  final BaseResponseModel response;

  CustomerGroupDeleteOutput({required this.response});
}
