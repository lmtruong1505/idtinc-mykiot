class ShipmentsInforModel {
  num? totalShipmentNearDate;
  num? quantityNearDate;
  num? quantityExpDate;
  num? quantityInventory;

  ShipmentsInforModel({
    this.totalShipmentNearDate,
    this.quantityNearDate,
    this.quantityExpDate,
    this.quantityInventory,
  });

  ShipmentsInforModel.fromJson(Map<String, dynamic> json) {
    totalShipmentNearDate = json['total_shipment_near_date'];
    quantityNearDate = json['quantity_near_date'];
    quantityExpDate = json['quantity_exp_date'];
    quantityInventory = json['quantity_inventory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_shipment_near_date'] = totalShipmentNearDate;
    data['quantity_near_date'] = quantityNearDate;
    data['quantity_exp_date'] = quantityExpDate;
    data['quantity_inventory'] = quantityInventory;
    return data;
  }
}
