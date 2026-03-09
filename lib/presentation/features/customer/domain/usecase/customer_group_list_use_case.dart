import 'package:injectable/injectable.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/presentation/features/customer/data/mapper/customer_group_entity_mapper.dart';
import 'package:pharmago/presentation/features/customer/domain/repositories/customer_group_repository.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../entities/customer_group_entity.dart';

@injectable
class CustomerGroupListUseCase
    extends BaseFutureUseCase<CustomerGroupListInput, CustomerGroupListOutput> {
  CustomerGroupListUseCase(
    this._customerGroupRepository,
    this._customerGroupEntityMapper,
  );

  final CustomerGroupRepository _customerGroupRepository;
  final CustomerGroupEntityMapper _customerGroupEntityMapper;

  @override
  Future<CustomerGroupListOutput> buildUseCase(
      CustomerGroupListInput input,) async {
    final res = await _customerGroupRepository.getList(
      company: input.company,
      search: input.search,
      page: input.page,
      limit: input.limit,
    );
    final dataEntity = _customerGroupEntityMapper.mapToListEntity(res.data);
    return CustomerGroupListOutput(
      BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
  }
}

class CustomerGroupListInput extends BaseInput {
  final String? search;
  final int? page;
  final int? limit;
  final int? company;

  CustomerGroupListInput({
    required this.company,
    this.limit,
    this.page,
    this.search,
  });
}

class CustomerGroupListOutput extends BaseOutput {
  final BaseResponseModel<List<CustomerGroupEntity>> response;

  CustomerGroupListOutput(this.response);
}
