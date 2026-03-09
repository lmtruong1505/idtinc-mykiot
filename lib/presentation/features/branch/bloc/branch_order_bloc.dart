import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/utils/delay_callback.dart';
import '../../../features_v2/blocs/state/init_state.dart';
import '../../order/data/mapper/order_preview_entity_mapper.dart';
import '../../order/domain/entities/order_preview_entity.dart';
import '../../order/domain/repositories/order_repository.dart';

class BranchOrderBloc extends Cubit<CubitState> {
  BranchOrderBloc() : super(CubitState());

  final _repo = getIt<OrderRepository>();
  final _orderMapper = OrderPreviewEntityMapper();
  final List<OrderPreviewEntity> orders = [];
  final _delay = DelayCallBack(delay: 500.milliseconds);
  int? _company;
  int? get company => _company;

  set company(int? value) {
    _company = value;
  }

  int _page = 1;
  String? _search;

  changeSearch({
    String? value,
  }) {
    _search = value;
    _delay.debounce(getList);
  }

  getList({
    bool isMore = false,
  }) async {
    if (isMore) {
      _page++;
    } else {
      _page = 1;
      orders.clear();
    }
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getList(
      company: _company ?? -1,
      page: _page,
      limit: 15,
      search: _search,
    );

    orders.addAll(
      _orderMapper.mapToListEntity(res.data ?? []),
    );

    emit(state.copyWith(status: BlocStatus.success));
  }
}
