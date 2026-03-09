import 'package:pharmago/presentation/features_v2/models/product/unit_v2_model.dart';

class PrdDashboardModel {
  int? variantId;
  String? name;
  num? revenue;
  num? sold;
  num? availableStock;
  List<UnitV2Model>? units;
  UnitV2Model? unitSell;

  PrdDashboardModel({
    this.variantId,
    this.name,
    this.revenue,
    this.sold,
    this.availableStock,
    this.units,
    this.unitSell,
  });

  PrdDashboardModel.fromJson(Map<String, dynamic> json) {
    variantId = json['variant_id'];
    name = json['name'];
    revenue = json['revenue'];
    sold = json['sold'];
    availableStock = json['available_stock'] ?? json['inventory'];
    units = json['units'] == null
        ? null
        : (json['units'] as List).map((e) => UnitV2Model.fromJson(e)).toList();
    unitSell = json['unit_sell'] == null
        ? json['unit_storage'] == null
            ? null
            : UnitV2Model.fromJson(json['unit_storage'])
        : UnitV2Model.fromJson(json['unit_sell']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['variant_id'] = variantId;
    data['name'] = name;
    data['revenue'] = revenue;
    data['sold'] = sold;
    data['available_stock'] = availableStock;
    return data;
  }
}
