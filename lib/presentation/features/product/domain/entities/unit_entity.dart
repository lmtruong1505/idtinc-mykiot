import 'package:freezed_annotation/freezed_annotation.dart';
part 'unit_entity.freezed.dart';

@freezed
class UnitEntity with _$UnitEntity {
  const UnitEntity._();

  const factory UnitEntity({
    int? id,
    @JsonKey(name: 'price_sell') // old be
    double? priceSell,
    @JsonKey(name: 'price_import') // old be
    double? priceImport,
    @Default(1) int value,
    String? name,
    @JsonKey(name: 'default')
    @Default(false) bool isDefault,
    List<UnitConversionEntity>? conversions,
    @JsonKey(name: 'sell_price')
    double? sellPrice,
    @JsonKey(name: 'import_price')
    double? importPrice,
    double? weight,
    String? weightUnit,
    int? level,
  }) = _UnitEntity;
}


@freezed
class UnitConversionEntity with _$UnitConversionEntity {
  const UnitConversionEntity._();

  const factory UnitConversionEntity({
    int? id,
    double? priceSell,
    double? priceImport,
    String? title,
    int? times,
    int? unit,
    @Default(0) int quantityAction,
  }) = _UnitConversionEntity;
}