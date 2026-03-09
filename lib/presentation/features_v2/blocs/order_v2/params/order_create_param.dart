import 'package:collection/collection.dart';

import '../../../../features/company/data/models/point_exchange_package_model.dart';
import '../../../../features/warehouse/domain/entities/shipment_data_entity.dart';

class OrderCreateParam {
  OrderParam? order;
  int? appointmentId;
  List<ProductExchangePointParam>? productExchangePoint;
  List<ItemParam>? items;
  bool? sendZNS;
  List<ServiceItemParam>? services;

  OrderCreateParam({
    this.order,
    this.productExchangePoint,
    this.items,
    this.services,
    this.appointmentId,
    this.sendZNS,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order'] = order?.toJson();
    data['appointment_id'] = appointmentId;
    data['is_send_zns'] = sendZNS;
    data['is_send_red_invoice'] = order?.redInvoice;
    data['product_exchange_point'] =
        productExchangePoint?.map((v) => v.toJson()).toList();
    data['items'] = items?.map((v) => v.toJson()).toList();
    data['services'] = services?.map((v) => v.toJson()).toList();
    return data;
  }
}

class OrderParam {
  String? type;
  bool? redInvoice;
  double? totalAmount;
  String? description;
  String? customer;
  String? customerName;
  String? customerBirthday;
  String? customerGender;
  int? company;
  String? mbUuid;
  int? pointExchange;
  double? moneyExchange;
  String? prescriptionCode;

  OrderParam({
    this.type,
    this.redInvoice,
    this.totalAmount,
    this.description,
    this.customer,
    this.customerName,
    this.customerBirthday,
    this.customerGender,
    this.company,
    this.mbUuid,
    this.pointExchange,
    this.moneyExchange,
    this.prescriptionCode,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['use_red_invoice'] = redInvoice;
    data['is_send_red_invoice'] = redInvoice;
    data['total_amount'] = totalAmount;
    data['description'] = description;
    data['customer'] = customer;
    data['customer_name'] = customerName;
    data['customer_birthday'] = customerBirthday;
    data['customer_gender'] = customerGender;
    data['company'] = company;
    data['mb_uuid'] = mbUuid;
    data['point_exchange'] = pointExchange;
    data['money_exchange'] = moneyExchange;
    data['prescription_code'] = prescriptionCode;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}

class ItemParam {
  int? product;
  int? quantity;
  double? price;
  double? discountPrice;
  int? no;
  int? unit;
  List<ShipmentItemEntity>? shipments;
  int? valueUnitChange;

  ItemParam({
    this.product,
    this.quantity,
    this.price,
    this.discountPrice,
    this.no,
    this.unit,
    this.shipments,
    this.valueUnitChange,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product'] = product;
    data['quantity'] = quantity;
    data['price'] = price;
    data['discount_price'] = discountPrice;
    data['no'] = no;
    data['unit'] = unit;
    data['shipment'] = shipments
        ?.map(
          (e) => {
            'id': e.id,
            'code': e.code,
            'quantity': e.selectedQuantity,
            'real_quantity': e.selectedQuantity ~/ (valueUnitChange ?? 1),
            'unit': unit,
            'type_warehouse': {
              'id': e.typeWarehouse?.id,
              'code': e.typeWarehouse?.code,
              'title': e.typeWarehouse?.title,
            },
            'status_label': e.statusLabel,
          },
        )
        .toList();
    data.removeWhere((key, value) => value == null);
    return data;
  }
}

class ServiceItemParam {
  int? service;
  int? quantity;
  double? price;
  double? discountPrice;
  int? employee;
  int? priceName;

  ServiceItemParam({
    this.service,
    this.quantity,
    this.price,
    this.discountPrice,
    this.employee,
    this.priceName,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service'] = service;
    data['quantity'] = quantity;
    data['price'] = price;
    data['discount_price'] = discountPrice;
    data['employee'] = employee;
    data['price_name'] = priceName;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}

class ProductExchangePointParam {
  int? product;
  int? quantity;
  PointExchangePackageModel? package;

  ProductExchangePointParam({
    this.product,
    this.quantity,
    this.package,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product'] = product;
    data['quantity'] = quantity;
    data['point_exchange_package'] = package?.id;
    data['unit'] = package?.items?.firstWhereOrNull((e) => e.product?.id == product)?.unit?.id;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
