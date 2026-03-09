import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../base/filter_button.dart';
import '../../../../shared/constants/enums/status_order.dart';
import '../../data/models/order_wm_count_filter_model.dart';

part 'list_wm_state.freezed.dart';

@freezed
class ListWmState with _$ListWmState {
  const factory ListWmState({
    @Default(<FilterButtonItem>[]) List<FilterButtonItem> listFilter,
    @Default(FilterButtonItem('Tất cả', StatusOrder.all))
    FilterButtonItem selectFilter,
    @Default([]) List list,
    @Default(10) int limit,
    @Default(null) bool? isOnline,
    @Default('') String searchKey,
    int? dataProvince,
    int? dataDistrict,
    int? dataWard,
    @Default(null) int? region,
    @Default([]) List<DateTime?> datesSerach,
    @Default([]) List<DropdownMenuItem<int?>> listRegion,
    @Default(false) bool isFilterAdvanced,
    @Default([
      OrderCountFilterModel(
        type: 'DH',
        count: 0,
      ),
      OrderCountFilterModel(
        type: 'DXN',
        count: 0,
      ),
      OrderCountFilterModel(
        type: 'CXN',
        count: 0,
      ),
      OrderCountFilterModel(
        type: 'HT',
        count: 0,
      ),
      OrderCountFilterModel(
        type: 'TC',
        count: 0,
      ),
      OrderCountFilterModel(
        type: 'ALL',
        count: 0,
      ),
    ])
    List<OrderCountFilterModel> orderCountFilter,
  }) = _ListWmState;
}
