import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/notification/data/mapper/notification_mapper.dart';
import 'package:pharmago/presentation/features/notification/domain/entities/notification_entity.dart';
import 'package:pharmago/presentation/features/notification/domain/repositories/notification_repository.dart';

@injectable
class NotificationListUseCase
    extends BaseFutureUseCase<NotificationListInput, NotificationListOutput> {
  NotificationListUseCase(
    this._notificationRepository,
    this._notificationMapper,
  );
  final NotificationRepository _notificationRepository;
  final NotificationMapper _notificationMapper;

  @override
  Future<NotificationListOutput> buildUseCase(
    NotificationListInput input,
  ) async {
    final res = await _notificationRepository.getList(
      company: input.company,
      page: input.page,
      limit: input.limit,
      search: input.search,
    );
    final dataEntity = _notificationMapper.mapToListEntity(res.data);
    return NotificationListOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
        extra: res.extra,
      ),
    );
  }
}

class NotificationListInput extends BaseInput {
  final int company;
  final String? search;
  final String? type;
  final int? page;
  final int? limit;

  NotificationListInput({
    required this.company,
    this.limit,
    this.type,
    this.page,
    this.search,
  });
}

class NotificationListOutput extends BaseOutput {
  final BaseResponseModel<List<NotificationEntity>> response;
  NotificationListOutput({required this.response});
}
