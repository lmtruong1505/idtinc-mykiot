import 'package:injectable/injectable.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../../data/mapper/chat_entity_mapper.dart';
import '../../domain/repositories/conversation_repository.dart';
import '../entities/message_entity.dart';

@injectable
class MessageListUseCase
    extends BaseFutureUseCase<MessageListInput, MessageListOutput> {
  MessageListUseCase(
    this._chatRepository,
    this._messageEntityMapper,
  );
  final ChatRepository _chatRepository;
  final MessageEntityMapper _messageEntityMapper;
  @override
  Future<MessageListOutput> buildUseCase(MessageListInput input) async {
    final res = await _chatRepository.getMessages(
      uuid: input.uuid,
      page: input.page,
      limit: input.limit,
    );
    final dataEntity = _messageEntityMapper.mapToListEntity(res.data);
    return MessageListOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
  }
}

class MessageListInput extends BaseInput {
  final String uuid;
  final int? page;
  final int? limit;
  MessageListInput({
    required this.uuid,
    this.limit,
    this.page,
  });
}

class MessageListOutput extends BaseOutput {
  final BaseResponseModel<List<MessageEntity>> response;
  MessageListOutput({required this.response});
}
