import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/warehouse/data/mapper/ticket_entity_mapper.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/ticket_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/repositories/ticket_repository.dart';

@injectable
class TicketListUseCase
    extends BaseFutureUseCase<TicketListInput, TicketListOutput> {
  TicketListUseCase(
    this._repository,
    this._mapper,
  );
  final TicketRepository _repository;
  final TicketEntityMapper _mapper;
  @override
  Future<TicketListOutput> buildUseCase(TicketListInput input) async {
    final res = await _repository.getListTicket(
      company: input.company,
      page: input.page,
      limit: input.limit,
      search: input.search,
    );
    final dataEntity = _mapper.mapToListEntity(res.data);
    final output = TicketListOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class TicketListInput extends BaseInput {
  final int company;
  final int? page;
  final int? limit;
  final String? search;
  TicketListInput({
    required this.company,
    this.limit,
    this.page,
    this.search,
  });
}

class TicketListOutput extends BaseOutput {
  final BaseResponseModel<List<TicketEntity>> response;
  TicketListOutput({
    required this.response,
  });
}
