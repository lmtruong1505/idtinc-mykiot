import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/di/di.dart';

import '../../../features/company/cubit/work_space/work_space_cubit.dart';
import '../../repositories/role_v2/role_v2_repository.dart';
import '../state/init_state.dart';

@Singleton()
class RolePermissionWsBloc extends Cubit<CubitState> {
  RolePermissionWsBloc() : super(CubitState());

  final _repo = RoleV2Repository();

  final List<String> _roles = [];
  List<String> get roles => _roles;
  final List<String> _permission = [];
  List<String> get permission => _permission;

  getRolePer(int companyId) async {
    emit(
      state.copyWith(status: BlocStatus.loading),
    );
    _roles.clear();
    _permission.clear();

    final res = await _repo.getPerRoleWp(company: companyId);
    await getIt<WorkSpaceCubit>().setComapny(companyId);
    if (res.data is Map) {
      for (final role in res.data!['positions']) {
        _roles.add(role);
      }

      for (final per in res.data!['permissions']) {
        _permission.add(per['code']);
      }
    }
    emit(state.copyWith(status: BlocStatus.success));
  }
}
