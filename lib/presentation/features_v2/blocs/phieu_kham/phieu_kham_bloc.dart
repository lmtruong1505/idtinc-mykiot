import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/phieu_kham/param/param_update.dart';
import 'package:pharmago/presentation/features_v2/repositories/phieu_kham/phieu_kham_repository.dart';

import '../../models/calendar/event_model.dart';
import '../state/init_state.dart';

class PhieuKhamBloc extends Cubit<CubitState> {
  PhieuKhamBloc() : super(CubitState());
  final _repo = PhieuKhamRepository();
  EventModel? _phieuKham;
  EventModel? get phieuKham => _phieuKham;

  detail(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.detail(id);
    _phieuKham = res.data;
    emit(state.copyWith(status: BlocStatus.success));
  }

  update({
    required int id,
    required ParamUpdatedPk param,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final res = await _repo.update(
      id: id,
      req: param.toMap(),
    );
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          msg: 'Cập nhật thông tin phiếu khám thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: 'Cập nhật thông tin phiếu khám không thành công',
        ),
      );
    }
  }
}
