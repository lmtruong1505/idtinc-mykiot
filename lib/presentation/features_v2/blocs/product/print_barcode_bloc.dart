import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/models/product/product_v2_model.dart';

class PrintBarcodeBloc extends Cubit<CubitState> {
  PrintBarcodeBloc() : super(CubitState());

  bool isPrintName = true;
  bool isPrintBarcode = true;
  bool isPrintPrice = true;
  bool isPrintUnit = true;
  bool isPrintShopName = true;
  bool isShow = false;
  List<ProductV2Model> list = [];
  void onToggleName() {
    isPrintName = !isPrintName;
    emit(state.copyWith(status: BlocStatus.reload));
  }

  void onToggleBarcode() {
    isPrintBarcode = !isPrintBarcode;
    emit(state.copyWith(status: BlocStatus.reload));
  }

  void onTogglePrice() {
    isPrintPrice = !isPrintPrice;
    emit(state.copyWith(status: BlocStatus.reload));
  }

  void onToggleUnit() {
    isPrintUnit = !isPrintUnit;
    emit(state.copyWith(status: BlocStatus.reload));
  }

  void onToggleShopName() {
    isPrintShopName = !isPrintShopName;
    emit(state.copyWith(status: BlocStatus.reload));
  }

  void showHide() {
    isShow = !isShow;
    emit(state.copyWith(status: BlocStatus.success));
  }

  void setShopName(String p0) {
    emit(state.copyWith(status: BlocStatus.success));
  }

  void onUpdatePrd(ProductV2Model prd) {
    list = list.map((e) {
      if (e.id == prd.id) {
        return prd;
      }
      return e;
    }).toList();
    emit(state.copyWith(status: BlocStatus.success));
  }

  void init(List<ProductV2Model> prds) {
    list = List.from(prds);
    emit(state.copyWith(status: BlocStatus.success));
  }
}
