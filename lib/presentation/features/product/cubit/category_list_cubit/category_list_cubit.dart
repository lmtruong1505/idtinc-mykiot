import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/product/domain/entities/category_entity.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/category_list_use_case.dart';

import '../../../../../shared/constants/pref_key.dart';
import '../../../../../shared/constants/storage/shared_preference.dart';
import 'category_list_state.dart';

@injectable
class CategoryListCubit extends Cubit<CategoryListState> {
  CategoryListCubit(
    this._categoryListUseCase,
  ) : super(const CategoryListState());

  final CategoryListUseCase _categoryListUseCase;

  void search(String value) {
    emit(state.copyWith(search: value));
  }

  Future<List<CategoryEntity>> getList(int page) async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    final input = CategoryListInput(
      company: company,
      search: state.search,
      page: page + 1,
      limit: state.limit,
    );
    final res = await _categoryListUseCase.execute(input);
    return res.response.data ?? [];
  }
}
