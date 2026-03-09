import 'package:bloc/bloc.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/variant_list_use_case.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/utils/delay_callback.dart';
import '../../../../di/di.dart';
import '../../../../features_v2/blocs/enum/bloc_status.dart';
import '../../../product/domain/entities/variant_entity.dart';

class VariantChoosenBloc extends Cubit<CubitState> {
  VariantChoosenBloc() : super(CubitState());

  List<VariantEntity> list = [];
  String? _search;
  final _delay = DelayCallBack(delay: 500.milliseconds);
  final _variantGetListUseCase = getIt.get<VariantListUseCase>();

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
    if(isMore) {
      _page++;
    } else {
      _page = 1;
      list.clear();
    }
    emit(state.copyWith(status: BlocStatus.loading));
    final company = getCompany;
    final input = VariantListInput(
      page: _page,
      limit: 10,
      search: _search ?? '', company: company ?? -1,
    );
    final res = await _variantGetListUseCase.execute(input);
    list.addAll(res.response.data ?? []);
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<VariantEntity?> getProdByCode(String barcode) async {
    final company = getCompany;
    final input = VariantListInput(
      page: 1,
      limit: 10,
      search: barcode, company: company ?? -1,
    );
    final res = await _variantGetListUseCase.execute(input);
    list = res.response.data ?? [];
    return list.firstOrNull;
  }

}