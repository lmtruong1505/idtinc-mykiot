import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/product/domain/entities/product_entity.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/brand_create_use_case.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';

import 'brand_create_state.dart';

@injectable
class BrandCreateCubit extends Cubit<BrandCreateState> {
  BrandCreateCubit(this._brandCreateUseCase) : super(const BrandCreateState());

  final BrandCreateUseCase _brandCreateUseCase;

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
    final input = BrandCreateInput(
      company: company,
      name: state.name,
      code: state.code,
      description: state.note,
      products: state.products.map((e) => e.id ?? 0).toList(),
    );
    final res = await _brandCreateUseCase.execute(input);
    return res.response;
  }
}
