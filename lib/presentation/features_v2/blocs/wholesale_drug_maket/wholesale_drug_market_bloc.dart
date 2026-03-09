import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features_v2/models/variant_kafa/variant_kafa_model.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../shared/utils/delay_callback.dart';
import '../../../di/di.dart';
import '../../repositories/wholesale_drug/wholesale_drug_repo.dart';
import '../enum/bloc_status.dart';
import '../state/cubit_state.dart';

enum TypePrdKafa {
  hot('Bán chạy', '/ic_hot.svg', '-best_seller'),
  news('Mới nhất', '/ic_news_prd.svg', '-created_at');

  final String title;
  final String icon;
  final String code;
  const TypePrdKafa(
    this.title,
    this.icon,
    this.code,
  );
}

@injectable
class WholesaleDrugMarketBloc extends Cubit<CubitState> {
  WholesaleDrugMarketBloc(this.repo) : super(CubitState());
  final WholesaleDrugRepo repo;

  TypePrdKafa? _type = TypePrdKafa.hot;
  TypePrdKafa? get type => _type;
  setType(TypePrdKafa value) {
    if (_type == value) {
      _type = null;
    } else {
      _type = value;
    }

    getList();
  }

  bool _showSearch = false;
  bool get showSearch => _showSearch;

  setShowSearch(bool value) {
    _showSearch = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  final _delay = DelayCallBack(delay: 500.milliseconds);
  final List<VariantKafaPreviewModel> list = [];
  String? _search;

  changeSearch(String? value) {
    _search = value;
    _delay.debounce(
      () => getList(),
    );
  }

  int _page = 1;

  getList({
    bool isMore = false,
  }) async {
    if (isMore) {
      _page++;
    } else {
      _page = 1;
      list.clear();
    }
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await repo.getVariants(
      search: _search,
      page: _page,
      limit: 16,
      sort: _type?.code,
    );
    list.addAll(res.data ?? []);
    emit(state.copyWith(status: BlocStatus.success));
  }
}
