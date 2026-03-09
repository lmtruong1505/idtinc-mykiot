import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features_v2/repositories/kafa/kafa_repository.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

import '../../models/kafa/kafa_order_model.dart';
import '../../models/status_count_model.dart';
import '../enum/enum_bloc.dart';
import '../state/init_state.dart';

@singleton
class ListOrderKafaBloc extends Cubit<CubitState> {
  ListOrderKafaBloc() : super(CubitState());
  final _repo = KafaRepository();
  final _delay = DelayCallBack(delay: 500.milliseconds);
  final List<KafaOrderModel> list = [];
  final List<StatusCountModel> statusCounts = List.generate(
    StatusOrderKafa.values.length,
    (index) => StatusCountModel(
      count: 0,
      status: StatusOrderKafa.values[index],
    ),
  );

  StatusOrderKafa status = StatusOrderKafa.all;
  setStatus(StatusOrderKafa value) {
    status = value;
    getList();
  }

  String? _search;
  setSearch(String? value) {
    _search = value;
    _delay.debounce(getList);
  }

  int _page = 1;
  getList({
    bool isMore = false,
  }) async {
    if (isMore) {
      _page++;
    } else {
      list.clear();
      _page = 1;
    }
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getOrder(
      company: getCompany ?? 0,
      page: _page,
      search: _search,
      statusOrder: status.code,
    );
    list.addAll(res.data ?? []);
    if (res.extra is List) {
      res.extra.forEach((e) {
        final val = StatusOrderKafa.fromCode(e['code']);
        statusCounts[StatusOrderKafa.values.indexOf(val)].count =
            int.tryParse(e['value'].toString()) ?? 0;
      });
    }
    emit(state.copyWith(status: BlocStatus.success));
  }
}
