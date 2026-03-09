import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/presentation/features/notification/domain/repositories/notification_repository.dart';

import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../../data/mapper/notification_mapper.dart';
import '../entities/notification_entity.dart';

@injectable
class NotificationDetailUseCase extends BaseFutureUseCase<
    NotificationDetailInput, NotificationDetailOutput> {
  NotificationDetailUseCase(
      this._notificationRepository, this._notificationEntityMapper);

  final NotificationRepository _notificationRepository;
  final NotificationMapper _notificationEntityMapper;

  @override
  Future<NotificationDetailOutput> buildUseCase(
    NotificationDetailInput input,
  ) async {
    final res = await _notificationRepository.getDetail(id: input.id);
    final dataEntity = _notificationEntityMapper.mapToEntity(res.data);
    final output = NotificationDetailOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class NotificationDetailInput extends BaseInput {
  final int id;

  NotificationDetailInput({required this.id});
}

class NotificationDetailOutput extends BaseOutput {
  final BaseResponseModel<NotificationEntity> response;

  NotificationDetailOutput({required this.response});
}
