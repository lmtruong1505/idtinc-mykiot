import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';

import '../../../../data/models/date_range.model.dart';
import '../../models/dashboard/order.dart';
import '../../repositories/dashboard/dashboard_repository.dart';

class OrderDashboardBloc extends Cubit<CubitState> {
  OrderDashboardBloc() : super(CubitState());
  final _repo = DashboardRepository();
  DashboardOrderModel? order;

  getData({
    DateRangeModel? dates,
  }) async {
    emit(
      state.copyWith(
        status: BlocStatus.loading,
      ),
    );
    final res = await _repo.order(dates: dates);
    order = res.data;
    emit(
      state.copyWith(
        status: BlocStatus.success,
      ),
    );
  }
}
