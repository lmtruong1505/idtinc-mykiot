import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/product_delete_use_case.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/product_detail_use_case.dart';

import '../../../../../data/models/base/response.dart';
import 'product_detail_state.dart';

@injectable
class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit(
    this._productDetailUseCase,
    this._productDeleteUseCase,
  ) : super(const ProductDetailState());

  final ProductDetailUseCase _productDetailUseCase;
  final ProductDeleteUseCase _productDeleteUseCase;

  void indexImageChange(int index) {
    emit(state.copyWith(imageIndex: index));
  }

  Future<void> getDetail(int id) async {
    emit(state.copyWith(isLoading: true));
    final input = ProductDetailInput(id: id);
    final res = await _productDetailUseCase.execute(input);
    emit(
      state.copyWith(
        productDetail: res.response.data,
        product: res.response.data?.product,
        variants: res.response.data?.variants ?? [],
        units: res.response.data?.units ?? [],
        ingredients: res.response.data?.ingredients ?? [],
        isLoading: false,
      ),
    );
  }

  Future<BaseResponseModel> delete(int id) async {
    final input = ProductDeleteInput(id: id);
    final res = await _productDeleteUseCase.execute(input);
    return res.response;
  }
}
