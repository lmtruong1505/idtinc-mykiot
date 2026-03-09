import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../shared/constants/pref_key.dart';
import '../../../../../shared/constants/storage/shared_preference.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecase/category_create_use_case.dart';

part 'category_create_state.dart';
part 'category_create_cubit.freezed.dart';

@injectable
class CategoryCreateCubit extends Cubit<CategoryCreateState> {
  CategoryCreateCubit(this._categoryCreateUseCase) : super(const CategoryCreateState());

  final CategoryCreateUseCase _categoryCreateUseCase;

  void productSelect(List<ProductEntity> value) {
    emit(state.copyWith(products: value));
  }

  void productRemove(ProductEntity value) {
    final list = List<ProductEntity>.from(state.products);
    list.removeWhere((e) => e.id == value.id);
    emit(state.copyWith(products: list));
  }

  void infoChange({
    String? code,
    String? name,
    String? note,
  }) {
    emit(
      state.copyWith(
        code: code ?? state.code,
        name: name ?? state.name,
        note: note ?? state.note,
      ),
    );
  }

  Future<BaseResponseModel<int>?> create() async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    if (company == null) {
      return null;
    }
    final input = CategoryCreateInput(
      company: company,
      name: state.name,
      code: state.code,
      description: state.note,
      products: state.products.map((e) => e.id ?? 0).toList(),
    );
    final res = await _categoryCreateUseCase.execute(input);
    return res.response;
  }
}
