class PreviewOrderModel {
  int? id;
  DateTime? createdAt;
  String? code;
  double? totalPrice;
  String? userCreated;
  String? customerName;
  String? redInvoiceStatus;
  String? type;
  double? paymentHistory;
  bool? isSelect = false;

  PreviewOrderModel({
    this.id,
    this.createdAt,
    this.code,
    this.totalPrice,
    this.userCreated,
    this.customerName,
    this.type,
    this.paymentHistory,
    this.isSelect,
    this.redInvoiceStatus,
  });

  PreviewOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'] != null
        ? DateTime.tryParse(json['created_at'])
        : null;
    code = json['code'];
    redInvoiceStatus = json['red_invoice_status'];
    totalPrice = json['total_price'];
    userCreated = json['user_created'];
    customerName = json['customer_name'];
    type = json['type'];
    paymentHistory = json['payment_history'];
    isSelect = json['isSelect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['code'] = code;
    data['total_price'] = totalPrice;
    data['user_created'] = userCreated;
    data['customer_name'] = customerName;
    data['type'] = type;
    data['payment_history'] = paymentHistory;
    data['isSelect'] = isSelect;
    data['red_invoice_status'] = redInvoiceStatus;
    return data;
  }

  PreviewOrderModel copyWith({
    int? id,
    DateTime? createdAt,
    String? code,
    double? totalPrice,
    String? userCreated,
    String? customerName,
    String? type,
    double? paymentHistory,
    bool? isSelect,
    String? redInvoiceStatus,
  }) {
    return PreviewOrderModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      code: code ?? this.code,
      totalPrice: totalPrice ?? this.totalPrice,
      userCreated: userCreated ?? this.userCreated,
      customerName: customerName ?? this.customerName,
      type: type ?? this.type,
      paymentHistory: paymentHistory ?? this.paymentHistory,
      isSelect: isSelect ?? this.isSelect,
      redInvoiceStatus: redInvoiceStatus ?? this.redInvoiceStatus,
    );
  }
}
