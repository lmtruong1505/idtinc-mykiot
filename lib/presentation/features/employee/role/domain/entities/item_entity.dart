import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_entity.freezed.dart';

@freezed
class ItemEntity with _$ItemEntity {
  const ItemEntity._();

  const factory ItemEntity({
    @Default('') String title,
    @Default('') String code,
    @Default(false) bool checked,
    @Default([]) List<ItemEntity> items,
  }) = _ItemEntity;
}
