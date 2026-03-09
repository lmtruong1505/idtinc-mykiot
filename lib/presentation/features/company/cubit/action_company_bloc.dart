import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/di/di.dart';

import '../../../features_v2/blocs/state/init_state.dart';
import '../domain/repositories/company_repository.dart';

class ActionCompanyBloc extends Cubit<CubitState> {
  ActionCompanyBloc() : super(CubitState());
  final _repo = getIt<CompanyRepository>();

  remove(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.remove(id);
    emit(
      state.copyWith(
        status: res.data == true ? BlocStatus.success : BlocStatus.failure,
        data: 'remove',
        msg: res.message,
      ),
    );
  }

  setActive(int id, bool value) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.setActive(id, value);
    emit(
      state.copyWith(
        status: res.data == true ? BlocStatus.success : BlocStatus.failure,
        msg: res.message,
      ),
    );
  }

  setInWork(int id, bool value) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.setInWork(id, value);
    emit(
      state.copyWith(
        status: res.data == true ? BlocStatus.success : BlocStatus.failure,
        msg: res.message,
      ),
    );
  }
}
