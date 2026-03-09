import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/company/cubit/auth_ws_manager_cubit/auth_ws_manager_state.dart';
import 'package:pharmago/presentation/features/company/data/models/user_serial_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/models/order/count_prod_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

import '../../../di/di.dart';
import '../../../features/company/cubit/auth_ws_manager_cubit/auth_ws_manager_cubit.dart';
import '../../../shared/utils/get.dart';
import '../../models/order/preview_order_model.dart';
import '../../repositories/order/order_v2_repo.dart';
import '../../screens/order/components/bts/bts_filter_order.dart';
import '../../screens/product/components/bts_filter_prod.dart';
import '../enum/bloc_status.dart';

@Singleton()
class OrderManagerBloc extends Cubit<CubitState> {
  OrderManagerBloc() : super(CubitState());

  final orderListRepo = OrderV2Repo();
  List<UserSerialModel>? userSerials;
  UserSerialModel? serialSelected;

  int count = 0;
  num revenueInMonth = 0;
  num revenue = 0;
  final _delay = DelayCallBack(delay: 500.milliseconds);
  final repo = OrderV2Repo();

  int? company = getCompany;

  bool _isRemember = true;
  bool get isSelectAll =>
      _list.every((prd) => prd.isSelect == true) && _list.isNotEmpty;

  bool get isShowCheckbox => isSelectInvoice || isSelectSynchronizePharma;
  bool get isSelectInvoice =>
      _invoice != null && _invoice != ElectricInvoiceType.all;
  bool get isSelectSynchronizePharma =>
      _synchronizePharma != null &&
      _synchronizePharma != SynchronizePharmaceuticalType.all;
  init({int? companyID}) {
    emit(CubitState());
    _page = 1;
    _search = '';
    _type = OrderTypeV2.all;
    _status = OrderStatus.all;
    _time = TimeCreated.all;
    _price = RangePrice.all;
    company = companyID ?? getCompany;
    getList();
  }

  int _page = 1;
  int get page => _page;

  String? _search;
  String get search => _search ?? '';

  List<PreviewOrderModel> _list = [];
  List<PreviewOrderModel> get list => _list;

  void changeSearch(String? value) {
    _search = value;
    _delay.debounce(
      () => getList(),
    );
  }

  bool get isRemember => _isRemember;

  void changeRemember() {
    _isRemember = !_isRemember;
    emit(state.copyWith(status: BlocStatus.reload));
  }

  OrderTypeV2 _type = OrderTypeV2.all;
  OrderTypeV2 get type => _type;

  OrderStatus _status = OrderStatus.all;
  OrderStatus get status => _status;

  TimeCreated _time = TimeCreated.all;
  TimeCreated get time => _time;

  RangePrice _price = RangePrice.all;
  RangePrice get price => _price;
  ElectricInvoiceType? _invoice;
  ElectricInvoiceType? get invoice => _invoice;

  SynchronizePharmaceuticalType? _synchronizePharma;
  SynchronizePharmaceuticalType? get synchronizePharma => _synchronizePharma;

  int? _customer;
  int? get customer => _customer;

  bool get isSort =>
      _type != OrderTypeV2.all ||
      _status != OrderStatus.all ||
      _time != TimeCreated.all ||
      _price != RangePrice.all;

  bool get showCheckBox =>
      (_synchronizePharma != SynchronizePharmaceuticalType.all &&
          _synchronizePharma != null) ||
      (_invoice != ElectricInvoiceType.all && _invoice != null);

  void changeFilter({
    OrderTypeV2? type,
    OrderStatus? status,
    TimeCreated? time,
    RangePrice? price,
    int? customer,
    ElectricInvoiceType? invoice,
    SynchronizePharmaceuticalType? synchronizePharma,
  }) {
    _type = type ?? OrderTypeV2.all;
    _status = status ?? OrderStatus.all;
    _time = time ?? TimeCreated.all;
    _price = price ?? RangePrice.all;
    _customer = customer ?? customer;
    _invoice = invoice ?? ElectricInvoiceType.all;
    _synchronizePharma = synchronizePharma ?? SynchronizePharmaceuticalType.all;
    getList();
  }

  void clearFilter() {
    _type = OrderTypeV2.all;
    _status = OrderStatus.all;
    _time = TimeCreated.all;
    _price = RangePrice.all;
    _customer = null;
    _invoice = ElectricInvoiceType.all;
    _synchronizePharma = SynchronizePharmaceuticalType.all;
    getList();
  }

  getList({bool isMore = false}) async {
    emit(state.copyWith(status: BlocStatus.loading));
    if (isMore) {
      _page++;
    } else {
      _list.clear();
      _page = 1;
    }

    final res = await repo.getList(
      company: company ?? -1,
      page: _page,
      search: _search,
      type: _type == OrderTypeV2.all ? null : _type.name,
      limit: 10,
      status: _status == OrderStatus.all ? null : _status.code,
      priceGte: _price == RangePrice.all ? null : _price.minVal?.toInt(),
      priceLte: _price == RangePrice.all ? null : _price.maxVal?.toInt(),
      time: _time,
      customer: _customer,
      typeCode: getIt.get<AuthWsManagerCubit>().state.typeCodeWarehouse,
    );
    _list.addAll(res.data ?? []);
    if (res.extra['count'] is CountProdModel) {
      final countModel = (res.extra['count'] as CountProdModel);
      count = countModel.product ?? 0 + (countModel.service ?? 0);
    }
    revenue = res.extra['revenue'] ?? revenue;
    revenueInMonth = res.extra['revenue_in_month'] ?? revenueInMonth;
    final isFirst = !isSort && _list.isEmpty && _search.isEmptyOrNull;

    emit(state.copyWith(status: BlocStatus.success, isFirst: isFirst));
  }

  bool get canSelect => _list.where((prd) => prd.isSelect == true).length < 10;
  List<PreviewOrderModel>? get listSelected =>
      _list.where((prd) => prd.isSelect == true).toList();

  void onToggleProduct(PreviewOrderModel prd) {
    _list = _list.map((e) {
      if (prd.id == e.id) {
        return e.copyWith(isSelect: !(e.isSelect ?? false));
      }
      return e;
    }).toList();
    print('onToggleProduct');
    emit(state.copyWith(status: BlocStatus.success));
  }

  void onToggleAll(bool? value) {
    _list = _list.map((e) {
      return e.copyWith(isSelect: !isSelectAll);
    }).toList();
    print('onToggleProduct');
    emit(state.copyWith(status: BlocStatus.success));
  }

  void selectMax() {
    if ((listSelected?.length ?? 0) < 10) {
      _list = _list.map((e) {
        final index = _list.indexOf(e);
        if (index < 10) {
          return e.copyWith(isSelect: true);
        }
        return e.copyWith(isSelect: false);
      }).toList();
    } else {
      _list = _list.map((e) {
        return e.copyWith(isSelect: false);
      }).toList();
    }

    emit(state.copyWith(status: BlocStatus.success));
  }

  final delay = DelayCallBack(delay: 10.seconds);

  void createExportInvoice(String serial) async {
    try {
      emit(state.copyWith(status: BlocStatus.submit));
      final ids = listSelected?.map((e) => e.id ?? 0).toList();
      final res = await repo.createExportInvoice(serial, 0, ids);

      delay.debounce(() {
        if (res.code == 200) {
          emit(state.copyWith(status: BlocStatus.submitSuccess));
          getList();
        } else {
          emit(state.copyWith(status: BlocStatus.submitFailure));
        }
      });
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.submitFailure));
    }

    // if (res.code == 200) {
    //   emit(state.copyWith(status: BlocStatus.reload));
    // } else {
    //   emit(state.copyWith(status: BlocStatus.failure));
    // }
  }

  void createRedInvoice() async {
    try {
      emit(state.copyWith(status: BlocStatus.submit));
      final ids = listSelected?.map((e) => e.id ?? 0).toList();
      final res = await orderListRepo.createExportInvoice(
        serialSelected?.serial ?? '',
        serialSelected?.id ?? 0,
        ids,
      );
      delay.debounce(() {
        if (res.code == 200) {
          emit(state.copyWith(status: BlocStatus.submitSuccess, msg: null));
          getList();
        } else {
          emit(state.copyWith(
              status: BlocStatus.submitFailure, msg: res.message));
        }
      });
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.submitFailure, msg: e.toString()));
    }
  }

  void selectInvoice(UserSerialModel? value) {
    serialSelected = value;
  }
}
