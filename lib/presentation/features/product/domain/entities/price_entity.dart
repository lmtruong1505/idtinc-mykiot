import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_entity.freezed.dart';

@freezed
class PriceEntity with _$PriceEntity {
  const PriceEntity._();

  const factory PriceEntity({
    int? id,
    String? code,
    String? name,
    int? priceImport,
    int? priceSell,
    int? unit,
    String? unitName,
    String? image,
  }) = _PriceEntity;
}
