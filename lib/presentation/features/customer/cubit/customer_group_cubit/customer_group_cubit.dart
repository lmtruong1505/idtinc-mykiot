import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/features/customer/domain/usecase/customer_group_list_use_case.dart';

import '../../../../../shared/constants/pref_key.dart';
import '../../../../../shared/constants/storage/shared_preference.dart';
import '../../domain/entities/customer_group_entity.dart';
import 'customer_group_state.dart';

@injectable
class CustomerGroupCubit extends Cubit<CustomerGroupState> {
  CustomerGroupCubit(this._customerGroupListUseCase)
      : super(const CustomerGroupState());

  final CustomerGroupListUseCase _customerGroupListUseCase;
  final ScrollController scrollController = ScrollController();
  final InfiniteListController<CustomerGroupEntity> customerGroupsILC =
      InfiniteListController<CustomerGroupEntity>.init();

  Future<List<CustomerGroupEntity>> listCustomerGroups(int page) async {
    final company =
    AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    final input = CustomerGroupListInput(
      search: state.search,
      limit: state.limit,
      page: page + 1,
      company: company,
    );
    final res = (await _customerGroupListUseCase.execute(input)).response.data ?? [];
    return res ;
  }
}
