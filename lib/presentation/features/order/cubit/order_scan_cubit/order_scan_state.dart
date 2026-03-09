import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../product/domain/entities/variant_entity.dart';
import '../../widgets/scan_view.dart';

part 'order_scan_state.freezed.dart';


@freezed
class OrderScanState with _$OrderScanState {
  const factory OrderScanState({
    @Default(TypeScanView.qr) TypeScanView view,
    @Default([]) List<VariantEntity> variants,
  }) = _OrderScanState;
}
