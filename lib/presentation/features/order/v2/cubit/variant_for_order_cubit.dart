import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_entity.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';

import '../../../../base/filter_button.dart';
import '../../../../base/infinite_list.dart';
import '../../../product/domain/usecase/variant_list_use_case.dart';
import '../../cubit/order_create_cubit/order_create_state.dart';
import 'variant_for_order_state.dart';

@injectable
class VariantForOrderCubit extends Cubit<VariantForOrderState> {
  VariantForOrderCubit(this._variantGetListUseCase) : super(const VariantForOrderState());

  final VariantListUseCase _variantGetListUseCase;

  final ScrollController scrollController = ScrollController();
  final infiniteListController = InfiniteListController<VariantEntity>.init();

  Timer? timerSearch;

  void init(List<VariantEntity> value) {
    emit(state.copyWith(listVariantSelect: value));
  }

  void searchVariantHandle(String value) {
    emit(state.copyWith(searchKey: value));
    if (timerSearch != null) {
      timerSearch?.cancel();
    }
    timerSearch = Timer(const Duration(milliseconds: 500), () {
      infiniteListController.onRefresh();
    });
    timerSearch;
  }

  void searchChooseVariantHandle(String value) {}
  bool isLoadData = false;

  Future<List<VariantEntity>> getListVariant({
    required int page,
  }) async {
    final company = getCompany as int;
    final input = VariantListInput(
      company: company,
      page: page,
      limit: 10,
      search: state.searchKey,
      filter: (state.selectFilter.value as FilterItemOrder).code,
    );
    final res = await _variantGetListUseCase.execute(input);
    final listVariant = List<VariantEntity>.from(state.listVariantSelect);
    final listId = listVariant.map((e) => e.id).toList();
    for (final item in res.response.data ?? []) {
      if (!listId.contains(item.id)) {
        listVariant.add(item);
      }
    }
    emit(state.copyWith(listVariantSelect: listVariant));
    return res.response.data ?? <VariantEntity>[];
  }

  Future<void> selectVariant({required int variantId, int? customer}) async {
    //final accountId = getUserId;
    final listVariant = List<VariantEntity>.from(state.listVariantSelect);
    final index = listVariant.indexWhere((e) => e.id == variantId);
    if (checkVariantIsSelected(variantId) == false) {
      listVariant[index] = listVariant[index].copyWith(isChoose: true);
    }

    emit(state.copyWith(listVariantSelect: listVariant));
    // _totalPrice();
  }

  void updateVariant(VariantEntity item) {
    final listVariant = List<VariantEntity>.from(state.listVariantSelect);
    final index = listVariant.indexWhere((e) => e.id == item.id);
    listVariant[index] = item.copyWith(isChoose: true);
    emit(state.copyWith(listVariantSelect: listVariant));
  }

  void unChooseVariant(int variantId) {
    final listVariant = List<VariantEntity>.from(state.listVariantSelect);
    final index = listVariant.indexWhere((e) => e.id == variantId);
    listVariant[index] = listVariant[index].copyWith(isChoose: false);
    emit(state.copyWith(listVariantSelect: listVariant));
  }

  bool checkVariantIsSelected(int? variantId) {
    final variant =
        state.listVariantSelect.firstWhere((e) => e.id == variantId);
    if (variant.amount > 0) {
      return true;
    }
    return false;
  }

  VariantEntity getVariantSelected(int? variantId) {
    return state.listVariantSelect.firstWhere((e) => e.id == variantId);
  }

  void cacheItem() {}

  void changeAmount(VariantEntity variant, int value) {
    final updatedList =
        List<VariantEntity>.from(state.listVariantSelect);
    final index = updatedList.indexWhere((e) => e == variant);
    updatedList[index] = updatedList[index].copyWith(amount: value);
    emit(
      state.copyWith(
        listVariantSelect: updatedList,
      ),
    );

  }


  void selectFilterButton(FilterButtonItem value) {
    emit(state.copyWith(selectFilter: value));
    infiniteListController.onRefresh();
  }
}
