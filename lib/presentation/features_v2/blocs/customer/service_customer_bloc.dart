import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/repositories/customer/customer_repository_v2.dart';
import '../../models/customer/service_customer_model.dart';
import '../state/init_state.dart';

class ServiceCustomerBloc extends Cubit<CubitState> {
  ServiceCustomerBloc() : super(CubitState());
  final _repo = CustomerRepositoryV2();
  final List<ServiceCustomerModel> list = [];
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
    final res = await _repo.getService(
      page: _page,
      limit: 15,
      customerId: customerId,
    );
    print('length order: ${(res.data ?? []).length}');

    list.addAll(res.data ?? []);

    emit(state.copyWith(status: BlocStatus.success));
  }
}
