import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/prepare/domain/entities/prepare_entity.dart';

part 'prepare_state.freezed.dart';

@freezed
class PrepareState with _$PrepareState {
  const factory PrepareState({
    @Default('') String search,
    @Default(0) int total,
    @Default(PrepareEntity()) PrepareEntity item,
  }) = _PrepareState;
}
