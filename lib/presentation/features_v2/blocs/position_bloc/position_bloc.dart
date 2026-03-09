import 'package:bloc/bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';

import '../../models/position/position_model.dart';
import '../../repositories/role_v2/role_v2_repository.dart';
import '../enum/bloc_status.dart';

class PositionBloc extends Cubit<CubitState> {
  PositionBloc() : super(CubitState());
  final repo = RoleV2Repository();
  List<PositionModel> list = [];

  Future<void> getList() async {
    emit(state.copyWith(status: BlocStatus.loading));
    final company = getCompany ?? -1;
    final res = await repo.getPositions(company: company);
    list = res.data ?? [];
    
    emit(state.copyWith(status: BlocStatus.success));
  }
}