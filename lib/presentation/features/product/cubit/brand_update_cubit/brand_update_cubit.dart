import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/brand_update_use_case.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/product_list_use_case.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/usecase/brand_detail_use_case.dart';
import 'brand_update_state.dart';

@injectable
class BrandUpdateCubit extends Cubit<BrandUpdateState> {
  BrandUpdateCubit(
    this._brandDetailUseCase,
    this._productListUseCase,
    this._brandUpdateUseCase,
  ) : super(const BrandUpdateState());

  final BrandDetailUseCase _brandDetailUseCase;
  final ProductListUseCase _productListUseCase;
  final BrandUpdateUseCase _brandUpdateUseCase;

  void infoChange({
    String? code,
    String? name,
    String? note,
  }) {
    final brand = state.brand?.copyWith(
      code: code,
      name: name,
      description: note,
    );
    emit(state.copyWith(brand: brand));
  }

  void productSelect(List<ProductEntity> value) {
    emit(state.copyWith(products: value));
  }

  void productRemove(ProductEntity value) {
    final list = List<ProductEntity>.from(state.products);
    list.removeWhere((e) => e.id == value.id);
    emit(state.copyWith(products: list));
  }

  Future<void> getDetail(int id) async {
    emit(state.copyWith(isLoading: true));
    final input = BrandDetailInput(id: id);
    final res = await _brandDetailUseCase.execute(input);
    emit(
      state.copyWith(
        brand: res.response.data,
        isLoading: false,
      ),
    );
    _getProducts();
  }

  Future<void> _getProducts() async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    final input = ProductListInput(
      search: '',
      limit: 10,
      page: 1,
      company: company,
      brand: state.brand?.id,
    );
    final res = await _productListUseCase.execute(input);
    emit(state.copyWith(products: res.response.data ?? []));
  }

  Future<BaseResponseModel?> update() async {
    final input = BrandUpdateInput(
      id: state.brand?.id ?? 0,
      name: state.brand?.name ?? '',
      code: state.brand?.code ?? '',
      description: state.brand?.description ?? '',
      products: state.products.map((e) => e.id!).toList(),
    );
    final res = await _brandUpdateUseCase.execute(input);
    if (res.response.code != 200) return null;
    return res.response;
  }
}
