import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/warehouse_use_case.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';

import '../../models/dashboard/prd.dart';
import '../../repositories/dashboard/dashboard_repository.dart';
import '../state/init_state.dart';

class PrdTopBloc extends Cubit<CubitState> {
  PrdTopBloc() : super(CubitState());
  final List<PrdDashboardModel> list = [];
  final _repo = DashboardRepository();
  final _warehouseUseCase = getIt<WarehouseUseCase>();
  SortPrdDashboard _sort = SortPrdDashboard.revenue;
  SortPrdDashboard get sort => _sort;

  set sort(SortPrdDashboard newSort) {
    _sort = newSort;
    getData();
  }

  void getData() async {
    list.clear();
    emit(
      state.copyWith(
        status: BlocStatus.loading,
      ),
    );
    if (_sort == SortPrdDashboard.expired) {
      final input = InventoryInputV2(
        limit: 5,
        page: 0,
        search: '',
        expired: 30,
        workspace: getCompanyId,
        id: null,
      );
      final res = await _warehouseUseCase.getListInventory(input);
      list.addAll(
        (res.data
                ?.map(
                  (e) => PrdDashboardModel(
                    name: e.product?.productName,
                    sold: e.quantityExpDate,
                    revenue: e.quantityNearDate,
                  ),
                )
                .toList() ??
            []),
      );
      emit(
        state.copyWith(
          total: res.extra,
          status: BlocStatus.success,
        ),
      );
    } else {
      final res = await _repo.prdTop(_sort);
      list.addAll(res.data ?? []);
      emit(
        state.copyWith(
          total: res.extra,
          status: BlocStatus.success,
        ),
      );
    }
  }
}
