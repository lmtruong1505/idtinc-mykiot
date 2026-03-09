import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features_v2/blocs/product/product_manager_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/repositories/product/product_v2_repository.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/utils/delay_callback.dart';
import '../../../shared/utils/get.dart';
import '../../models/product/count_v2_model.dart';
import '../../models/product/product_v2_model.dart';
import '../../screens/product/components/bts_filter_prod.dart';
import '../enum/bloc_status.dart';

@injectable
class KafaCloneProductBloc extends Cubit<CubitState> {
  KafaCloneProductBloc() : super(CubitState());

  final repo = ProductV2Repository();
  final _delay = DelayCallBack(delay: 500.milliseconds);

  int count = 0;
  bool? isClonePrd = false;
  bool? isSelectAll = false;
  bool isCloneSuccess = false;
  bool isShow = false;
  List<ProductV2Model> list = [];
  List<ProductV2Model> listSelect = [];
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
    final res = await repo.productsKafa(
      company: company,
      page: _page,
      search: search,
      category: _category,
    );
    final listOldSelect = list.where((element) => element.isSelected);
    if (isClonePrd == true &&
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

  void init(bool? value) {
    isClonePrd = value;
  }

  void showHide() {
    isShow = !isShow;
    emit(state.copyWith(status: BlocStatus.success));
  }

  void hideSelectPrds() {
    isShow = false;
    emit(state.copyWith(status: BlocStatus.success));
  }

  void checkSelectAll() {
    isSelectAll = list.every((prd) => prd.isSelected) && list.isNotEmpty;
  }

  bool get validSelect => listSelect.any((prd) => (prd.quantity ?? 0) > 0);
  int get quantityPrdSelect =>
      listSelect.where((prd) => (prd.quantity ?? 0) > 0).length;
  void clonePrds() async {
    emit(state.copyWith(status: BlocStatus.submit));
    // final ids =
    //     list.where((prd) => prd.isSelected).map((e) => e.id ?? 0).toList();
    final res = await repo.clonePrds(listSelect, getCompanyId ?? 0);
    if (res.code == 200) {
      list.removeWhere((element) => (element.quantity ?? 0) > 0);
      listSelect.clear();
      isCloneSuccess = true;
      // getIt.get<ProductManagerBloc>().getList();
      emit(state.copyWith(status: BlocStatus.submitSuccess));
    } else {
      emit(state.copyWith(status: BlocStatus.submitFailure, msg: res.message));
    }
  }

  // void onToggleAllPrd(bool value) {
  //   list = list.map((e) {
  //     return e.copyWith(isSelected: value);
  //   }).toList();
  //   isSelectAll = value;
  //   emit(state.copyWith(status: BlocStatus.success));
  // }

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

  void onUpdatePrd(ProductV2Model value) {
    list = list.map((e) {
      if (e.id == value.id) {
        return value;
      }
      return e;
    }).toList();
    listSelect = list.where((prd) => (prd.quantity ?? 0) > 0).toList();
    emit(state.copyWith(status: BlocStatus.success));
  }
}
