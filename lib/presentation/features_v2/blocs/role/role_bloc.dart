import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/employee/role/domain/repositories/role_repository.dart';

import '../../models/role/detail_role_model.dart';
import '../state/init_state.dart';
import 'param/create_role_param.dart';

class RoleBloc extends Cubit<CubitState> {
  RoleBloc() : super(CubitState());

  final _repo = getIt<RoleRepository>();

  create(CreateRoleParam param) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.create(param.toJson());
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          msg: 'Tạo vai trò thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Tạo vai trò không thành công',
        ),
      );
    }
  }

  update(int id, CreateRoleParam param) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.update(id, param.toJson());
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          msg: 'Cập nhật vai trò thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Cập nhật vai trò không thành công',
        ),
      );
    }
  }

  detail(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getDetail(id);

    final model = res == null ? null : DetailRoleModel.fromJson(res);

    emit(
      state.copyWith(
        status: BlocStatus.success,
        data: model,
      ),
    );
  }

  addEmployeeRole(int id, List<int> staffIds) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.addEmployeeRole(
      roleId: id,
      employeeIds: staffIds,
    );
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          msg: 'Thêm nhân viên vào vai trò thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Thêm nhân viên vào vai trò không thành công',
        ),
      );
    }
  }

  remove(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.delete(id);
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          msg: 'Xoá vai trò thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Xoá vai trò không thành công',
        ),
      );
    }
  }
}
