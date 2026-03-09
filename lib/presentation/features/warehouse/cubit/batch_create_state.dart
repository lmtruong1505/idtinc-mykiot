import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/batch_entity.dart';

part 'batch_create_state.freezed.dart';

@freezed
class BatchCreateState with _$BatchCreateState {
  const factory BatchCreateState({
    @Default([]) List<BatchEntity> list,
  }) = _BatchCreateState;
}
