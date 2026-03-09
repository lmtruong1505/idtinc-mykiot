class SettingPointEntity {
    final bool isApplyProductPoint;
    final bool isApplyOrderPoint;
    final int orderExchangeMoney;
    final int orderExchangePoint;
    final bool isApplyPaymentPoint;
    final int paymentExchangeMoney;
    final int paymentExchangePoint;

    SettingPointEntity({
        this.isApplyProductPoint = false,
        this.isApplyOrderPoint = false,
        this.orderExchangeMoney = 0,
        this.orderExchangePoint = 0,
        this.isApplyPaymentPoint = false,
        this.paymentExchangeMoney = 0,
        this.paymentExchangePoint = 0,
    });

    SettingPointEntity copyWith({
        bool? isApplyProductPoint,
        bool? isApplyOrderPoint,
        int? orderExchangeMoney,
        int? orderExchangePoint,
        bool? isApplyPaymentPoint,
        int? paymentExchangeMoney,
        int? paymentExchangePoint,
    }) => 
        SettingPointEntity(
            isApplyProductPoint: isApplyProductPoint ?? this.isApplyProductPoint,
            isApplyOrderPoint: isApplyOrderPoint ?? this.isApplyOrderPoint,
            orderExchangeMoney: orderExchangeMoney ?? this.orderExchangeMoney,
            orderExchangePoint: orderExchangePoint ?? this.orderExchangePoint,
            isApplyPaymentPoint: isApplyPaymentPoint ?? this.isApplyPaymentPoint,
            paymentExchangeMoney: paymentExchangeMoney ?? this.paymentExchangeMoney,
            paymentExchangePoint: paymentExchangePoint ?? this.paymentExchangePoint,
        );

    Map<String, dynamic> toJson() => {
        'is_apply_product_point': isApplyProductPoint,
        'is_apply_order_point': isApplyOrderPoint,
        'order_exchange_money': orderExchangeMoney,
        'order_exchange_point': orderExchangePoint,
        'is_apply_payment_point': isApplyPaymentPoint,
        'payment_exchange_money': paymentExchangeMoney,
        'payment_exchange_point': paymentExchangePoint,
    };
}
