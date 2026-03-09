import 'package:injectable/injectable.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../../domain/repositories/conversation_repository.dart';

@injectable
class DeleteMessageUseCase
    extends BaseFutureUseCase<DeleteMessageInput, DeleteMessageOutput> {
  DeleteMessageUseCase(
    this._chatRepository,
  );
  final ChatRepository _chatRepository;
  @override
  Future<DeleteMessageOutput> buildUseCase(DeleteMessageInput input) async {
    final res = await _chatRepository.deleteMessages(input.uuid);
    return DeleteMessageOutput(response: res);
  }
}

class DeleteMessageInput extends BaseInput {
  final String uuid;
  DeleteMessageInput({required this.uuid});
}

class DeleteMessageOutput extends BaseOutput {
  final BaseResponseModel response;
  DeleteMessageOutput({required this.response});
}
