import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/repositories/kafa/kafa_repository.dart';

import '../../models/kafa/kafa_order_detail.dart';
import '../state/init_state.dart';

class KafaOrderDetailBloc extends Cubit<CubitState<KafaOrderDetailModel>> {
  KafaOrderDetailBloc() : super(CubitState());
  final _repo = KafaRepository();

  getData(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.detail(id);
    
    emit(state.copyWith(status: BlocStatus.success,data: res.data));
  }
}
