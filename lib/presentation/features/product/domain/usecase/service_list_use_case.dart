import 'package:injectable/injectable.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/service_repository.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../../data/mapper/count_mapper.dart';
import '../../data/mapper/service_entity_mapper.dart';
import '../entities/service_entity.dart';

@injectable
class ServiceListUseCase
    extends BaseFutureUseCase<ServiceListInput, ServiceListOutput> {
  ServiceListUseCase(this._serviceRepository, this._serviceEntityMapper, this._serviceCountMapper);

  final ServiceRepository _serviceRepository;
  final ServiceEntityMapper _serviceEntityMapper;
  final CountMapper _serviceCountMapper;

  @override
  Future<ServiceListOutput> buildUseCase(ServiceListInput input) async {
    final res = await _serviceRepository.getServices(
      search: input.search,
      limit: input.limit,
      page: input.page,
      company: input.company,
      active: input.active,
    );
    final dataEntity = _serviceEntityMapper.mapToListEntity(res.data);
    final serviceCounts = _serviceCountMapper.mapToListEntity(res.extra);
    final output = ServiceListOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
        extra: serviceCounts,
      ),
    );
    return output;
  }
}

class ServiceListInput extends BaseInput {
  final String search;
  final int limit;
  final int page;
  final int? company;
  bool? active;

  ServiceListInput({
    required this.search,
    required this.limit,
    required this.page,
    required this.company,
    this.active,
  });
}

class ServiceListOutput extends BaseOutput {
  final BaseResponseModel<List<ServiceEntity>> response;

  ServiceListOutput({required this.response});
}
