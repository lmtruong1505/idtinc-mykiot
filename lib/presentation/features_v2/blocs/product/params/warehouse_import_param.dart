class WarehouseImportParam {
  int? product;
  int? initialStock;
  String? batchCode;
  double? importPrice;
  DateTime? manufacturingDate;
  int? warehouse;

  WarehouseImportParam({
    this.product,
    this.initialStock,
    this.batchCode,
    this.importPrice,
    this.manufacturingDate,
    this.warehouse,
  });

  WarehouseImportParam.fromJson(Map<String, dynamic> json) {
    product = json['product'];
    initialStock = json['initialStock'];
    batchCode = json['batchCode'];
    importPrice = json['importPrice'];
    warehouse = json['warehouse'];
    manufacturingDate = json['manufacturingDate'] != null ? DateTime.parse(json['manufacturingDate']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product'] = product;
    data['initial_stock'] = initialStock;
    data['batch_code'] = batchCode;
    data['import_price'] = importPrice;
    data['warehouse'] = warehouse;
    data['manufacturing_date'] = manufacturingDate?.toIso8601String();
    data.removeWhere((key, value) => value == null);
    return data;
  }

}