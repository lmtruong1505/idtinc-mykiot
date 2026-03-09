import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/models/phieu_kham/detail_pk_v2_model.dart';

import '../../repositories/phieu_kham_v2/phieu_kham_v2_repo.dart';
import '../state/init_state.dart';

class DetailPkV2Bloc extends Cubit<CubitState<DetailPkV2Model>> {
  DetailPkV2Bloc() : super(CubitState());
  final _repo = PhieuKhamV2Repo();

  getDetail(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.detail(id);
    if (res.code == 200 && res.data != null) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          data: res.data,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Không tìm thấy thông tin phiếu khám',
        ),
      );
    }
  }
}
