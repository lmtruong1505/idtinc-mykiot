
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_preview_model.freezed.dart';
part 'order_preview_model.g.dart';

@freezed
class OrderPreviewModel with _$OrderPreviewModel {
  const OrderPreviewModel._();

  const factory OrderPreviewModel({
    int? id,
    String? code,
    @JsonKey(name: 'total_price') double? totalPrice,
    String? status,
    @JsonKey(name: 'customer_name') String? customerName,
    @JsonKey(name: 'user_created') String? userCreated,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    String? type,
    @JsonKey(name: 'total_paid')
    double? totalPaid,
  }) = _OrderPreviewModel;

  factory OrderPreviewModel.fromJson(Map<String, dynamic> json) => _$OrderPreviewModelFromJson(json);
}


class PaymenOrder {
  int? id;
  String? code;
  int? mustPaid;
  int? needPay;

  PaymenOrder({this.id, this.code, this.mustPaid, this.needPay});

  PaymenOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    mustPaid = json['must_paid'];
    needPay = json['need_pay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['must_paid'] = this.mustPaid;
    data['need_pay'] = this.needPay;
    return data;
  }
}
