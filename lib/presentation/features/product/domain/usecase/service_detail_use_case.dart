import 'package:injectable/injectable.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/product/data/mapper/service_entity_mapper.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/service_repository.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../entities/service_entity.dart';

@injectable
class ServiceDetailUseCase
    extends BaseFutureUseCase<ServiceDetailInput, ServiceDetailOutput> {

  ServiceDetailUseCase(
    this._serviceRepository,
    this._serviceEntityMapper,
  );

  final ServiceRepository _serviceRepository;
  final ServiceEntityMapper _serviceEntityMapper;

  @override
  Future<ServiceDetailOutput> buildUseCase(ServiceDetailInput input) async {
    final res = await _serviceRepository.getDetail(id: input.id);
    final dataEntity = _serviceEntityMapper.mapToEntity(res.data);
    final output = ServiceDetailOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class ServiceDetailInput extends BaseInput {
  final int id;

  ServiceDetailInput({required this.id});
}

class ServiceDetailOutput extends BaseOutput {
  final BaseResponseModel<ServiceEntity> response;

  ServiceDetailOutput({required this.response});
}
