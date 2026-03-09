import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/models/customer/product_customer_mode.dart';
import '../../repositories/customer/customer_repository_v2.dart';
import '../state/init_state.dart';

class PrdCustomerBloc extends Cubit<CubitState> {
  PrdCustomerBloc() : super(CubitState());
  final _repo = CustomerRepositoryV2();
  final List<ProductCustomerModel> list = [];
  int _page = 1;

  getList(
    int customerId, {
    bool isMore = false,
  }) async {
    if (isMore) {
      _page++;
    } else {
      _page = 1;
      list.clear();
    }
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getProduct(
      page: _page,
      limit: 15,
      customerId: customerId,
    );

    list.addAll(res.data ?? []);

    emit(state.copyWith(status: BlocStatus.success));
  }
}
