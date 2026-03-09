import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/order/cubit/order_create_cubit/order_create_state.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_entity.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/variant_list_use_case.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

import '../state/init_state.dart';

class ListPrdPkBloc extends Cubit<CubitState> {
  ListPrdPkBloc() : super(CubitState());
  final _userCase = getIt<VariantListUseCase>();
  final List<VariantEntity> list = [];
  int _page = 1;
  final _delay = DelayCallBack(delay: 500.milliseconds);
  String? _search;
  VariantEntity? product;

  choosePrd(VariantEntity? value) {
    product = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  changeSearch(String? value) {
    _search = value;
    _delay.debounce(
      () => getList(),
    );
  }

  FilterItemOrder _filter = FilterItemOrder.best_seller;
  changeFilter(FilterItemOrder value) {
    _filter = value;
    getList();
  }

  getList({
    bool isMore = false,
  }) async {
    if (isMore) {
      _page++;
    } else {
      _page = 1;
      list.clear();
    }
    emit(state.copyWith(status: BlocStatus.loading));
    final input = VariantListInput(
      company: getCompany ?? 0,
      page: _page,
      limit: 20,
      search: _search ?? '',
      filter: _filter.code,
    );
    final res = await _userCase.execute(input);
    list.addAll(res.response.data ?? []);
    emit(state.copyWith(status: BlocStatus.success));
  }
}
