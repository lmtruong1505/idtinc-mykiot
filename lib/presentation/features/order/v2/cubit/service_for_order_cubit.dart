import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/order/v2/cubit/service_for_order_state.dart';
import 'package:pharmago/presentation/features/product/domain/entities/service_entity.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/service_list_use_case.dart';

import '../../../../base/filter_button.dart';
import '../../../../base/infinite_list.dart';
import '../../../../shared/utils/get.dart';

@injectable
class ServiceForOrderCubit extends Cubit<ServiceForOrderState>{
    ServiceForOrderCubit(this._serviceListUseCase) : super(const ServiceForOrderState());

    final ServiceListUseCase _serviceListUseCase;

    final ScrollController scrollController = ScrollController();
    final infiniteListController = InfiniteListController<ServiceEntity>.init();

    Timer? timerSearch;

    void init(List<ServiceEntity> value) {
      emit(state.copyWith(listServiceSelect: value));
    }

    void searchServiceHandle(String value) {
      emit(state.copyWith(searchKey: value));
      if (timerSearch != null) {
        timerSearch?.cancel();
      }
      timerSearch = Timer(const Duration(milliseconds: 500), () {
        infiniteListController.onRefresh();
      });
      timerSearch;
    }

    void searchChooseServiceHandle(String value) {}

    Future<List<ServiceEntity>> getListService({
      required int page,
    }) async {
      final company = getCompany as int;
      final input = ServiceListInput(
        company: company,
        page: page,
        limit: state.limit,
        search: state.searchKey,
      );
      final res = await _serviceListUseCase.execute(input);
      final listService = List<ServiceEntity>.from(state.listServiceSelect);
      final listId = listService.map((e) => e.id).toList();
      for (final item in res.response.data ?? []) {
        if (!listId.contains(item.id)) {
          listService.add(item);
        }
      }
      emit(state.copyWith(listServiceSelect: listService));
      return res.response.data ?? <ServiceEntity>[];
    }

    Future<void> selectService({required int serviceId, int? customer}) async {
      //final accountId = getUserId;
      final listService = List<ServiceEntity>.from(state.listServiceSelect);
      final index = listService.indexWhere((e) => e.id == serviceId);
      if (checkServiceIsSelected(serviceId) == false) {
        listService[index] = listService[index].copyWith(isChoose: true);
      }
      emit(state.copyWith(listServiceSelect: listService));
      // _totalPrice();
    }

    void updateService(ServiceEntity item) {
      final listService = List<ServiceEntity>.from(state.listServiceSelect);
      final index = listService.indexWhere((e) => e.id == item.id);
      listService[index] = item.copyWith(isChoose: true);
      emit(state.copyWith(listServiceSelect: listService));
    }

    void unChooseService(int serviceId) {
      final listService = List<ServiceEntity>.from(state.listServiceSelect);
      final index = listService.indexWhere((e) => e.id == serviceId);
      listService[index] = listService[index].copyWith(isChoose: false);
      emit(state.copyWith(listServiceSelect: listService));
    }

    bool checkServiceIsSelected(int? serviceId) {
      final service =
      state.listServiceSelect.firstWhere((e) => e.id == serviceId);
      if ((service.amount) > 0) {
        return true;
      }
      return false;
    }

    ServiceEntity getServiceSelected(int? serviceId) {
      return state.listServiceSelect.firstWhere((e) => e.id == serviceId);
    }

    void cacheItem() {}

    void changeAmount(ServiceEntity service, double value) {
      final updatedList =
      List<ServiceEntity>.from(state.listServiceSelect);
      final index = updatedList.indexWhere((e) => e == service);
      updatedList[index] = updatedList[index].copyWith(price: value);
      emit(
        state.copyWith(
          listServiceSelect: updatedList,
        ),
      );
      // _updateQuantityPromoForCustomer(Service.id!);
      // _totalPrice();
    }

    void selectFilterButton(FilterButtonItem value) {
      emit(state.copyWith(selectFilter: value));
      infiniteListController.onRefresh();
    }
}
