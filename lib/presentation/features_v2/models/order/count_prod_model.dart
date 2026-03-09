class CountProdModel {
  int? product;
  int? service;

  CountProdModel({this.product, this.service});

  CountProdModel.fromJson(Map<String, dynamic> json) {
    product = json['product'];
    service = json['service'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product'] = product;
    data['service'] = service;
    return data;
  }
}