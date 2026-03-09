import 'package:freezed_annotation/freezed_annotation.dart';
part 'order_preview_entity.freezed.dart';

@freezed
class OrderPreviewEntity with _$OrderPreviewEntity {
  const OrderPreviewEntity._();

  const factory OrderPreviewEntity({
    int? id,
    String? code,
    @JsonKey(name: 'total_price') double? totalPrice,
    String? status,
    @JsonKey(name: 'customer_name') String? customerName,
    @JsonKey(name: 'user_created') String? userCreated,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    String? type,
    double? totalPaid,
  }) = _OrderPreviewEntity;

}



