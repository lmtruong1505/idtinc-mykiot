import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/debt/cubit/debt_create_cubit/debt_create_cubit.dart';
import 'package:pharmago/presentation/features/product/domain/entities/basic_entity.dart';

part 'debt_create_state.freezed.dart';

@freezed
class DebtCreateState with _$DebtCreateState {
  const factory DebtCreateState({
    @Default('') String title,
    @Default('') String code,
    @Default('') String totalMoney,
    @Default('') String paymented,
    @Default('') String note,
    @Default(null) DateTime? debitDate,
    @Default(null) DateTime? expriseDate,
    @Default([]) List<BasicEntity> suggestEntity,
    @Default(null) BasicEntity? entitySelected,
    @Default(DebtNoteType.EXPENSE) DebtNoteType? debtType,
  }) = _DebtCreateState;
}
