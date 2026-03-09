import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/branch/data/repositories/branch_repository.dart';

import '../../../../features_v2/blocs/state/init_state.dart';
import 'add_staff_branch_bloc.dart';

class StaffActionBranchBloc extends Cubit<CubitState> {
  StaffActionBranchBloc() : super(CubitState());

  final _repo = BranchRepository();

  removeStaff({
    required int id,
    required List<int> staffIds,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.removeStaff(id: id, staffIds: staffIds);
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          data: 'remove',
          msg: 'Xoá nhân viên khỏi cơ sở thành công',
          total: staffIds.length,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg:
              'Lỗi. ${res.message ?? "Xoá nhân viên khỏi cơ sở không thành công"}',
        ),
      );
    }
  }

  addStaff({
    required int id,
    required List<AddStaffModel> list,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final List<Map<String, dynamic>> listStaff = list.map(
      (e) {
        return <String, dynamic>{
          'id': e.staff.id.toString(),
          'roles': e.roles
              .map(
                (e) => e.id,
              )
              .toList(),
        };
      },
    ).toList();

    final res = await _repo.addStaff(
      id: id,
      list: listStaff,
    );
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          data: 'add',
          msg: 'Thêm nhân viên khỏi cơ sở thành công',
          total: list.length,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg:
              'Lỗi. ${res.message ?? "Thêm nhân viên khỏi cơ sở không thành công"}',
        ),
      );
    }
  }
}
