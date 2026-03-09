import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/price_update_use_case.dart';

import 'price_update_state.dart';

@injectable
class PriceUpdateCubit extends Cubit<PriceUpdateState> {
  PriceUpdateCubit(
    this._priceUpdateUseCase,
  ) : super(const PriceUpdateState());

  final PriceUpdateUseCase _priceUpdateUseCase;

  void changePriceImport(String priceImportNew) {
    emit(state.copyWith(priceImportNew: int.parse(priceImportNew)));
  }

  void changePriceSell(String priceSellNew) {
    emit(state.copyWith(priceSellNew: int.parse(priceSellNew)));
  }

  void onTapSave(context, id) async {
    if (state.priceImportNew == 0 || state.priceSellNew == 0) {
      DialogUtils.showErrorDialog(context, content: 'Hãy nhập giá!');
      return;
    }
    DialogUtils.showLoadingDialog(context, 'Đang thêm dữ liệu, vui lòng đợi!');
    final res = await _priceUpdateUseCase.execute(
      PriceUpdateInput(id, state.priceImportNew, state.priceSellNew),
    );
    Navigator.of(context).pop();
    if (res.response.code == 200) {
      await DialogUtils.showSuccessDialog(context,
          content: 'Sửa giá thành công!', barrierDismissible: true,);
      Navigator.of(context).pop(res.response.data);
    } else {
      DialogUtils.showErrorDialog(context,
          content: res.response.message ?? 'Sửa giá thất bại');
    }
  }
}
