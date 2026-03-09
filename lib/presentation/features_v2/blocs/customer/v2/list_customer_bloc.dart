import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

import '../../../../shared/constants/enums/status_order.dart';
import '../../../models/customer/v2/customer_model.dart';
import '../../../repositories/customer/customer_repository_v2.dart';
import '../../enum/enum_bloc.dart';
import '../../state/init_state.dart';

@Singleton()
class ListCustomerV2Bloc extends Cubit<CubitState> {
  ListCustomerV2Bloc() : super(CubitState());
  final _repo = CustomerRepositoryV2();
  final List<CustomerV2Model> list = [];

  final delayCallback = DelayCallBack();

  void init() {
    emit(
      CubitState(isFirst: true),
    );
    _page = 1;
    _search = null;
    _typeOrder = null;
    _isZalo = null;
    _rangePrice = null;
    list.clear();
    // getList();
  }

  RangePriceV2Enum? _rangePrice;

  RangePriceV2Enum? get rangePrice => _rangePrice;

  TypeOrderV2Enum? _typeOrder;

  TypeOrderV2Enum? get typeOrder => _typeOrder;

  IsDebtEnum? _isDebt;

  IsDebtEnum? get isDebt => _isDebt;

  bool? _isZalo;

  bool? get isZalo => _isZalo;

  String? _search;

  int? _parent;

  set search(String value) {
    _search = value;
    getList();
  }

  int _page = 1;
  final int limit = 20;
  bool get isFilter =>
      _isZalo != null ||
      _typeOrder?.code.isEmptyOrNull == false ||
      _rangePrice?.min != null ||
      _rangePrice?.max != null;

  void setFilter({
    RangePriceV2Enum? rangePriceVal,
    TypeOrderV2Enum? typeOrderVal,
    IsDebtEnum? isDebt,
    bool? isZaloVal,
    int? parent,
  }) {
    _rangePrice = rangePriceVal;
    _typeOrder = typeOrderVal;
    _isDebt = isDebt;
    _isZalo = isZaloVal;
    _parent = parent;
    getList();
  }

  Future<void> getList({bool isMore = false}) async {
    if (state.status == BlocStatus.loading) {
      return;
    }
    if (isMore && list.length < limit) return;
    if (isMore && list.length >= limit) {
      _page++;
    } else {
      _page = 1;
      list.clear();
    }
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getList(
      companyId: getCompanyId!,
      isZalo: _isZalo,
      typeOrder: _typeOrder?.code,
      search: _search,
      maxPrice: _rangePrice?.max,
      minPrice: _rangePrice?.min,
      page: _page,
      limit: limit,
      isDebt: _isDebt?.data,
      parentCustomer: _parent,
    );
    if (res.data.validator.isEmpty && isMore) {
      _page--;
    }

    list.addAll(res.data ?? []);
    final isFirst = _search.isEmptyOrNull && !isFilter && list.isEmpty;
    emit(
      state.copyWith(
        status: BlocStatus.success,
        isFirst: isFirst,
        //isFirst: state.isFirst && list.isEmpty,
      ),
    );
  }

  Future<CustomerV2Model?> checkIsExist(String phonee) async {
    if (phonee.isEmptyOrNull) {
      return null;
    }
    final res = await _repo.getList(
      companyId: getCompanyId!,
      search: phonee,
      page: 1,
      limit: 1000,
    );
    if (res.data.validator.isEmpty) {
      return null;
    }
    final customers =
        res.data!.where((element) => element.phone == phonee);
    return customers.firstOrNull;
  }
}
