import 'package:freezed_annotation/freezed_annotation.dart';

part 'batch_entity.freezed.dart';

@freezed
class BatchEntity with _$BatchEntity {
  const BatchEntity._();

  const factory BatchEntity({
    int? id,
    @Default('') String code,
    DateTime? expiry,
    DateTime? productionDate,
    @Default('') String amount,
    @Default(0) int variantId,
  }) = _BatchEntity;
}
