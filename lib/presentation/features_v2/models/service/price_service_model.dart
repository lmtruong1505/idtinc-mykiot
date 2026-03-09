part of 'service.dart';

class PriceServiceModel {
  int? price;
  String? priceName;
  String? priceType;
  String? type;
  String? title;
  bool? isDefault;
  int? totalSession;
  int? id;
  PriceServiceModel({
    this.price,
    this.priceName,
    this.priceType,
    this.type,
    this.title,
    this.isDefault,
    this.totalSession,
    this.id,
  });

  PriceServiceModel.fromJson(Map<String, dynamic> json) {
    price = json['price'].toString().toDouble?.round();
    priceName = json['price_name_vn'];
    priceType = json['price_type'];
    type = json['type'];
    isDefault = json['is_default'];
    totalSession = json['total_session'];
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['price_name'] = priceName;
    data['price_type'] = priceType;
    data['type'] = type;
    data['default'] = isDefault;
    data['total_session'] = totalSession;
    data['title'] = title;
    data['id'] = id;
    data.removeWhere((key, value) => value == null || value == '');
    return data;
  }
}
