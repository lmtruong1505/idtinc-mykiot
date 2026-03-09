import 'package:injectable/injectable.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../../data/mapper/chat_entity_mapper.dart';
import '../../domain/repositories/conversation_repository.dart';
import '../entities/message_entity.dart';

@injectable
class SendMessageUseCase
    extends BaseFutureUseCase<SendMessageInput, SendMessageOutput> {
  SendMessageUseCase(
    this._chatRepository,
    this._messageEntityMapper,
  );
  final ChatRepository _chatRepository;
  final MessageEntityMapper _messageEntityMapper;
  @override
  Future<SendMessageOutput> buildUseCase(SendMessageInput input) async {
    final res = await _chatRepository.sendMessage(
      uuid: input.uuid,
      content: input.content,
    );
    final data = _messageEntityMapper.mapToEntity(res.data);
    return SendMessageOutput(response: BaseResponseModel(
      code: res.code,
      message: res.message,
      data: data,
    ));
  }
}

class SendMessageInput extends BaseInput {
  final String uuid;
  final String content;
  SendMessageInput({
    required this.uuid,
    required this.content,
  });
}

class SendMessageOutput extends BaseOutput {
  final BaseResponseModel<MessageEntity> response;
  SendMessageOutput({required this.response});
}
