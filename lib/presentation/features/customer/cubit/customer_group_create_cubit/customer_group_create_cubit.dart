import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/customer/domain/usecase/customer_group_update_usecase.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../shared/constants/pref_key.dart';
import '../../../../../shared/constants/storage/shared_preference.dart';
import '../../domain/entities/customer_entity.dart';
import '../../domain/usecase/customer_group_create_use_case.dart';
import '../../domain/usecase/customer_group_detail_use_case.dart';
import 'customer_group_create_state.dart';

@injectable
class CustomerGroupCreateCubit extends Cubit<CustomerGroupCreateState> {
  CustomerGroupCreateCubit(
    this._customerGroupCreateUseCase,
    this._customerGroupDetailUseCase,
    this._customerGroupUpdateUseCase,
  ) : super(const CustomerGroupCreateState());

  final CustomerGroupCreateUseCase _customerGroupCreateUseCase;
  final CustomerGroupDetailUseCase _customerGroupDetailUseCase;
  final CustomerGroupUpdateUseCase _customerGroupUpdateUseCase;

  void changeCode(String code) {
    emit(
      state.copyWith(
        customerGroup: state.customerGroup.copyWith(code: code),
      ),
    );
  }

  void changeName(String name) {
    emit(
      state.copyWith(
        customerGroup: state.customerGroup.copyWith(name: name),
      ),
    );
  }

  void changeNote(String note) {
    emit(
      state.copyWith(
        customerGroup: state.customerGroup.copyWith(note: note),
      ),
    );
  }

  void selectCustomer(List<CustomerEntity> customers) {
    emit(
      state.copyWith(customerList: customers, customerSearchList: customers),
    );
  }

  void removeCustomer(CustomerEntity customer) {
    final customerList = List<CustomerEntity>.from(state.customerList);
    customerList.remove(customer);
    emit(
      state.copyWith(
        customerList: customerList,
        customerSearchList: customerList,
      ),
    );
  }

  void searchCustomer(String query) {
    final list = state.customerList.where((e) {
      final code = e.code?.toLowerCase();
      final name = e.name?.toLowerCase();
      final search = query.toLowerCase();
      return (code?.contains(search) ?? false) ||
          (name?.contains(search) ?? false);
    }).toList();

    emit(state.copyWith(customerSearchList: list));
  }

  Future<BaseResponseModel?> create() async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    final customerIds = state.customerList.map((e) => e.id!).toList();
    final input = CustomerGroupCreateInput(
      payload: state.customerGroup.copyWith(company: company),
      customerIds: customerIds,
    );
    final res = await _customerGroupCreateUseCase.execute(input);
    return res.response;
  }

  Future<BaseResponseModel?> update() async{
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    final customerIds = state.customerList.map((e) => e.id!).toList();
    final input = CustomerGroupUpdateInput(
      payload: state.customerGroup.copyWith(company: company),
      customerIds: customerIds,
    );
    final res = await _customerGroupUpdateUseCase.execute(input);
    return res.response;
  }

  Future<void> getDetail(int? id) async {
    if (id == null) return;
    emit(state.copyWith(isLoading: true));
    final input = CustomerGroupDetailInput(id: id);
    final res = await _customerGroupDetailUseCase.execute(input);
    emit(
      state.copyWith(
        customerGroup: res.response.data!,
        isLoading: false,
      ),
    );
  }


}
