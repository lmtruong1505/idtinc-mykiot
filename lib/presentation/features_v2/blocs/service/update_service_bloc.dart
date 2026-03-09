part of 'bloc_index.dart';

class UpdateServiceV2Bloc extends Cubit<CubitState> {
  UpdateServiceV2Bloc() : super(CubitState());

  final _repo = ServiceV2Repository();

  updateStatus(int id, bool status) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.updateStatus(
      id,
    );
    if (res.data != null && res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          data: status,
          msg: status
              ? 'Kích hoạt dịch vụ thành công'
              : 'Vô hiệu hoá dịch vụ thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ??
              (status
                  ? 'Kích hoạt dịch vụ thất bại'
                  : 'Vô hiệu hoá dịch vụ thất bại'),
        ),
      );
    }
  }

  remove(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.remove(
      id,
    );
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          data: 'remove',
          msg: 'Xoá dịch vụ thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Xoá dịch vụ thất bại',
        ),
      );
    }
  }
}
