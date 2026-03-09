import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/customer_entity.dart';
import 'package:pharmago/presentation/features/order/domain/entities/order_info_payload_entity.dart';
import 'package:pharmago/presentation/features/order/domain/entities/order_payment_item_payload_entity.dart';
import 'package:pharmago/presentation/features/order/widgets/order_create_payment.dart';

import '../../../product/domain/entities/service_entity.dart';
import '../../../product/domain/entities/variant_entity.dart';
import '../../domain/entities/order_payment_payload_entity.dart';

part 'order_create_state.freezed.dart';

@freezed
class OrderCreateState with _$OrderCreateState {
  const factory OrderCreateState({
    @Default(1) int pageIndex,
    @Default([]) List<VariantEntity> variantSelected,
    @Default([]) List<ServiceEntity> serviceSelected,
    @Default(OrderInfoPayloadEntity()) OrderInfoPayloadEntity orderInfo,
    CustomerEntity? customerSelected,
    @Default(OrderPaymentPayloadEntity())
    OrderPaymentPayloadEntity orderPayment,
    @Default(<PaymentType>[
      PaymentType.cash,
      PaymentType.banking,
      PaymentType.debit,
    ])
    List<PaymentType> paymentType,
    @Default(<PaymentType>[]) List<PaymentType> paymentTypeSelected,
    @Default(<OrderPaymentItemPayloadEntity>[])
    List<OrderPaymentItemPayloadEntity> paymentItems,
    @Default([]) List<CustomerEntity?> suggestCustomer,
    @Default([]) List<VariantEntity?> suggestVariant,
    @Default([]) List<ServiceEntity> suggestService,
    @Default(false) bool isDirtyData,
    String? nameCustomer,
    String? phoneCustomer,
    @Default(0) int tabSelected,
    @Default(0) int total,
    @Default(0) double mustPaidForProduct,
    @Default(0) double mustPaidForService,
    @Default(false) bool selectedOrderRed,
    @Default(OrderType.product) OrderType typeCreate,
    String? mbUuid,
   }) = _OrderCreateState;
}

enum OrderType{
  all(''),
  product('PRODUCT'),
  service('SERVICE');

  const OrderType(this.code);
  final String code;

}

extension OrderTypeExt on OrderType {
  String get toName {
    switch (this) {
      case OrderType.product:
        return 'Sản phẩm';
      case OrderType.service:
        return 'Dịch vụ';
      default:
        return 'Tất cả';
    }
  }
}


enum FilterItemOrder {
  had_choose(''),
  best_seller('POPULAR'),
  newest('NEW');

  const FilterItemOrder(this.code);

  final String code;
}

extension FilterVariantExt on FilterItemOrder {
  String get toName {
    switch (this) {
      case FilterItemOrder.had_choose:
        return 'Đã chọn';
      case FilterItemOrder.best_seller:
        return 'Bán chạy';
      case FilterItemOrder.newest:
        return 'Mới nhất';
      default:
        return '';
    }
  }
}
