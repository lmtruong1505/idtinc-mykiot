import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/order/domain/entities/order_preview_entity.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';
import 'package:pharmago/presentation/features_v2/repositories/phieu_kham/phieu_kham_repository.dart';

import '../../../features/order/data/mapper/order_preview_entity_mapper.dart';
import '../state/init_state.dart';

class OrderPkBloc extends Cubit<CubitState> {
  OrderPkBloc() : super(CubitState());

  final _repo = PhieuKhamRepository();
  final List<OrderPreviewEntity> list = [];

  int _page = 1;
  TypeOrderEnum? type = TypeOrderEnum.sell;

  getList({
    required String uuid,
    bool isMore = false,
  }) async {
    if (isMore) {
      _page++;
    } else {
      _page = 1;
      list.clear();
    }
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.order(
      type: type,
      uuid: uuid,
      page: _page,
    );
    final data = OrderPreviewEntityMapper().mapToListEntity(res.data ?? []);
    list.addAll(data);
    emit(state.copyWith(status: BlocStatus.success));
  }
}
