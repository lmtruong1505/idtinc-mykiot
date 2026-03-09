import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';

import 'package:pharmago/presentation/features/debt/domain/entities/debt_note_entity.dart';
import 'package:pharmago/presentation/features/debt/domain/usecase/debt_report_use_case.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';

import '../../domain/usecase/debt_list_use_case.dart';
import '../debt_create_cubit/debt_create_cubit.dart';
import 'debt_list_state.dart';

@injectable
class DebtListCubit extends Cubit<DebtListState> {
  DebtListCubit(
    this._debtListUseCase,
    this._debtReportUseCase,
  ) : super(const DebtListState());

  final DebtListUseCase _debtListUseCase;
  final DebtReportUseCase _debtReportUseCase;

  final InfiniteListController<DebtNoteEntity> ilc =
      InfiniteListController<DebtNoteEntity>.init();
  final ScrollController scrollController = ScrollController();

  void init({DebtNoteType? debtType}) {
    emit(state.copyWith(debtType: debtType));
  }

  Future<List<DebtNoteEntity>> list(int page, String type) async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    if (company == null) {
      return [];
    }
    final input = DebtListInput(
      company: company,
      limit: state.limit,
      page: page + 1,
      type: type,
    );
    final res = await _debtListUseCase.execute(input);
    return res.response.data ?? [];
  }

  Future<void> report() async {
    final company = AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    if (company == null) return;
    final input = DebtReportInput(company: company, type: state.debtType?.code);
    final res = await _debtReportUseCase.execute(input);
    emit(state.copyWith(report: res.response.data));
  }
}
