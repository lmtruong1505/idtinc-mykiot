import '../../domain/entities/setting_point_entity.dart';

class SettingPointModel extends SettingPointEntity {
    SettingPointModel({
        super.isApplyProductPoint,
        super.isApplyOrderPoint,
        super.orderExchangeMoney,
        super.orderExchangePoint,
        super.isApplyPaymentPoint,
        super.paymentExchangeMoney,
        super.paymentExchangePoint,
    });

    factory SettingPointModel.fromJson(Map<String, dynamic> json) => SettingPointModel(
        isApplyProductPoint: json['is_apply_product_point'],
        isApplyOrderPoint: json['is_apply_order_point'],
        orderExchangeMoney: json['order_exchange_money'],
        orderExchangePoint: json['order_exchange_point'],
        isApplyPaymentPoint: json['is_apply_payment_point'],
        paymentExchangeMoney: json['payment_exchange_money'],
        paymentExchangePoint: json['payment_exchange_point'],
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
