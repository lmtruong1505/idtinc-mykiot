import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';

import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../../data/mapper/chat_entity_mapper.dart';
import '../entities/conversation_entity.dart';
import '../repositories/conversation_repository.dart';

@injectable
class ConversationListUseCase
    extends BaseFutureUseCase<ConversationListInput, ConversationListOutput> {
  ConversationListUseCase(
    this._chatRepository,
    this._conversationEntityMapper,
  );
  final ChatRepository _chatRepository;
  final ConversationEntityMapper _conversationEntityMapper;
  @override
  Future<ConversationListOutput> buildUseCase(
    ConversationListInput input,
  ) async {
    final res = await _chatRepository.getChats(
      search: input.search,
      page: input.page,
      limit: input.limit,
    );
    final dataEntity = _conversationEntityMapper.mapToListEntity(res.data);
    return ConversationListOutput(
      response: BaseResponseModel(
        data: dataEntity,
        code: res.code,
        message: res.message,
      ),
    );
  }
}

class ConversationListInput extends BaseInput {
  final String? search;
  final int? page;
  final int? limit;
  ConversationListInput({this.limit, this.page, this.search});
}

class ConversationListOutput extends BaseOutput {
  final BaseResponseModel<List<ConversationEntity>> response;
  ConversationListOutput({required this.response});
}
