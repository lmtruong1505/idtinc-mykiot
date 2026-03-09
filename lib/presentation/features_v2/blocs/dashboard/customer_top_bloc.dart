import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/repositories/dashboard/dashboard_repository.dart';

import '../../models/dashboard/customer_top.dart';
import '../enum/enum_bloc.dart';
import '../state/init_state.dart';

class CustomerTopBloc extends Cubit<CubitState> {
  CustomerTopBloc() : super(CubitState());
  final _repo = DashboardRepository();
  DashboardCustomerTopModel? customerTop;
  SortCustomerDashboard _sort = SortCustomerDashboard.total_order;
  SortCustomerDashboard get sort => _sort;
  set sort(SortCustomerDashboard newSort) {
    _sort = newSort;
    getData();
  }

  getData() async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.customerTop(_sort);
    customerTop = res.data;
    emit(state.copyWith(status: BlocStatus.success));
  }
}
