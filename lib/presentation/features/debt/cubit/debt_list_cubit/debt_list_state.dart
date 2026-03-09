import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/debt_report_entity.dart';
import '../debt_create_cubit/debt_create_cubit.dart';
part 'debt_list_state.freezed.dart';

@freezed
class DebtListState with _$DebtListState {
  const factory DebtListState({
    @Default(10) int limit,
    DebtReportEntity? report,
    DebtNoteType? debtType
  }) = _DebtListState;
}
