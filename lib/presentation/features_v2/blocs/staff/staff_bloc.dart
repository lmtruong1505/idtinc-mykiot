import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/employee/employee/data/models/employee_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/staff/param/create_or_update_param.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../features/employee/employee/domain/repositories/employee_repository.dart';
import '../state/init_state.dart';

class StaffBloc extends Cubit<CubitState> {
  StaffBloc() : super(CubitState());
  final _repo = getIt<EmployeeRepository>();

  create(CreateOrUpdateParam param) async {
    emit(state.copyWith(status: BlocStatus.loading));
    jsonEncode(param.toJson()).copy;
    final res = await _repo.create(param.toJson());
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          msg: 'Tạo mới nhân viên thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Tạo mới nhân viên không thành công',
        ),
      );
    }
  }

  update(int id, CreateOrUpdateParam param) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.update(id, param.toJson());
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          msg: 'Cập nhật nhân viên thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Cập nhật nhân viên không thành công',
        ),
      );
    }
  }

  active(int id, bool active) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res =
        await _repo.update(id, CreateOrUpdateParam(active: active).toJson());
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          data: state.data is EmployeeModel
              ? state.data.copyWith(active: active)
              : null,
          msg: '${active ? 'Kích hoạt' : 'Vô hiệu hoá'} nhân viên thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ??
              '${active ? 'Kích hoạt' : 'Vô hiệu hoá'} nhân viên không thành công',
        ),
      );
    }
  }

  remover(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.delete(id);
    if (res.code == 200) {
      emit(
        state.copyWith(
          data: true,
          status: BlocStatus.success,
          msg: 'Xoá nhân viên thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Xoá nhân viên không thành công',
        ),
      );
    }
  }

  detail(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getDetail(id);
    emit(
      state.copyWith(
        status: BlocStatus.success,
        msg: 'Lấy thông tin nhân viên thành công',
        data: res.data,
      ),
    );
  }
}
