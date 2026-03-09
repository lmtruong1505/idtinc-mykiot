import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/features/order/cubit/order_detail_cubit/order_detail_cubit.dart';
import 'package:pharmago/presentation/features/order/domain/entities/order_preview_entity.dart';
import 'package:pharmago/presentation/features/order/domain/usecase/order_list_use_case.dart';
import 'package:pharmago/presentation/features/order/domain/usecase/order_update_status_use_case.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

import '../../../../../data/models/base/response.dart';
import '../../widgets/bts_filter_order.dart';
import '../order_create_cubit/order_create_state.dart';
import 'order_list_state.dart';


@singleton
class OrderListCubit extends Cubit<OrderListState> {
  OrderListCubit(
    this._orderListUseCase,
    this._orderUpdateStatusUseCase,
  ) : super(const OrderListState());

  final OrderListUseCase _orderListUseCase;
  final OrderUpdateStatusUseCase _orderUpdateStatusUseCase;
  final DelayCallBack _delayCallBack = DelayCallBack(delay: 500.milliseconds);

  final infiniteListController =
      InfiniteListController<OrderPreviewEntity>.init();
  final scrollController = ScrollController();

  Future<List<OrderPreviewEntity>> getList(int page, {int? id}) async {
    final company = getCompany;
    if (company == null) {
      return [];
    }
    final input = OrderListInput(
      company: id ?? company,
      limit: state.limit,
      page: page + 1,
      type: state.selectFilter.code.toLowerCase(),
      search: state.search,
      createdFrom: state.createdAtFrom,
      createdTo: state.createdAtTo,
      updatedFrom: state.updatedFrom,
      updatedTo: state.updatedTo,
      orderBy: state.orderBy?.code,
    );
    final res = await _orderListUseCase.execute(input);
    emit(state.copyWith(orderCount: res.response.extra));
    return res.response.data ?? [];
  }

  Future<BaseResponseModel> updateStatus(int id, OrderStatus value) async {
    final input = OrderUpdateStatusInput(
      id: id,
      code: value.code,
    );
    final res = await _orderUpdateStatusUseCase.execute(input);
    if (res.response.code == 200) {
      infiniteListController.onRefresh();
    }
    return res.response;
  }

  void filterChange({
    DateTime? createdAtFrom,
    DateTime? createdAtTo,
    OrderFilterOrderBy? orderBy,
    DateTime? updatedFrom,
    DateTime? updatedTo,
  }) {
    emit(
      state.copyWith(
        createdAtFrom: createdAtFrom,
        createdAtTo: createdAtTo,
        updatedFrom: updatedFrom,
        updatedTo: updatedTo,
        orderBy: orderBy,
      ),
    );
    infiniteListController.onRefresh();
  }

  void selectFilterButton(OrderType value) {
    emit(state.copyWith(selectFilter: value));
    infiniteListController.onRefresh();
  }

  void search(String? value) {
    _delayCallBack.debounce(() {
      emit(state.copyWith(search: value));
      infiniteListController.onRefresh();
    });

  }
}
