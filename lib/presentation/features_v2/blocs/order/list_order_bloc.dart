import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

import '../../models/order/order_preview_model.dart';
import '../../repositories/order/order_v2_repository.dart';
import '../state/init_state.dart';

class ListOrderBloc extends Cubit<CubitState> {
  ListOrderBloc() : super(CubitState());
  final _repo = OrderRepositoryV2Impl();
  final List<OrderPreviewV2Model> orders = [];
  final _delay = DelayCallBack(delay: 500.milliseconds);
  int _page = 1;

  String? _search;
  TypeOrderEnum? type;
  String? medicalBill;

  void changeSearch({
    String? value,
    required Function() getData,
  }) {
    _search = value;
    _delay.debounce(getData);
  }

  Future<void> getList({
    bool isMore = false,
    int? customerId,
  }) async {
    if (isMore) {
      _page++;
    } else {
      _page = 1;
      orders.clear();
    }
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getList(
      company: getCompany ?? 0,
      page: _page,
      limit: 15,
      customerId: customerId,
      search: _search,
      type: type?.code,
      medicalBill: medicalBill,
    );

    orders.addAll(res.data?.toList() ?? []);

    emit(state.copyWith(status: BlocStatus.success));
  }
}
