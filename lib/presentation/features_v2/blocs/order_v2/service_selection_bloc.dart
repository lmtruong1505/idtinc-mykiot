import 'package:bloc/bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/models/service/service.dart';
import 'package:pharmago/presentation/features_v2/repositories/service/serrvice_v2_repository.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../models/employee/pre_emp_model.dart';
import '../../models/employee/user_data_model.dart';
import '../../models/event/detail_event_model.dart';
import '../enum/bloc_status.dart';

class ServiceSelectionBloc extends Cubit<CubitState> {
  ServiceSelectionBloc() : super(CubitState());

  int _page = 1;

  int get page => _page;
  final _repo = ServiceV2Repository();

  double _price = 0;

  double get price => _price;

  double _chietKhau = 0;

  double get chietKhau => _chietKhau;

  double get total => _price - _chietKhau;

  List<ServiceV2Model> _list = [];

  List<ServiceV2Model> get list => _list;

  bool _valid = false;
  bool get valid => _valid;

  set list(List<ServiceV2Model> value) {
    _list = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  void addService(ServiceV2Model service) {
    final index = getIndexOfservice(service.id, price: service.price?.id);
    if (index != -1) {
      _list[index] = service;
    } else {
      _list.add(service);
    }
    calcPrice();
  }

  void removeservice(int? index) {
    if (index != -1) {
      _list.removeAt(index!);
    }
    calcPrice();
  }

  void clearList() {
    _list.clear();
    calcPrice();
  }

  void calcPrice() {
    _price = _list.fold(
      0.0,
      (previousValue, e) =>
          previousValue +
          (e.priceCustom?.price ?? e.price?.price ?? 0) * e.quantity,
    );

    _chietKhau = _list.fold(
      0.0,
      (previousValue, e) => previousValue + (e.discount * e.quantity),
    );
    checkValid();
    emit(state.copyWith(status: BlocStatus.success));
  }

  void checkValid() {
    for (final item in _list) {
      if (item.quantity.validator <= 0) {
        _valid = false;
        emit(state.copyWith(status: BlocStatus.success));
        return;
      }
    }
    _valid = true && _list.isNotEmpty;
  }

  void updateService(
    ServiceV2Model item, {
    int? quantity,
    num? price,
    PreEmpModel? employee,
  }) {
    final newService = item.copyWith(
      quantity: quantity,
      price: item.price!.copyWith(price: price),
      employee: employee,
    );
    final index = _list.indexWhere((e) => e.id == newService.id && e.price?.id == newService.price?.id);
    _list[index] = newService;
    calcPrice();
  }

  int getIndexOfservice(int? id, {int? price}) {
    return _list.indexWhere((e) => e.id == id && e.price?.id == price);
  }

  Future<List<ServiceV2Model>> getList(
    String? search, {
    bool isMore = false,
  }) async {
    emit(CubitState(status: BlocStatus.loading));
    if (!isMore) {
      _page = 1;
    } else {
      _page++;
    }
    final res = await _repo.getList(
      companyId: getCompany ?? -1,
      page: page,
      search: search,
      isActive: true,
      splitUnit: true,
    );
    if (res.data != null && res.data!.isEmpty) _page--;
    return res.data ?? [];
  }

  Future<void> findServices(List<ServicesEvent>? list) async {
    if (list?.isEmpty ?? true) return;
    final listConvert = list
        ?.map(
          (e) => e.serviceData!.copyWith(
            price: e.price,
            employee: PreEmpModel(
              id: e.employeeData?.id,
              employee: e.employeeData?.id,
              userData: UserDataModel(
                id: e.employeeData?.id,
                fullName: e.employeeData?.fullName,
              ),
            ),
          ),
        )
        .toList();
    _list.addAll(listConvert ?? []);
    calcPrice();
    // final res = await _repo.getList(
    //   companyId: getCompany ?? -1,
    //   ids: list?.map((e) => e.id!).toList() ?? [],
    //   splitUnit: true,
    // );
    // if (res.code == 200 && (res.data?.isNotEmpty ?? false)) {
    //   _list.addAll(listConvert);
    //   _list.add(value)
    //   calcPrice();
    // }
  }

  String? get validateBeforeNext {
    for (final item in _list) {
      if (item.employee == null) {
        return 'Dịch vụ ${item.title} chưa thêm người thực hiện';
      }
    }
    return null;
  }
}
