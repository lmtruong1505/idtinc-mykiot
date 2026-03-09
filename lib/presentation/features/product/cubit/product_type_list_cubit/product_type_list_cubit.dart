import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/product/domain/entities/product_type_entity.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/product_type_list_use_case.dart';

import '../../../../../shared/constants/pref_key.dart';
import '../../../../../shared/constants/storage/shared_preference.dart';
import 'product_type_list_state.dart';

@injectable
class ProductTypeListCubit extends Cubit<ProductTypeListState> {
  ProductTypeListCubit(
    this._productTypeListUseCase,
  ) : super(const ProductTypeListState());

  final ProductTypeListUseCase _productTypeListUseCase;

  void search(String value) {
    emit(state.copyWith(search: value));
  }

  Future<List<ProductTypeEntity>> getListProductType(int page) async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    final input = ProductTypeListInput(
      company: company,
      search: state.search,
      page: page + 1,
      limit: state.limit,
    );
    final res = await _productTypeListUseCase.execute(input);
    return res.response.data ?? [];
  }
}
