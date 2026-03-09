

import 'package:injectable/injectable.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../../../../../domain/usecase/base/use_case.dart';
import '../repositories/conversation_repository.dart';

@injectable
class CountNotSeenUseCase extends BaseUseCaseNoInput<CountNotSeenOutput> {
  CountNotSeenUseCase(this._chatRepository);
  final ChatRepository _chatRepository;
  
  @override
  Future<CountNotSeenOutput> execute() async {
    final res = await _chatRepository.countNotSeen();
    return CountNotSeenOutput(response: res);
  }
}

class CountNotSeenOutput extends BaseOutput {
  final BaseResponseModel<int> response;
  CountNotSeenOutput({required this.response});
}