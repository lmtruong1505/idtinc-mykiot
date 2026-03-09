import 'package:bloc/bloc.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';

import '../../../features/company/data/models/point_exchange_package_model.dart';
import '../../models/customer/v2/customer_model.dart';
import '../../models/customer/v2/customer_point_item_model.dart';
import '../../models/product/product_v2_model.dart';
import '../../repositories/customer/customer_repository_v2.dart';
import '../enum/bloc_status.dart';

class CustomerSelectionBloc extends Cubit<CubitState> {
  CustomerSelectionBloc() : super(CubitState());

  int _page = 1;
  int get page => _page;
  final _repo = CustomerRepositoryV2();

  CustomerV2Model? _model;
  CustomerV2Model? get model => _model;

  set model(CustomerV2Model? value) {
    _model = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  List<ProductV2Model>? _productExchangePoint;
  List<ProductV2Model>? get productExchangePoint => _productExchangePoint;

  set productExchangePoint(List<ProductV2Model>? value) {
    _productExchangePoint = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  List<PointExchangePackageModel>? _productsFromPackage;
  List<PointExchangePackageModel>? get productsFromPackage => _productsFromPackage;

  set productsFromPackage(List<PointExchangePackageModel>? value) {
    _productsFromPackage = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  CustomerPointItemModel? _moneyExchange;
  CustomerPointItemModel? get moneyExchange => _moneyExchange;

  set moneyExchange(CustomerPointItemModel? value) {
    _moneyExchange = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<List<CustomerV2Model>> getList(
    String? search, {
    bool isMore = false,
    String? type,
    int? parentCustomer,
  }) async {
    emit(CubitState(status: BlocStatus.loading));
    if (!isMore) {
      _page = 1;
    } else {
      _page++;
    }
    final res = await _repo.getList(
      page: _page,
      companyId: getCompanyId ?? -1,
      search: search,
      type: type,
      parentCustomer: parentCustomer,
    );
    if (res.data != null && res.data!.isEmpty) _page--;
    return res.data ?? [];
  }

  Future<void> findCus(int? id) async {
    if (id == null) return;
    final res = await _repo.detail(id);
    if (res.code == 200) {
      model = res.data;
    }
  }
}
