import 'package:bloc/bloc.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/repositories/product/product_v2_repository.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/utils/delay_callback.dart';
import '../../../shared/utils/get.dart';
import '../../models/product/count_v2_model.dart';
import '../../models/product/product_v2_model.dart';
import '../../screens/product/components/bts_filter_prod.dart';
import '../enum/bloc_status.dart';

class ProductManagerBloc extends Cubit<CubitState> {
  ProductManagerBloc() : super(CubitState());

  final repo = ProductV2Repository();
  final _delay = DelayCallBack(delay: 500.milliseconds);

  int count = 0;
  bool canSelectPrd = false;
  bool? isSelectAll = false;
  List<ProductV2Model> list = [];
  int _page = 1;
  int get page => _page;

  bool get isSort =>
      _active != null ||
      _price != RangePrice.all ||
      _category != null ||
      _type != null ||
      _brand != null;

  bool? _active;
  bool? get active => _active;

  String? _search;
  String get search => _search ?? '';

  List<ProductV2Model>? get listSelect =>
      list.where((prd) => prd.isSelected).toList();
  bool isShow = false;

  set search(String? value) {
    _search = value;
    _delay.debounce(
      () => getList(),
    );
  }

  RangePrice? _price = RangePrice.all;
  RangePrice? get price => _price;

  int? _category;
  int? get category => _category;

  int? _type;
  int? get type => _type;

  int? _brand;
  int? get brand => _brand;

  int? _customer;
  int? get customer => _customer;

  List<int>? _services;
  List<int>? get services => _services;

  void changeFilter({
    bool? active,
    RangePrice? price,
    int? category,
    int? type,
    int? brand,
    int? customer,
    List<int>? services,
  }) {
    _active = active;
    _price = price;
    _category = category;
    _type = type;
    _brand = brand;
    _services = services;
    _customer = customer;
    getList();
  }

  void getList({bool isMore = false}) async {
    if (isMore) {
      _page++;
    } else {
      emit(state.copyWith(status: BlocStatus.loading));
      _page = 1;
      // list.clear();
    }
    final company = getCompany ?? -1;
    final res = await repo.products(
      company: company,
      page: _page,
      search: _search,
      limit: 20,
      active: _active,
      maxPrice: _price?.maxVal,
      minPrice: _price?.minVal,
      category: _category,
      type: _type,
      brand: _brand,
      customer: _customer,
      services: _services,
    );
    final listOldSelect = list.where((element) => element.isSelected);
    if (canSelectPrd == true &&
        listOldSelect.isNotEmpty &&
        res.data?.isNotEmpty == true) {
      final initList = res.data?.map((newPrd) {
        listOldSelect.forEach((oldPrd) {
          if (oldPrd.id == newPrd.id) {
            newPrd = newPrd.copyWith(isSelected: true);
          }
        });
        return newPrd;
      }).toList();
      if (!isMore) {
        list = initList ?? [];
      } else {
        list.addAll(res.data ?? []);
      }
    } else {
      if (!isMore) {
        list.clear();
      }
      list.addAll(res.data ?? []);
      //cập nhật số lượng bằng 1 để mặc định sl=1 khi chọn in tem phiếu
      list = list.map((e) => e.copyWith(quantity: 1)).toList();
    }

    checkSelectAll();
    if (res.extra != null &&
        res.extra!.isNotEmpty &&
        res.extra is List<CountV2Model>) {
      final all = res.extra!.firstWhere((element) => element.code == 'ALL');
      count = all.value ?? 0;
    }
    final bool isFirst = list.isEmpty && !isSort && _search.isEmptyOrNull;
    print(_search.isEmptyOrNull);
    emit(state.copyWith(status: BlocStatus.success, isFirst: isFirst));
  }

  Future<ProductV2Model?> checkIsExist(String code) async {
    final company = getCompany ?? -1;
    final res = await repo.products(
      company: company,
      search: code,
      page: 1,
      limit: 1000,
    );
    return res.data?.firstOrNull;
  }

  void onToggleProduct(ProductV2Model prd) {
    list = list.map((e) {
      if (e.id == prd.id) {
        return e.copyWith(isSelected: !e.isSelected);
      }
      return e;
    }).toList();
    checkSelectAll();
    emit(state.copyWith(status: BlocStatus.success));
  }

  void onTogglePrinterBarCode(bool value) {
    canSelectPrd = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  void checkSelectAll() {
    isSelectAll = list.every((prd) => prd.isSelected) && list.isNotEmpty;
  }

  bool get validSelect => list.any((prd) => prd.isSelected);
  int get quantityPrdSelect => list.where((prd) => prd.isSelected).length;

  void onToggleAllPrd(bool value) {
    list = list.map((e) {
      return e.copyWith(isSelected: value);
    }).toList();
    isSelectAll = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  void onUpdatePrd(ProductV2Model prd) {
    list = list.map((e) {
      if (e.id == prd.id) {
        return prd;
      }
      return e;
    }).toList();
    checkSelectAll();
    emit(state.copyWith(status: BlocStatus.success));
  }

  void showHide() {
    isShow = !isShow;
    emit(state.copyWith(status: BlocStatus.success));
  }
}
