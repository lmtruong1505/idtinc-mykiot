class ProductCustomerModel {
  int? id;
  String? code;
  String? name;
  String? barcode;
  String? decisionNumber;
  String? registerNumber;
  String? longevity;
  String? media;
  int? vat;
  int? product;
  int? realInventory;
  int? quantityBuy;
  List<UnitsModel>? units;

  ProductCustomerModel({
    this.id,
    this.code,
    this.name,
    this.barcode,
    this.decisionNumber,
    this.registerNumber,
    this.longevity,
    this.media,
    this.vat,
    this.product,
    this.realInventory,
    this.quantityBuy,
    this.units,
  });

  ProductCustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    media = json['media'];
    barcode = json['barcode'];
    decisionNumber = json['decision_number'];
    registerNumber = json['register_number'];
    longevity = json['longevity'];
    vat = json['vat'];
    product = json['product'];
    realInventory = json['real_inventory'];
    quantityBuy = json['quantity_buy'];
    if(json['units'] != null){
      units = [];
      for(final e in json['units']){
        units?.add(UnitsModel.fromJson(e));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['barcode'] = barcode;
    data['decision_number'] = decisionNumber;
    data['register_number'] = registerNumber;
    data['longevity'] = longevity;
    data['vat'] = vat;
    data['product'] = product;
    data['real_inventory'] = realInventory;
    data['quantity_buy'] = quantityBuy;
    data['media'] = media;
    data['units'] = units
        ?.map(
          (e) => e.toJson(),
        )
        .toList();
    return data;
  }
}

class UnitsModel {
  int? id;
  String? name;
  int? sellPrice;
  int? importPrice;
  bool? isDefault;

  UnitsModel({
    this.id,
    this.name,
    this.sellPrice,
    this.importPrice,
    this.isDefault,
  });

  UnitsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sellPrice = json['sell_price'];
    importPrice = json['import_price'];
    isDefault = json['default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['sell_price'] = sellPrice;
    data['import_price'] = importPrice;
    data['default'] = isDefault;
    return data;
  }
}
