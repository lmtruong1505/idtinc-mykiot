import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/company/cubit/create_company_cubit/create_company_state.dart';
import '../../models/dashboard/band.dart';
import '../../repositories/dashboard/dashboard_repository.dart';
import '../state/init_state.dart';

class BrandDashboardBloc extends Cubit<CubitState> {
  BrandDashboardBloc() : super(CubitState());
  final List<BrandDashboardModel> list = [];
  final _repo = DashboardRepository();
  TypeCompany _type = TypeCompany.drugstore;
  TypeCompany get type => _type;

  set type(TypeCompany newSort) {
    _type = newSort;
    getData();
  }

  getData() async {   list.clear();
    emit(
      state.copyWith(
        status: BlocStatus.loading,
      ),
    );
    final res = await _repo.brand(_type);
    list.addAll(res.data ?? []);
    emit(
      state.copyWith(
        status: BlocStatus.success,
      ),
    );
  }
}
