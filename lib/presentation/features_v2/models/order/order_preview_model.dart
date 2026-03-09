

import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_preview_model.freezed.dart';
part 'order_preview_model.g.dart';

@freezed
class OrderPreviewV2Model with _$OrderPreviewV2Model {
  const OrderPreviewV2Model._();

  const factory OrderPreviewV2Model({
    int? id,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    String? code,
    @JsonKey(name: 'total_price') double? totalPrice,
    @JsonKey(name: 'user_created') String? userCreated,
    @JsonKey(name: 'customer_name') String? customerName,
    String? type,
    @JsonKey(name: 'payment_history') double? paymentHistory,
  }) = _OrderPreviewV2Model;

  factory OrderPreviewV2Model.fromJson(Map<String, dynamic> json) => _$OrderPreviewV2ModelFromJson(json);
}