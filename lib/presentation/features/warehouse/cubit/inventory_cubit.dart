import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/inventory_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/warehouse_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/inventory_use_case.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/warehouse_use_case.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';

import 'inventory_state.dart';

@injectable
class InventoryCreateCubit extends Cubit<InventoryState> {
  InventoryCreateCubit(this._useCase, this._warehouseUseCase)
      : super(const InventoryState());

  final InventoryUseCase _useCase;
  final WarehouseUseCase _warehouseUseCase;
  final InfiniteListController<InventoryEntity> entityILC =
      InfiniteListController<InventoryEntity>.init();
  final ScrollController scrollController = ScrollController();

  Future<void> getWareHouseList() async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    if (company == null) return;
    final input = WarehouseInput(
      company: company,
      search: state.search,
      limit: state.limit,
      page: 1,
    );
    List<WarehouseEntity> warehouses = await _warehouseUseCase.getList(input);
    List<DropdownMenuItem> warehouseDrops = [];
    for (final item in warehouses) {
      if (state.warehouseId == 0) emit(state.copyWith(warehouseId: item.id));
      warehouseDrops.add(
        DropdownMenuItem(value: item.id, child: Text(item.title, style: p6)),
      );
    }
    emit(state.copyWith(warehouseDrops: warehouseDrops));
    entityILC.onRefresh();
  }

  Future<List<InventoryEntity>> getList(int page) async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    if (company == null || state.warehouseId == 0) return [];
    final input = InventoryInput(
      state.warehouseId,
      state.search,
      state.limit,
      page + 1,
      company,
    );
    return await _useCase.getList(input);
  }

  void searchChange(String value) {
    emit(state.copyWith(search: value));
    entityILC.onRefresh();
  }

  void changeWarehouseId(dynamic warehouseId) {
    emit(state.copyWith(warehouseId: warehouseId));
    entityILC.onRefresh();
  }
}
