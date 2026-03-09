import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/product/domain/entities/brand_entity.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';

import '../../domain/usecase/brand_list_use_case.dart';
import 'brand_list_state.dart';

@injectable
class BrandListCubit extends Cubit<BrandListState> {
  BrandListCubit(
    this._brandListUseCase,
  ) : super(const BrandListState());

  final BrandListUseCase _brandListUseCase;

  void search(String value) {
    emit(state.copyWith(search: value));
  }

  Future<List<BrandEntity>> getListBrand(int page) async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    final input = BrandListInput(
      company: company,
      search: state.search,
      page: page + 1,
      limit: state.limit,
    );
    final res = await _brandListUseCase.execute(input);
    return res.response.data ?? [];
  }
}
