import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/warehouse_state.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/ticket_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/warehouse_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/ticket_list_use_case.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/warehouse_use_case.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';

@injectable
class WarehouseCubit extends Cubit<WarehouseState> {
  WarehouseCubit(
    this._useCase,
    this._ticketListUseCase,
  ) : super(const WarehouseState());

  final WarehouseUseCase _useCase;
  final TicketListUseCase _ticketListUseCase;
  final InfiniteListController<TicketEntity> entityILC =
      InfiniteListController<TicketEntity>.init();
  final InfiniteListController<WarehouseEntity> warehouseILC =
      InfiniteListController<WarehouseEntity>.init();
  final ScrollController scrollController = ScrollController();

  List<WarehouseEntity> _warehouses = [];
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

  Future<List<WarehouseEntity>> getList(int page) async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    if (company == null) return [];
    final input = WarehouseInput(
      search: state.search,
      limit: state.limit,
      page: page + 1,
      company: company,
    );
    final res = state.tabSelected == 0
        ? await _useCase.getList(input)
        : <WarehouseEntity>[];
    _warehouses = res;
    emit(state);
    return res;
  }

  Future<List<TicketEntity>> getListTicket(int page) async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    if (company == null) return [];
    final input = TicketListInput(
      search: state.search,
      limit: state.limit,
      page: page + 1,
      company: company,
    );
    final res = await _ticketListUseCase.execute(input);
    final list = res.response.data ?? [];
    emit(state.copyWith(total: list.length));
    return list;
  }

  void searchChange(String value) {
    emit(state.copyWith(search: value));
    entityILC.onRefresh();
  }

  void tabChange(Object? value) {
    emit(state.copyWith(
        tabSelected: value != null ? int.parse(value.toString()) : 0));
    entityILC.onRefresh();
  }

  void changeTimeFilter(int index) {
    emit(state.copyWith(timeFilterIndex: index));
    entityILC.onRefresh();
  }
}
