import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features_v2/blocs/shopping_cart/drug_cart_bloc.dart';
import 'package:pharmago/presentation/features_v2/models/variant_kafa/variant_kafa_model.dart';
import 'package:pharmago/presentation/features_v2/screens/product/components/bts_filter_prod.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/utils/delay_callback.dart';
import '../../repositories/wholesale_drug/wholesale_drug_repo.dart';
import '../enum/bloc_status.dart';
import '../state/cubit_state.dart';

enum DrugPrdV2Type {
  propose(title: 'Đề xuất', code: null),
  bestSeller(title: 'Bán chạy', code: '-count_quantity'),
  promotion(title: 'Khuyến mãi', code: 'promotion__isnull'),
  news(title: 'Mới nhất', code: '-id'),
  price(title: 'Giá', icon: 'e60d', code: '-price_sell');

  final String title;
  final String? code;
  final String? icon;

  const DrugPrdV2Type({
    required this.title,
    this.icon,
    this.code,
  });
}

@injectable
class WholesaleDrugMarketV2Bloc extends Cubit<CubitState> {
  WholesaleDrugMarketV2Bloc(this.repo, this.cartBloc) : super(CubitState());

  final WholesaleDrugRepo repo;
  final DrugCartBloc cartBloc;

  DrugPrdV2Type? _type = DrugPrdV2Type.propose;
  DrugPrdV2Type? get type => _type;

  DrugPrdV2Type? _orderBy;
  DrugPrdV2Type? get orderBy => _orderBy;

  bool _isPromotion = false;
  final listTab = [
    DrugPrdV2Type.propose,
    DrugPrdV2Type.bestSeller,
    DrugPrdV2Type.promotion,
    DrugPrdV2Type.news,
    DrugPrdV2Type.price,
  ];

  final _delay = DelayCallBack(delay: 500.milliseconds);
  List<VariantKafaPreviewModel> list = [];
  String? _search;
  int _page = 1;
  bool isMore = true;
  bool get showBanner => _search.isEmptyOrNull;
  final limit = 20;
  void setType({DrugPrdV2Type? value}) {
    if (_type != value) {
      if (value == DrugPrdV2Type.bestSeller ||
          value == DrugPrdV2Type.news ||
          value == DrugPrdV2Type.price) {
        _orderBy = value;
        _isPromotion = false;
        getList();
      } else if (value == DrugPrdV2Type.promotion) {
        _orderBy = null;
        _isPromotion = true;
        getList();
      }
    }

    // if (_type != value && value != null) {
    //   _type = value;
    //   getList();
    // } else if (_orderBy != orderBy && orderBy != null) {
    //   _orderBy = orderBy;
    //   getList();
    // }
  }

  void changeSearch(String? value) {
    _search = value;
    _delay.debounce(
      () => getList(),
    );
  }

  void getList({
    bool getMore = false,
  }) async {
    if (getMore) {
      emit(state.copyWith(status: BlocStatus.loadList));
      _page++;
    } else {
      emit(state.copyWith(status: BlocStatus.loading));
      _page = 1;
      list.clear();
    }
    final res = await repo.getVariants(
      search: _search,
      page: _page,
      limit: limit,
      sort: _type?.code,
      maxPrice: _price?.maxVal,
      minPrice: _price?.minVal,
      category: _category,
      group: _group,
      brand: _brand,
      customer: _customer,
      services: _services,
      orderBy: _orderBy?.code,
      isPromotion: _isPromotion,
    );

    list.addAll(res.data ?? []);
    (res.data?.length ?? 0) == limit ? isMore = true : isMore = false;
    emit(state.copyWith(status: BlocStatus.success));
  }

  void onUpdate(int id, int quantity) {
    list = list.map(
      (prd) {
        if (prd.id == id) {
          prd = prd.copyWith(quantity: quantity);
        }
        return prd;
      },
    ).toList();
    emit(state.copyWith(status: BlocStatus.success));
  }

  RangePrice? _price = RangePrice.all;
  RangePrice? get price => _price;

  int? _typeV2;
  int? get typeV2 => _typeV2;

  int? _category;
  int? get category => _category;

  int? _brand;
  int? get brand => _brand;

  int? _customer;
  int? get customer => _customer;

  List<int>? _services;
  List<int>? get services => _services;

  int? _group;
  int? get group => _group;

  void changeFilter({
    bool? active,
    RangePrice? price,
    int? category,
    int? group,
    int? brand,
    int? customer,
    List<int>? services,
  }) {
    // _active = active;
    _price = price;
    _category = category;
    _typeV2 = typeV2;
    _brand = brand;
    _services = services;
    _customer = customer;
    _group = group;
    getList();
  }
}
