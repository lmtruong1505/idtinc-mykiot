import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/company/data/models/company_model.dart';
import 'package:pharmago/presentation/features_v2/models/product/product_v2_model.dart';
import 'package:pharmago/presentation/features_v2/models/product/unit_v2_model.dart';
import 'package:pharmago/presentation/features_v2/models/service/service.dart';

import '../../../features/company/data/models/point_exchange_package_model.dart';
import '../employee/user_data_model.dart';

part 'order_detail_v2_model.freezed.dart';
part 'order_detail_v2_model.g.dart';

@freezed
class OrderDetailV2Model with _$OrderDetailV2Model {
  const factory OrderDetailV2Model({
    int? id,
    String? code,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'role_name') String? roleName,
    @JsonKey(name: 'status') String? statusOrder,
    @JsonKey(name: 'is_delivered') @Default(false) bool isDelivered,
    @JsonKey(name: 'use_red_invoice') @Default(false) bool useRedInvoice,
    @Default('product') String type,
    // @Default(false) @JsonKey(name: 'red_invoice') bool redInvoice,
    @Default(false) @JsonKey(name: 'send_zalooa') bool sendZalooa,
    @JsonKey(name: 'red_invoice') final String? redInvoiceStatus,
    String? description,
    @JsonKey(name: 'prescription_code') String? prescriptionCode,
    @JsonKey(name: 'prescription_images') List<PrescriptionImageV2Model>? prescriptionImages,
    @JsonKey(name: 'user_created') UserDataModel? userCreated,
    Customer? customer,
    @Default([]) List<OrderItemV2> items,
    @JsonKey(name: 'product_exchange_points')
    @Default([])
    List<ProductExchangePointItem> productExchangePoints,
    @Default(0.0) @JsonKey(name: 'total_price') double totalPrice,
    @Default(0) @JsonKey(name: 'total_point') num totalPoint,
    @Default([]) List<OrderServiceItemV2> services,
    String? qr,
    @Default([]) List<PaymentV2> payments,
    @JsonKey(name: 'log_points')
    @Default(<LogPointsModel>[])
    List<LogPointsModel> logPoints,
    CompanyModel? company,
  }) = _OrderDetailV2Model;

  factory OrderDetailV2Model.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailV2ModelFromJson(json);
}

extension Fun on OrderDetailV2Model {
  String get statusSub {
    switch (statusOrder) {
      case 'PLACED':
        return 'Đã đặt hàng';
      case 'CONFIRMED':
        return 'Chờ thanh toán';
      case 'PENDING':
        return 'Đã đặt hàng';
      case 'INCOMPLETE':
        return 'Chưa thanh toán đủ';
      case 'PAID':
        return 'Đã thanh toán';
      default:
        return 'Đã hủy';
    }
  }

  bool get redInvoice {
    return useRedInvoice;
  }

  num get totalPointLog {
    return logPoints
        .where((e) => ![
              'PACKAGE_EXCHANGE',
              'POINT_EXCHANGE',
              'PRODUCT_EXCHANGE',
            ].contains(e.type))
        .fold(
      0,
      (total, e) {
        total += e.point;
        return total;
      },
    );
  }

  num get totalPointLogUsed {
    return logPoints
        .where((e) => [
              'PACKAGE_EXCHANGE',
              'POINT_EXCHANGE',
              'PRODUCT_EXCHANGE',
            ].contains(e.type))
        .fold(
      0,
      (total, e) {
        total += e.point;
        return total;
      },
    );
  }

  num get pointRevenueExchange {
    return logPoints
        .where((e) => e.type == 'ORDER_REVENUE')
        .fold(
      0,
      (total, e) {
        total += e.point;
        return total;
      },
    );
  }

  num get pointProductPlusExchange {
    return logPoints
        .where((e) => e.type == 'ORDER_ITEM')
        .fold(
      0,
      (total, e) {
        total += e.point;
        return total;
      },
    );
  }

  num get pointMoneyExchange {
    return logPoints
        .where((e) => e.type == 'POINT_EXCHANGE')
        .fold(
      0,
      (total, e) {
        total += e.point;
        return total;
      },
    );
  }

  num get moneyExchange {
    return logPoints
        .where((e) => e.type == 'POINT_EXCHANGE')
        .fold(
      0,
      (total, e) {
        total += e.moneyExchange;
        return total;
      },
    );
  }

  num get pointProductExchange {
    return logPoints
        .where((e) => e.type == 'PRODUCT_EXCHANGE')
        .fold(
      0,
      (total, e) {
        total += e.point;
        return total;
      },
    );
  }

  num get pointPackageExchange {
    return logPoints
        .where((e) => e.type == 'PACKAGE_EXCHANGE')
        .fold(
      0,
      (total, e) {
        total += e.point;
        return total;
      },
    );
  }
}

@freezed
class Customer with _$Customer {
  const factory Customer({
    int? id,
    String? code,
    @JsonKey(name: 'prefix_name') String? prefixName,
    String? type,
    @Default(false) @JsonKey(name: 'is_care_zalooa') bool isCareZalooa,
    @Default(false) @JsonKey(name: 'is_zalo') bool isZalo,
    String? phone,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}

@freezed
class PrescriptionImageV2Model with _$PrescriptionImageV2Model {
  const factory PrescriptionImageV2Model({
    String? url,
    @JsonKey(name: 'is_main') @Default(false) bool isMain,
    @JsonKey(name: 'file_name') String? fileName,
  }) = _PrescriptionImageV2Model;

  factory PrescriptionImageV2Model.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionImageV2ModelFromJson(json);
}

@freezed
class OrderItemV2 with _$OrderItemV2 {
  const factory OrderItemV2({
    int? id,
    @Default(0.0) double price,
    @Default(0) int quantity,
    @Default(0.0) @JsonKey(name: 'discount_price') double discountPrice,
    @Default(0) int no,
    int? consignment,
    @JsonKey(name: 'product_data') ProductV2Model? productData,
    @JsonKey(name: 'unit_data') UnitV2Model? unitData,
    @JsonKey(name: 'infor_shipment') OrderItemV2InfoShipment? inforShipment,
  }) = _OrderItemV2;

  factory OrderItemV2.fromJson(Map<String, dynamic> json) =>
      _$OrderItemV2FromJson(json);
}

@freezed
class ProductExchangePointItem with _$ProductExchangePointItem {
  const factory ProductExchangePointItem({
    int? id,
    @Default(0) num point,
    @Default(0) num quantity,
    @JsonKey(name: 'product_data') ProductV2Model? productData,
    PointExchangePackageModel? package,
  }) = _ProductExchangePointItem;

  factory ProductExchangePointItem.fromJson(Map<String, dynamic> json) =>
      _$ProductExchangePointItemFromJson(json);
}

@freezed
class OrderItemV2InfoShipment with _$OrderItemV2InfoShipment {
  const factory OrderItemV2InfoShipment({
    @Default([]) List<OrderItemV2Shipment> shipment,
  }) = _OrderItemV2InfoShipment;

  factory OrderItemV2InfoShipment.fromJson(Map<String, dynamic> json) =>
      _$OrderItemV2InfoShipmentFromJson(json);
}

@freezed
class OrderItemV2Shipment with _$OrderItemV2Shipment {
  const factory OrderItemV2Shipment({
    int? id,
    String? code,
    @Default(0) int quantity,
  }) = _OrderItemV2Shipment;

  factory OrderItemV2Shipment.fromJson(Map<String, dynamic> json) =>
      _$OrderItemV2ShipmentFromJson(json);
}

@freezed
class OrderServiceItemV2 with _$OrderServiceItemV2 {
  const factory OrderServiceItemV2({
    int? id,
    double? price,
    int? quantity,
    @JsonKey(name: 'discount_price') double? discountPrice,
    @JsonKey(name: 'employee_id') int? employeeId,
    @JsonKey(name: 'price_name') String? priceName,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'expiry_date') DateTime? expiryDate,
    ServiceV2Model? service,
    @JsonKey(name: 'medical_bill') int? medicalBill,
  }) = _OrderServiceItemV2;

  factory OrderServiceItemV2.fromJson(Map<String, dynamic> json) =>
      _$OrderServiceItemV2FromJson(json);
}

extension OrderServiceItemV2Fun on OrderServiceItemV2 {
  num get totalPrice {
    return (price ?? 0) * (quantity ?? 0);
  }

  num get vat {
    return totalPrice * (service?.vat ?? 0) / 100;
  }

  num get totalDiscount {
    return (discountPrice ?? 0) * (quantity ?? 0);
  }
}

extension OrderItemV2Fun on OrderItemV2 {
  num get priceItem {
    return price * quantity;
  }

  num get vatProd {
    return priceItem * (productData?.vat ?? 0) / 100;
  }
}

@freezed
class PaymentV2 with _$PaymentV2 {
  const factory PaymentV2({
    int? id,
    @Default(0.0) double amount,
    @Default('cash') String method,
  }) = _PaymentV2;

  factory PaymentV2.fromJson(Map<String, dynamic> json) =>
      _$PaymentV2FromJson(json);
}

@freezed
class LogPointsModel with _$LogPointsModel {
  const factory LogPointsModel({
    int? id,
    @Default(0.0) num point,
    String? type,
    @JsonKey(name: 'money_exchange') @Default(0.0) num moneyExchange,
  }) = _LogPointsModel;

  factory LogPointsModel.fromJson(Map<String, dynamic> json) =>
      _$LogPointsModelFromJson(json);
}
