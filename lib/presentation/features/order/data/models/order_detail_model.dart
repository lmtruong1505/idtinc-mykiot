import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/order/data/models/payment_v2_model.dart';
import '../../../customer/data/models/customer_model.dart';
import '../../../product/data/models/unit_model.dart';

part 'order_detail_model.freezed.dart';
part 'order_detail_model.g.dart';

@freezed
class OrderDetailModel with _$OrderDetailModel {
  const OrderDetailModel._();

  const factory OrderDetailModel({
    int? id,
    String? code,
    @JsonKey(name: 'created_at')
    DateTime? createdAt,
    @JsonKey(name: 'role_name')
    String? roleName,
    @JsonKey(name: 'total_paid')
    double? totalPaid,
    String? type,
    @JsonKey(name: 'is_send_red_invoice')
    bool? redInvoice,
    String? description,
    @JsonKey(name: 'user_created')
    String? userCreated,
    CustomerModel? customer,
    @Default([]) List<ItemOrderDetailModel> items,
    @JsonKey(name: 'total_price')
    double? totalPrice,
    @JsonKey(name: 'qr_code')
    String? qrCode,
    @Default([]) List<PaymentV2Model> payments,
  }) = _OrderDetailModel;

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailModelFromJson(json);
}

@freezed
class ItemOrderDetailModel with _$ItemOrderDetailModel{
  const ItemOrderDetailModel._();

  const factory ItemOrderDetailModel({
    String? title,
    String? name,
    @JsonKey(name: 'total_price')
    double? totalPrice,
    double? discount,
    @JsonKey(name: 'unit_price')
    double? unitPrice,
    int? quantity,
    @JsonKey(name: 'item_id')
    int? itemId,
    @Default([]) List<UnitModel> units,
  }) = _ItemOrderDetailModel;

  factory ItemOrderDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ItemOrderDetailModelFromJson(json);
}
