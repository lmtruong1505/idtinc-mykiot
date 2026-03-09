import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/medical_record_entity.dart';
import 'package:pharmago/presentation/features/customer/domain/usecase/medical_record_list_use_case.dart';

import '../../../../base/infinite_list.dart';
import 'medical_record_state.dart';

@injectable
class MedicalRecordCubit extends Cubit<MedicalRecordState> {
  MedicalRecordCubit(
    this._medicalRecordListUseCase,
  ) : super(const MedicalRecordState());

  final MedicalRecordListUseCase _medicalRecordListUseCase;
  final ScrollController scrollController = ScrollController();
  final InfiniteListController<MedicalRecordEntity> medicalRecordsILC =
      InfiniteListController<MedicalRecordEntity>.init();

  void init({int? id}) {
    emit(state.copyWith(id: id ?? state.id));
  }

  Future<List<MedicalRecordEntity>> list(int page) async {
    if (state.id == null) return [];
    final input = MedicalRecordListInput(
      customer: state.id!,
      page: page + 1,
      limit: 20,
      search: state.search,
    );
    final res = await _medicalRecordListUseCase.execute(input);
    return res.response.data ?? [];
  }
}
