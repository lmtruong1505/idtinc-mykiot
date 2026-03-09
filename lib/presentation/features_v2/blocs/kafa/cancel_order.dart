import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/kafa/kafa_repository.dart';
import '../state/init_state.dart';

class CancelOrderKafaBloc extends Cubit<CubitState> {
  CancelOrderKafaBloc() : super(CubitState());
  final _repo = KafaRepository();

  cancel(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.cancel(id);
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          msg: 'Huỷ đơn hàng thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Huỷ đơn hàng không thành công',
        ),
      );
    }
  }
}
