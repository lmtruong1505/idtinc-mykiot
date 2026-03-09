import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

@injectable
class PromotionTimerBloc extends Cubit<CubitState> {
  PromotionTimerBloc() : super(CubitState());
  Timer? _timer;
  int day = 0;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  bool isFinished = false;
  DateTime? endDate;

  void initData(DateTime? date) {
    _timer?.cancel();
    endDate = date;
    startTime();
  }

  void startTime() {
    if (endDate == null) {
      isFinished = true;
      emit(state.copyWith(status: BlocStatus.reload));
      return;
    }
    _timer = Timer.periodic(1.seconds, (_) {
      print('=======Timer');
      final now = DateTime.now().toUtc().add(const Duration(hours: 7));
      final diff = endDate!.difference(now);
      if (diff.isNegative) {
        isFinished = true;
        _timer?.cancel();
        emit(state.copyWith(status: BlocStatus.reload));
        return;
      }
      day = diff.inDays;
      hours = diff.inHours % 24;
      minutes = diff.inMinutes % 60;
      seconds = diff.inSeconds % 60;
      emit(state.copyWith(status: BlocStatus.reload));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
