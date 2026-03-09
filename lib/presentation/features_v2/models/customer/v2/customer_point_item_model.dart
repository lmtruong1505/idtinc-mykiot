class CustomerPointItemModel {
    final int? id;
    final int? customerId;
    final num? point;
    final int? orderId;
    final int? workspaceId;
    final dynamic userCreatedId;
    final DateTime? createdAt;
    final OrderData? orderData;
    final String? type;
    final num? moneyExchange;

    CustomerPointItemModel({
        this.id,
        this.customerId,
        this.point,
        this.orderId,
        this.workspaceId,
        this.userCreatedId,
        this.createdAt,
        this.orderData,
        this.type,
        this.moneyExchange,
    });

    CustomerPointItemModel copyWith({
        int? id,
        int? customerId,
        num? point,
        int? orderId,
        int? workspaceId,
        dynamic userCreatedId,
        DateTime? createdAt,
        OrderData? orderData,
        String? type,
        num? moneyExchange,
    }) => 
        CustomerPointItemModel(
            id: id ?? this.id,
            customerId: customerId ?? this.customerId,
            point: point ?? this.point,
            orderId: orderId ?? this.orderId,
            workspaceId: workspaceId ?? this.workspaceId,
            userCreatedId: userCreatedId ?? this.userCreatedId,
            createdAt: createdAt ?? this.createdAt,
            orderData: orderData ?? this.orderData,
            type: type ?? this.type,
            moneyExchange: moneyExchange ?? this.moneyExchange,
        );

    factory CustomerPointItemModel.fromJson(Map<String, dynamic> json) => CustomerPointItemModel(
        id: json['id'],
        customerId: json['customer_id'],
        point: json['point'],
        orderId: json['order_id'],
        workspaceId: json['workspace_id'],
        userCreatedId: json['user_created_id'],
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        orderData: json['order_data'] == null ? null : OrderData.fromJson(json['order_data']),
        type: json['type'],
        moneyExchange: json['money_exchange'],
    );

    Map<String, dynamic> toJson() => {
        'id': id,
        'customer_id': customerId,
        'point': point,
        'order_id': orderId,
        'workspace_id': workspaceId,
        'user_created_id': userCreatedId,
        'created_at': createdAt?.toIso8601String(),
        'order_data': orderData?.toJson(),
        'type': type,
        'money_exchange': moneyExchange,
    };
}

class OrderData {
    final int? id;
    final String? code;
    final num? totalAmount;

    OrderData({
        this.id,
        this.code,
        this.totalAmount,
    });

    OrderData copyWith({
        int? id,
        String? code,
        num? totalAmount,
    }) => 
        OrderData(
            id: id ?? this.id,
            code: code ?? this.code,
            totalAmount: totalAmount ?? this.totalAmount,
        );

    factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
        id: json['id'],
        code: json['code'],
        totalAmount: json['total_amount'],
    );

    Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'total_amount': totalAmount,
    };
}
