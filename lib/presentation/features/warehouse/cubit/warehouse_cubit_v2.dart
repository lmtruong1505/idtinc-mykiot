import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/features/company/cubit/auth_ws_manager_cubit/auth_ws_manager_state.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/warehouse_state.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/warehouse_model.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/ticket_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/warehouse_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/list_warehouse_use_case.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/warehouse_use_case.dart';
import 'package:pharmago/presentation/features/warehouse/screens/warehourse_list_page_v2.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

import '../../../di/di.dart';
import '../../company/cubit/auth_ws_manager_cubit/auth_ws_manager_cubit.dart';

@injectable
class WarehouseCubitV2 extends Cubit<WarehouseState> {
  WarehouseCubitV2(
    this._useCase,
    this._listWareHouseUseCase,
  ) : super(const WarehouseState());

  final WarehouseUseCase _useCase;
  final GetListWareHouseUseCase _listWareHouseUseCase;
  final InfiniteListController<TicketEntity> entityILC =
      InfiniteListController<TicketEntity>.init();
  final InfiniteListController<WarehouseEntity> warehouseILC =
      InfiniteListController<WarehouseEntity>.init();
  final ScrollController scrollController = ScrollController();

  List<WarehouseEntity> _warehouses = [];
  final all = const WarehouseModel(title: 'Tất cả');
  int page = 0;
  final DelayCallBack delay = DelayCallBack(delay: 500.milliseconds);
  List<DropdownMenuItem<WarehouseEntity>> get warehousesSelected {
    return _warehouses
        .map(
          (e) => DropdownMenuItem<WarehouseEntity>(
            value: e,
            child: Text(e.title),
          ),
        )
        .toList();
  }

  void getListWareHouse() async {
    final input = ListWarehouseInput(
      expired: state.filter?.value,
      workspace: getCompanyId,
    );
    final res = await _listWareHouseUseCase.getListV2(input);
    emit(state.copyWith(listWareHouse: [all] + res));
  }

  void getListInventory({bool isMore = false}) async {
    if (isMore) {
      page = page + 1;
    } else {
      page = 0;
      emit(state.copyWith(inventories: [], isLoading: true));
    }
    final input = InventoryInputV2(
      search: state.search,
      id: state.warehouseSelect?.id,
      limit: state.limit,
      page: page,
      expired: state.filter?.value,
      workspace: getCompanyId,
      typeCode: getIt.get<AuthWsManagerCubit>().state.typeCodeWarehouse,
    );
    final res = await _useCase.getListInventory(input);
    if (isClosed) return;
    emit(
      state.copyWith(
        inventories: (state.inventories) + (res.data ?? []),
        isLoading: false,
      ),
    );
  }

  void searchChange(String value) {
    delay.debounce(
      () {
        emit(state.copyWith(search: value));
        getListInventory();
      },
    );
  }

  void warehouseChange(WarehouseModel? value) {
    emit(state.copyWith(warehouseSelect: value));
    getListInventory();
  }

  void changeTimeFilter(FilterButtonModel value) {
    emit(state.copyWith(filter: value));
    getListInventory();
    getListWareHouse();
  }

  void initData(FilterButtonModel value) {
    emit(state.copyWith(filter: value));
  }
}
