import 'ingredient_v2_model.dart';
import 'product_v2_model.dart';
import 'warehouse_v2_model.dart';

class ProductDetailV2Model {
  ProductV2Model? product;
  List<IngredientV2Model> ingredients = [];
  List<WarehouseV2Model> warehouse = [];

  ProductDetailV2Model(
      {this.product, this.ingredients = const [], this.warehouse = const [],
  });

  ProductDetailV2Model.fromJson(Map<String, dynamic> json) {
    product =
    json['product'] != null ? ProductV2Model.fromJson(json['product']) : null;
    if (json['ingredients'] != null) {
      ingredients = <IngredientV2Model>[];
      json['ingredients'].forEach((v) {
        ingredients.add(IngredientV2Model.fromJson(v));
      });
    }
    if (json['warehouse'] != null) {
      warehouse = <WarehouseV2Model>[];
      json['warehouse'].forEach((v) {
        warehouse.add(WarehouseV2Model.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['ingredients'] = ingredients.map((v) => v.toJson()).toList();
      data['warehouse'] = warehouse.map((v) => v.toJson()).toList();
      return data;
  }

}
