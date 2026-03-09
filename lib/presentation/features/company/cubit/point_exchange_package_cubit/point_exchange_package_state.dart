import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../features_v2/models/product/product_v2_model.dart';

part 'point_exchange_package_state.freezed.dart';

@freezed
class PointExchangePackageState with _$PointExchangePackageState {
  const factory PointExchangePackageState({
    @Default('') String name,
    @Default(0) int point,
    @Default('') String note,
    @Default([]) List<ProductV2Model> products,
  }) = _PointExchangePackageState;
}
