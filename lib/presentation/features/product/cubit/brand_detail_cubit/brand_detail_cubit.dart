import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/brand_delete_use_case.dart';

import '../../domain/usecase/brand_detail_use_case.dart';
import 'brand_detail_state.dart';

@injectable
class BrandDetailCubit extends Cubit<BrandDetailState> {
  BrandDetailCubit(
    this._brandDetailUseCase,
    this._brandDeleteUseCase,
  ) : super(const BrandDetailState());

  final BrandDetailUseCase _brandDetailUseCase;
  final BrandDeleteUseCase _brandDeleteUseCase;

  void init(int id) {
    _getDetail(id);
  }

  Future<void> _getDetail(int id) async {
    final input = BrandDetailInput(id: id);
    final res = await _brandDetailUseCase.execute(input);
    emit(state.copyWith(brand: res.response.data));
  }

  Future<BaseResponseModel> delete(int id) async {
    final input = BrandDeleteInput(id: id);
    final res = await _brandDeleteUseCase.execute(input);
    return res.response;
  }
}
