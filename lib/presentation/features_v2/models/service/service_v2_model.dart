part of 'service.dart';

class ServiceV2Model {
  int? id;
  int? serviceEventId;
  String? description;
  String? entity;
  bool? active;
  String? title;
  num? vat;
  String? code;
  int? company;
  PriceService? price;
  PriceService? priceCustom;
  List<String>? images;
  int quantity = 1;
  num discount = 0;
  PreEmpModel? employee;
  int relatedProd = 0;

  ServiceV2Model({
    this.id,
    this.description,
    this.serviceEventId,
    this.entity,
    this.active,
    this.title,
    this.vat,
    this.code,
    this.company,
    this.price,
    this.priceCustom,
    this.images,
    this.quantity = 1,
    this.discount = 0,
    this.employee,
    this.relatedProd = 0,
  });

  ServiceV2Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    entity = json['entity'];
    active = json['active'];
    title = json['title'] ?? json['service_name'];
    code = json['code'];
    vat = json['vat'];
    relatedProd = json['related_prod'] ?? 0;
    employee = json['employee'];
    company = json['company'];
    price = json['price'] != null ? PriceService.fromJson(json['price']) : null;

    if (json['images'] is List) {
      images = [];
      for (final image in json['images']) {
        images!.add(image.toString());
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['entity'] = entity;
    data['active'] = active;
    data['title'] = title;
    data['code'] = code;
    data['vat'] = vat;
    data['company'] = company;
    if (price != null) {
      data['price'] = price!.toJson();
    }

    data['images'] = images;
    data['quantity'] = quantity;
    data['employee'] = employee;
    data['discount_price'] = discount;
    return data;
  }

  ServiceV2Model copyWith({
    int? id,
    int? serviceEventId,
    String? description,
    String? entity,
    bool? active,
    String? title,
    String? code,
    num? vat,
    int? company,
    PriceService? price,
    PriceService? priceCustom,
    List<String>? images,
    int? quantity,
    PreEmpModel? employee,
    num? discount,
    int? relatedProd,
  }) {
    return ServiceV2Model(
      id: id ?? this.id,
      serviceEventId: serviceEventId ?? this.serviceEventId,
      description: description ?? this.description,
      entity: entity ?? this.entity,
      active: active ?? this.active,
      title: title ?? this.title,
      code: code ?? this.code,
      vat: vat ?? this.vat,
      company: company ?? this.company,
      price: price ?? this.price,
      priceCustom: priceCustom ?? this.priceCustom,
      images: images ?? this.images,
      quantity: quantity ?? this.quantity,
      employee: employee ?? this.employee,
      discount: discount ?? this.discount,
      relatedProd: relatedProd ?? this.relatedProd,
    );
  }
}

extension Fun on ServiceV2Model {
  num get totalPrice {
    return quantity * ((priceCustom?.price ?? price?.price ?? 0) - discount);
  }

  num get vatPrice {
    return totalPrice * (vat ?? 0) / 100;
  }
}

class PriceService {
  num? price;
  String? priceName;
  String? priceNameSub;
  String? type;
  String? title;
  bool? isDefault;
  int? totalSession;
  int? id;

  PriceService({
    this.price,
    this.priceName,
    this.priceNameSub,
    this.type,
    this.title,
    this.isDefault,
    this.totalSession,
    this.id,
  });

  PriceService.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    priceName = json['price_name'];
    type = json['type'];
    priceNameSub = json['type'] == 'SINGLE'
        ? 'lượt'
        : json['type'] == 'MEMBERSHIP'
            ? 'gói'
            : 'combo';
    isDefault = json['is_default'];
    totalSession = json['total_session'];
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['price_name'] = priceName;
    data['type'] = type;
    data['is_default'] = isDefault;
    data['total_session'] = totalSession;
    data['title'] = title;
    data['id'] = id;
    return data;
  }

  PriceService copyWith({
    num? price,
  }) {
    return PriceService(
      id: id,
      priceName: priceName,
      type: type,
      title: title,
      isDefault: isDefault,
      totalSession: totalSession,
      price: price ?? this.price,
      priceNameSub: priceNameSub,
    );
  }
}
