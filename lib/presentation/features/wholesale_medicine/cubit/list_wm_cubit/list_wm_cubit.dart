import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/wholesale_medicine/domain/entities/order_wm_entity.dart';

import '../../../../base/filter_button.dart';
import '../../../../base/infinite_list.dart';
import '../../../../shared/constants/enums/status_order.dart';
import '../../data/models/order_wm_count_filter_model.dart';
import '../../domain/usecase/order_wm_count_filter_use_case.dart';
import '../../domain/usecase/order_wm_list_use_case.dart';
import 'list_wm_state.dart';

@injectable
class ListWmCubit extends Cubit<ListWmState> {
  ListWmCubit(
    this._orderGetListUseCase,
    this._orderCountFilterUseCase,
  ) : super(const ListWmState());

  final OrderWmListUseCase _orderGetListUseCase;
  final OrderCountFilterUseCase _orderCountFilterUseCase;

  final InfiniteListController<OrderWmDetailEntity> infiniteListController =
      InfiniteListController<OrderWmDetailEntity>.init();
  final ScrollController scrollController = ScrollController();

  List<DropdownMenuItem<int>> listRegion = const [];

  Timer? timer;

  Future<void> init() async {
    getCountOderFilter();
  }

  void regionChange(int? value) {
    emit(state.copyWith(region: value));
    Timer(const Duration(milliseconds: 350), () {
      infiniteListController.onRefresh();
    });
  }

  void selectDatesSearch(List<DateTime?>? dates) {
    if (dates == null || dates.isEmpty) return;
    emit(state.copyWith(datesSerach: dates));
    Timer(const Duration(milliseconds: 350), () {
      infiniteListController.onRefresh();
    });
  }

  void selectFilterButton(FilterButtonItem value) {
    emit(state.copyWith(selectFilter: value));
    infiniteListController.onRefresh();
  }

  void isOnlineChange(bool? value) {
    final filterButtonOnline = [
      const FilterButtonItem('Tất cả', StatusOrder.all),
      FilterButtonItem(StatusOrder.pending.title, StatusOrder.pending),
      FilterButtonItem(StatusOrder.accept.title, StatusOrder.accept),
      FilterButtonItem(StatusOrder.complete.title, StatusOrder.complete),
      FilterButtonItem(StatusOrder.deny.title, StatusOrder.deny),
      FilterButtonItem(StatusOrder.cancel.title, StatusOrder.cancel),
    ];
    emit(
      state.copyWith(
        isOnline: value,
        listFilter: filterButtonOnline.toSet().toList(),
      ),
    );
  }

  void searchKeyChange(String value) {
    emit(state.copyWith(searchKey: value));

    if (timer != null) {
      timer!.cancel();
    }

    timer = Timer(const Duration(seconds: 1), () {
      infiniteListController.onRefresh();
    });
  }

  void changeFilterAdvance() {
    emit(state.copyWith(isFilterAdvanced: !state.isFilterAdvanced));
  }

  void _orderCountFilterChange(List<OrderCountFilterModel> value) {
    emit(state.copyWith(orderCountFilter: value));
  }

  void updateFilterRegion(int? dataProvince, int? dataDistrict, int? dataWard) {
    emit(state.copyWith(dataProvince: dataProvince));
    emit(state.copyWith(dataDistrict: dataDistrict));
    emit(state.copyWith(dataWard: dataWard));
    Timer(const Duration(milliseconds: 350), () {
      infiniteListController.onRefresh();
    });
  }

  void resetFilterRegion() {
    emit(state.copyWith(dataProvince: null));
    emit(state.copyWith(dataDistrict: null));
    emit(state.copyWith(dataWard: null));
    Timer(const Duration(milliseconds: 350), () {
      infiniteListController.onRefresh();
    });
  }

  Future<List<OrderWmDetailEntity>> getListOrder(int page) async {
    final input = OrderWmListInput(
      page: page,
      limit: state.limit,
      search: state.searchKey,
      status: int.tryParse((state.selectFilter.value as StatusOrder).id),
    );
    final res = await _orderGetListUseCase.execute(input);
    return res.response.data ?? [];
  }

  Future<void> getCountOderFilter() async {
    final res = await _orderCountFilterUseCase.execute();
    final listCountOrder =
        List<OrderCountFilterModel>.from(state.orderCountFilter);
    // for (final item in res.response.data ?? []) {
    //   final index = listCountOrder.indexWhere((e) => e.type == item.type);
    //   listCountOrder[index] = item;
    // }
    for (final item in listCountOrder) {
      final ele = res.response.data?.cast<OrderCountFilterModel?>().firstWhere(
            (e) => e?.type == item.type,
            orElse: () => null,
          );
      final index = listCountOrder.indexWhere((e) => e.type == item.type);
      if (ele == null) {
        listCountOrder[index] = listCountOrder[index].copyWith(count: 0);
      } else {
        listCountOrder[index] = ele;
      }
    }

    _orderCountFilterChange(listCountOrder);
  }
}
