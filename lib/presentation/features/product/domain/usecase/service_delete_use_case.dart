import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/service_repository.dart';

@injectable
class ServiceDeleteUseCase
    extends BaseFutureUseCase<ServiceDeleteInput, ServiceDeleteOutput> {
  ServiceDeleteUseCase(this._serviceRepository);

  final ServiceRepository _serviceRepository;

  @override
  Future<ServiceDeleteOutput> buildUseCase(ServiceDeleteInput input) async {
    final res = await _serviceRepository.deleteService(id: input.id);
    final output = ServiceDeleteOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: res.data,
      ),
    );
    return output;
  }
}

class ServiceDeleteInput extends BaseInput {
  final int id;

  ServiceDeleteInput({required this.id});
}

class ServiceDeleteOutput extends BaseOutput {
  final BaseResponseModel response;

  ServiceDeleteOutput({required this.response});
}
