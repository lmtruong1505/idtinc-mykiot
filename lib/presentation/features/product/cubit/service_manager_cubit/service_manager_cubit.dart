import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/features/product/domain/entities/service_entity.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/service_list_use_case.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

import 'service_manager_state.dart';

@injectable
class ServiceManagerCubit extends Cubit<ServiceManagerState> {
  ServiceManagerCubit(
    this._serviceListUseCase,
  ) : super(const ServiceManagerState());

  final ServiceListUseCase _serviceListUseCase;
  final ScrollController scrollController = ScrollController();
  final InfiniteListController<ServiceEntity> servicesILC =
      InfiniteListController<ServiceEntity>.init();

  final delay = DelayCallBack(delay: 500.milliseconds);

  Future<List<ServiceEntity>> getServices(int page) async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    final input = ServiceListInput(
      search: state.search,
      limit: state.limit,
      page: page + 1,
      company: company,
      active: state.selectFilter == ServiceStatus.all ? null : state.selectFilter == ServiceStatus.active,
    );
    final res = await _serviceListUseCase.execute(input);
    emit(state.copyWith(serviceCount: res.response.extra));
    return res.response.data ?? [];
  }

  void searchChange(String value) {
    delay.debounce(
      () {
        emit(state.copyWith(search: value));
        servicesILC.onRefresh();
      },
    );
  }

  void selectFilterButton(ServiceStatus value) {
    emit(state.copyWith(selectFilter: value));
    servicesILC.onRefresh();
  }
}
