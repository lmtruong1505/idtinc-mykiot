import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecase/notification_detail_use_case.dart';
import 'notification_detail_state.dart';

@injectable
class NotificationDetailCubit extends Cubit<NotificationDetailState> {
  NotificationDetailCubit(
    this._notificationDetailUseCase,
  ) : super(const NotificationDetailState());

  final NotificationDetailUseCase _notificationDetailUseCase;

  Future<void> getDetail(int id) async {
    emit(state.copyWith(isLoading: true));
    final input = NotificationDetailInput(id: id);
    final res = await _notificationDetailUseCase.execute(input);
    emit(
      state.copyWith(
        notification: res.response.data,
        isLoading: false,
      ),
    );
  }
}
