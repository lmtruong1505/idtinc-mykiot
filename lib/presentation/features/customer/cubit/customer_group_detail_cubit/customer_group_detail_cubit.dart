import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/customer/domain/usecase/customer_group_delete_use_case.dart';

import '../../domain/usecase/customer_group_detail_use_case.dart';
import 'customer_group_detail_state.dart';

@injectable
class CustomerGroupDetailCubit extends Cubit<CustomerGroupDetailState> {
  CustomerGroupDetailCubit(
    this._customerGroupDetailUseCase,
    this._customerGroupDeleteUseCase,
  ) : super(const CustomerGroupDetailState());

  final CustomerGroupDetailUseCase _customerGroupDetailUseCase;
  final CustomerGroupDeleteUseCase _customerGroupDeleteUseCase;

  Future<void> getDetail(int id) async {
    emit(state.copyWith(isLoading: true));
    final input = CustomerGroupDetailInput(id: id);
    final res = await _customerGroupDetailUseCase.execute(input);
    emit(
      state.copyWith(
        customerGroup: res.response.data,
        isLoading: false,
      ),
    );
  }

  Future<void> delete(int id) async {
    emit(state.copyWith(isLoading: true));
    final input = CustomerGroupDeleteInput(id: id);
    await _customerGroupDeleteUseCase.execute(input);
    emit(
      state.copyWith(
        isLoading: false,
      ),
    );
  }

}
