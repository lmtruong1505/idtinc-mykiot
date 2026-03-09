import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/local/get_data.dart';
import '../../domain/usecase/list_shipment_use_case.dart';
import '../../domain/usecase/list_warehouse_use_case.dart';
import 'shipment_manager_state.dart';

@injectable
class ShipmentManagerCubit extends Cubit<ShipmentManagerState> {
  ShipmentManagerCubit(
    this._listShipmentUseCase,
    this._listWareHouseUseCase,
  ) : super(const ShipmentManagerState()) {
    _getListWareHouse();
  }

  final ListShipmentUseCase _listShipmentUseCase;
  final GetListWareHouseUseCase _listWareHouseUseCase;

  Timer? searchTimer;

  void _getListWareHouse() async {
    final input = ListWarehouseInput(
      workspace: getCompanyId,
    );
    final res = await _listWareHouseUseCase.getListV2(input);
    final warehouse = res.firstOrNull;
    emit(
      state.copyWith(
        listWareHouse: res,
        warehouse: warehouse,
        isLoadingListWareHouse: false,
      ),
    );
    getListShipment();
  }

  void getListShipment() async {
    if (!state.canLoadMore || state.isLoadMore) return;

    // if (state.warehouse?.id == null) return;
    emit(
      state.copyWith(
        isLoadMore: true,
      ),
    );
    final res = await _listShipmentUseCase.getListShipment(
      ListShipmentInput(
        workspace: getCompanyId!,
        limit: state.limit,
        search: state.search,
        offset: state.page * state.limit,
      ),
    );
    emit(
      state.copyWith(
        list: state.list + (res ?? []),
        page: state.page + 1,
        canLoadMore: (res ?? []).length < state.limit,
        isLoadMore: false,
      ),
    );
  }

  void refreshList() {
    emit(
      state.copyWith(
        list: [],
        page: 0,
        canLoadMore: true,
      ),
    );
    getListShipment();
  }

  void searchHandle(String value) {
    if (searchTimer != null) {
      searchTimer?.cancel();
    }
    searchTimer = Timer(
      const Duration(seconds: 1),
      () {
        emit(
          state.copyWith(search: value),
        );
        refreshList();
      },
    );
    searchTimer;
  }
}
