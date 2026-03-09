import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';


import '../../../../../shared/constants/pref_key.dart';
import '../../../../../shared/constants/storage/shared_preference.dart';
import '../../../../base/infinite_list.dart';
import '../../domain/entities/variant_entity.dart';
import '../../domain/usecase/variant_list_use_case.dart';
import 'variant_list_state.dart';

@injectable
class VariantListCubit extends Cubit<VariantListState> {
  VariantListCubit(
    this._variantListUseCase,
  ) : super(const VariantListState());

  final VariantListUseCase _variantListUseCase;

  final InfiniteListController<VariantEntity> infiniteListController =
      InfiniteListController<VariantEntity>.init();
  final ScrollController scrollController = ScrollController();

  Timer? timerSearch;

  void init({
    List<VariantEntity>? listInit,
  }) {
    emit(
      state.copyWith(
        variantSelected: listInit ?? state.variantSelected,
      ),
    );
  }

  void searchChange(String value) {
    emit(state.copyWith(search: value));
    if (timerSearch != null) {
      timerSearch?.cancel();
    }
    timerSearch = Timer(const Duration(seconds: 1), () { 
      infiniteListController.onRefresh();
    });
  }

  void selectVariant(VariantEntity value) {
    final list = List<VariantEntity>.from(state.variantSelected);
    if (list.contains(value)) {
      list.remove(value);
    } else {
      list.add(value);
    }
    emit(state.copyWith(variantSelected: list));
  }

  Future<List<VariantEntity>> getList(int page) async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    if (company == null) {
      return [];
    }
    final input = VariantListInput(
      company: company,
      page: page + 1,
      limit: state.limit,
      search: state.search,
    );
    final res = await _variantListUseCase.execute(input);
    return res.response.data ?? [];
  }
}
