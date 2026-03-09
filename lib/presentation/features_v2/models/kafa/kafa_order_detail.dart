enum TypeOderItemKafa {
  sell(0, 'SELL'),
  bonus(1, 'BONUS'),
  customer(2, 'CONSUMER');

  final int id;
  final String code;

  const TypeOderItemKafa(this.id, this.code);
}

class KafaOrderDetailModel {
  int? id;
  int? dloId;
  String? title;
  String? code;
  double? total;
  double? tax;
  double? costs;
  double? discount;
  bool? isOnline;
  bool? exportStatus;
  String? note;
  bool? orderRed;
  int? status;
  int? account;
  List<PromotionsOrder>? promotionsOrder;
  List<DiscountOrder>? discountOrder;
  int? userUpdated;
  String? createdAt;
  String? updatedAt;
  int? customer;
  StatusOrderData? statusOrderData;
  AccountData? accountData;
  UserUpdatedData? userUpdatedData;
  UserUpdatedData? userCreatedData;
  CustomerData? customerData;
  List<Orderitems>? orderitems;

  KafaOrderDetailModel({
    this.id,
    this.dloId,
    this.title,
    this.code,
    this.total,
    this.tax,
    this.costs,
    this.discount,
    this.isOnline,
    this.exportStatus,
    this.note,
    this.orderRed,
    this.status,
    this.account,
    this.promotionsOrder,
    this.discountOrder,
    this.userUpdated,
    this.createdAt,
    this.updatedAt,
    this.customer,
    this.statusOrderData,
    this.accountData,
    this.userUpdatedData,
    this.userCreatedData,
    this.customerData,
    this.orderitems,
  });

  KafaOrderDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dloId = json['dlo_id'];
    title = json['title'];
    code = json['code'];
    total = double.tryParse(json['total'].toString());
    tax = double.tryParse(json['tax'].toString());
    costs = double.tryParse(json['costs'].toString());
    discount = double.tryParse(json['discount'].toString());
    isOnline = json['is_online'];
    exportStatus = json['export_status'];
    note = json['note'];
    orderRed = json['order_red'];
    status = json['status'];
    account = json['account'];
    if (json['promotions_order'] != null) {
      promotionsOrder = <PromotionsOrder>[];
      json['promotions_order'].forEach((v) {
        promotionsOrder!.add(PromotionsOrder.fromJson(v));
      });
    }
    if (json['discount_order'] != null) {
      discountOrder = <DiscountOrder>[];
      json['discount_order'].forEach((v) {
        discountOrder!.add(DiscountOrder.fromJson(v));
      });
    }
    userUpdated = json['user_updated'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customer = json['customer'];
    statusOrderData = json['status_order_data'] != null
        ? StatusOrderData.fromJson(json['status_order_data'])
        : null;
    accountData = json['account_data'] != null
        ? AccountData.fromJson(json['account_data'])
        : null;
    userUpdatedData = json['user_updated_data'] != null
        ? UserUpdatedData.fromJson(json['user_updated_data'])
        : null;
    userCreatedData = json['user_created_data'] != null
        ? UserUpdatedData.fromJson(json['user_created_data'])
        : null;
    customerData = json['customer_data'] != null
        ? CustomerData.fromJson(json['customer_data'])
        : null;

    if (json['orderitems'] != null) {
      orderitems = <Orderitems>[];
      json['orderitems'].forEach((v) {
        orderitems!.add(Orderitems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['dlo_id'] = dloId;
    data['title'] = title;
    data['code'] = code;
    data['total'] = total;
    data['tax'] = tax;
    data['costs'] = costs;
    data['discount'] = discount;
    data['is_online'] = isOnline;
    data['export_status'] = exportStatus;
    data['note'] = note;
    data['order_red'] = orderRed;
    data['status'] = status;
    data['account'] = account;
    if (promotionsOrder != null) {
      data['promotions_order'] =
          promotionsOrder!.map((v) => v.toJson()).toList();
    }
    if (discountOrder != null) {
      data['discount_order'] = discountOrder!.map((v) => v.toJson()).toList();
    }
    data['user_updated'] = userUpdated;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['customer'] = customer;
    if (statusOrderData != null) {
      data['status_order_data'] = statusOrderData!.toJson();
    }
    if (accountData != null) {
      data['account_data'] = accountData!.toJson();
    }
    if (userUpdatedData != null) {
      data['user_updated_data'] = userUpdatedData!.toJson();
    }
    if (userCreatedData != null) {
      data['user_created_data'] = userCreatedData!.toJson();
    }
    if (customerData != null) {
      data['customer_data'] = customerData!.toJson();
    }

    if (orderitems != null) {
      data['orderitems'] = orderitems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PromotionsOrder {
  int? id;
  String? title;
  String? promotionTypeTitle;
  String? promotionTypeCode;

  PromotionsOrder({
    this.id,
    this.title,
    this.promotionTypeTitle,
    this.promotionTypeCode,
  });

  PromotionsOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    promotionTypeTitle = json['promotion_type__title'];
    promotionTypeCode = json['promotion_type__code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['promotion_type__title'] = promotionTypeTitle;
    data['promotion_type__code'] = promotionTypeCode;
    return data;
  }
}

class DiscountOrder {
  int? id;
  int? timesApplyPromotion;
  String? promotionTitle;
  double? valueMin;
  String? typeDiscount;
  int? discountValue;
  PromotionItemData? promotionItemData;

  DiscountOrder({
    this.id,
    this.timesApplyPromotion,
    this.promotionTitle,
    this.valueMin,
    this.typeDiscount,
    this.discountValue,
    this.promotionItemData,
  });

  DiscountOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timesApplyPromotion = json['times_apply_promotion'];
    promotionTitle = json['promotion_title'];
    valueMin = double.tryParse(json['value_min'].toString());
    typeDiscount = json['type_discount'];
    discountValue = json['discount_value'];
    promotionItemData = json['promotion_item_data'] != null
        ? PromotionItemData.fromJson(json['promotion_item_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['times_apply_promotion'] = timesApplyPromotion;
    data['promotion_title'] = promotionTitle;
    data['value_min'] = valueMin;
    data['type_discount'] = typeDiscount;
    data['discount_value'] = discountValue;
    if (promotionItemData != null) {
      data['promotion_item_data'] = promotionItemData!.toJson();
    }
    return data;
  }
}

class PromotionItemData {
  int? id;
  double? valueMin;
  int? promotionId;

  PromotionItemData({this.id, this.valueMin, this.promotionId});

  PromotionItemData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    valueMin = double.tryParse(json['value_min'].toString());
    promotionId = json['promotion_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value_min'] = valueMin;
    data['promotion_id'] = promotionId;
    return data;
  }
}

class StatusOrderData {
  int? id;
  String? title;
  String? code;

  StatusOrderData({this.id, this.title, this.code});

  StatusOrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['code'] = code;
    return data;
  }
}

class AccountData {
  int? id;
  String? fullName;
  String? phone;
  String? roleName;
  String? companyName;
  AddressData? addressData;

  AccountData({
    this.id,
    this.fullName,
    this.phone,
    this.addressData,
    this.roleName,
    this.companyName,
  });

  AccountData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    roleName = json['role_name'];
    companyName = json['company_name'];
    phone = json['phone'];
    addressData = json['address_data'] != null
        ? AddressData.fromJson(json['address_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['role_name'] = roleName;
    data['company_name'] = companyName;
    data['phone'] = phone;
    if (addressData != null) {
      data['address_data'] = addressData!.toJson();
    }
    return data;
  }
}

class AddressData {
  int? id;
  String? title;
  double? lat;
  double? long;
  StatusOrderData? areaData;
  StatusOrderData? provinceData;
  StatusOrderData? districtData;
  StatusOrderData? wardData;
  int? area;
  int? province;
  int? district;
  int? ward;

  AddressData({
    this.id,
    this.title,
    this.lat,
    this.long,
    this.areaData,
    this.provinceData,
    this.districtData,
    this.wardData,
    this.area,
    this.province,
    this.district,
    this.ward,
  });

  AddressData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    lat = json['lat'];
    long = json['long'];
    areaData = json['area_data'] != null
        ? StatusOrderData.fromJson(json['area_data'])
        : null;
    provinceData = json['province_data'] != null
        ? StatusOrderData.fromJson(json['province_data'])
        : null;
    districtData = json['district_data'] != null
        ? StatusOrderData.fromJson(json['district_data'])
        : null;
    wardData = json['ward_data'] != null
        ? StatusOrderData.fromJson(json['ward_data'])
        : null;
    area = json['area'];
    province = json['province'];
    district = json['district'];
    ward = json['ward'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['lat'] = lat;
    data['long'] = long;
    if (areaData != null) {
      data['area_data'] = areaData!.toJson();
    }
    if (provinceData != null) {
      data['province_data'] = provinceData!.toJson();
    }
    if (districtData != null) {
      data['district_data'] = districtData!.toJson();
    }
    if (wardData != null) {
      data['ward_data'] = wardData!.toJson();
    }
    data['area'] = area;
    data['province'] = province;
    data['district'] = district;
    data['ward'] = ward;
    return data;
  }
}

class UserUpdatedData {
  int? id;
  String? fullName;

  UserUpdatedData({this.id, this.fullName});

  UserUpdatedData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    return data;
  }
}

class CustomerData {
  int? id;
  String? fullName;
  String? phone;
  String? code;
  AddressData? addressData;

  CustomerData({
    this.id,
    this.fullName,
    this.phone,
    this.code,
    this.addressData,
  });

  CustomerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    phone = json['phone'];
    code = json['code'];
    addressData = json['address_data'] != null
        ? AddressData.fromJson(json['address_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['phone'] = phone;
    data['code'] = code;
    if (addressData != null) {
      data['address_data'] = addressData!.toJson();
    }
    return data;
  }
}

class Orderitems {
  int? id;
  int? quantity;
  double? price;
  double? discount;
  int? type;
  String? typeData;
  double? total;
  int? variant;
  PromotionsDict? promotionsDict;
  dynamic timesApplyPromotion;
  PromotionItemData? promotionItemData;
  VariantData? variantData;
  List<PromotionsData>? promotionsData;
  int? variantPromotion;
  VariantPromotionData? variantPromotionData;
  List<Orderitems>? children;

  Orderitems({
    this.id,
    this.quantity,
    this.price,
    this.discount,
    this.type,
    this.typeData,
    this.total,
    this.variant,
    this.promotionsDict,
    this.timesApplyPromotion,
    this.promotionItemData,
    this.variantData,
    this.promotionsData,
    this.variantPromotion,
    this.variantPromotionData,
    this.children,
  });

  Orderitems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    price = double.tryParse(json['price'].toString());
    discount = double.tryParse(json['discount'].toString());
    type = json['type'];
    typeData = json['type_data'];
    total = double.tryParse(json['total'].toString());
    variant = json['variant'];
    promotionsDict = json['promotions_dict'] != null
        ? PromotionsDict.fromJson(json['promotions_dict'])
        : null;
    timesApplyPromotion = json['times_apply_promotion'];
    promotionItemData = json['promotion_item_data'] != null
        ? PromotionItemData.fromJson(json['promotion_item_data'])
        : null;
    variantData = json['variant_data'] != null
        ? VariantData.fromJson(json['variant_data'])
        : null;
    if (json['promotions_data'] != null) {
      promotionsData = <PromotionsData>[];
      json['promotions_data'].forEach((v) {
        promotionsData!.add(PromotionsData.fromJson(v));
      });
    }
    variantPromotion = json['variant_promotion'];
    variantPromotionData = json['variant_promotion_data'] != null
        ? VariantPromotionData.fromJson(json['variant_promotion_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    data['price'] = price;
    data['discount'] = discount;
    data['type'] = type;
    data['type_data'] = typeData;
    data['total'] = total;
    data['variant'] = variant;
    if (promotionsDict != null) {
      data['promotions_dict'] = promotionsDict!.toJson();
    }
    data['times_apply_promotion'] = timesApplyPromotion;
    if (promotionItemData != null) {
      data['promotion_item_data'] = promotionItemData!.toJson();
    }
    if (variantData != null) {
      data['variant_data'] = variantData!.toJson();
    }
    if (promotionsData != null) {
      data['promotions_data'] = promotionsData!.map((v) => v.toJson()).toList();
    }
    data['variant_promotion'] = variantPromotion;
    if (variantPromotionData != null) {
      data['variant_promotion_data'] = variantPromotionData!.toJson();
    }
    return data;
  }
}

class PromotionsDict {
  List<int>? promotionsDict;

  PromotionsDict({this.promotionsDict});

  PromotionsDict.fromJson(Map<String, dynamic> json) {
    if (json['promotions_dict'] is List<int>) {
      promotionsDict = json['promotions_dict'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promotions_dict'] = promotionsDict;
    return data;
  }
}

class VariantData {
  int? id;
  String? title;
  String? code;
  bool? status;
  double? priceSell;
  double? priceSellApply;
  int? quantity;
  double? weight;
  String? image;
  int? product;
  StatusOrderData? productData;
  String? productTitle;

  VariantData({
    this.id,
    this.title,
    this.code,
    this.status,
    this.priceSell,
    this.priceSellApply,
    this.quantity,
    this.weight,
    this.image,
    this.product,
    this.productData,
    this.productTitle,
  });

  VariantData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    code = json['code'];
    status = json['status'];
    priceSell = double.tryParse(json['price_sell'].toString());
    priceSellApply = double.tryParse(json['price_sell_apply'].toString());
    quantity = int.tryParse(json['quantity'].toString());
    weight = double.tryParse(json['weight'].toString());
    image = json['image'];
    product = json['product'];
    productData = json['product_data'] != null
        ? StatusOrderData.fromJson(json['product_data'])
        : null;

    productTitle = json['product__title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['code'] = code;
    data['status'] = status;
    data['price_sell'] = priceSell;
    data['price_sell_apply'] = priceSellApply;
    data['quantity'] = quantity;
    data['weight'] = weight;
    data['image'] = image;
    data['product'] = product;
    if (productData != null) {
      data['product_data'] = productData!.toJson();
    }
    data['product__title'] = productTitle;
    return data;
  }
}

class PromotionsData {
  int? id;
  String? title;

  PromotionsData({this.id, this.title});

  PromotionsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}

class VariantPromotionData {
  int? id;
  String? title;
  String? code;
  bool? status;
  double? priceSell;
  int? quantity;
  String? image;
  int? product;
  StatusOrderData? productData;
  String? productTitle;

  VariantPromotionData({
    this.id,
    this.title,
    this.code,
    this.status,
    this.priceSell,
    this.quantity,
    this.image,
    this.product,
    this.productData,
    this.productTitle,
  });

  VariantPromotionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    code = json['code'];
    status = json['status'];
    priceSell = double.tryParse(json['price_sell'].toString());
    quantity = int.tryParse(json['quantity'].toString());
    image = json['image'];
    product = json['product'];
    productData = json['product_data'] != null
        ? StatusOrderData.fromJson(json['product_data'])
        : null;
    productTitle = json['product__title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['code'] = code;
    data['status'] = status;
    data['price_sell'] = priceSell;
    data['quantity'] = quantity;
    data['image'] = image;
    data['product'] = product;
    if (productData != null) {
      data['product_data'] = productData!.toJson();
    }

    data['product__title'] = productTitle;
    return data;
  }
}
