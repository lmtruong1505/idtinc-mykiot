import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/debt/domain/entities/debt_note_entity.dart';
part 'debt_detail_state.freezed.dart';

@freezed
class DebtDetailState with _$DebtDetailState {
  const factory DebtDetailState({
    @Default(null) DebtNoteEntity? debtNoteData,
    @Default(true) bool isLoading,
  }) = _DebtDetailState;
}
