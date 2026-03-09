import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/batch_entity.dart';

import 'batch_create_state.dart';

@injectable
class BatchCreateCubit extends Cubit<BatchCreateState> {
  BatchCreateCubit() : super(const BatchCreateState());

  void init(List<BatchEntity> batchs) {
    emit(state.copyWith(list: batchs));
  }

  void changeCode(int index, String code) {
    final list = List<BatchEntity>.from(state.list);
    list[index] = list[index].copyWith(code: code);
    emit(state.copyWith(list: list));
  }

  void changeExpiry(int index, DateTime expiry) {
    final list = List<BatchEntity>.from(state.list);
    list[index] = list[index].copyWith(expiry: expiry);
    emit(state.copyWith(list: list));
  }

  void changeProductionDate(int index, DateTime productionDate) {
    final list = List<BatchEntity>.from(state.list);
    list[index] = list[index].copyWith(productionDate: productionDate);
    emit(state.copyWith(list: list));
  }

  void changeAmount(int index, String amount) {
    final list = List<BatchEntity>.from(state.list);
    list[index] = list[index].copyWith(amount: amount.replaceAll('.', ''));
    emit(state.copyWith(list: list));
  }

  void addBatch() {
    final list = List<BatchEntity>.from(state.list);
    list.add(const BatchEntity());
    emit(state.copyWith(list: list));
  }

  void removeBatch(BatchEntity item) {
    final list = List<BatchEntity>.from(state.list);
    list.remove(item);
    emit(state.copyWith(list: list));
  }

  void onTapConfirm(context) async {
    Navigator.of(context).pop(state.list);
  }
}
