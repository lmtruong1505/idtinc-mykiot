import 'package:pharmago/shared/ext/init_ext.dart';

import '../../blocs/enum/enum_bloc.dart';

class KafaOrderModel {
  int? id;
  String? code;
  String? createdAt;
  bool? redInvoice;
  StatusOrderKafa? status;
  double? total;
  String? fullName;

  KafaOrderModel({
    this.code,
    this.createdAt,
    this.redInvoice,
    this.status,
    this.total,
    this.fullName,
    this.id,
  });

  KafaOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['order_link_id'];
    code = json['code'];
    createdAt = json['created_at'];
    redInvoice = json['is_send_red_invoice'];
    status = json['status'].toString().toStatusOrder;
    total = double.tryParse(json['total'].toString());
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_link_id'] = id;
    data['code'] = code;
    data['created_at'] = createdAt;
    data['is_send_red_invoice'] = redInvoice;
    data['status'] = status;
    data['total'] = total;
    data['full_name'] = fullName;
    return data;
  }
}
