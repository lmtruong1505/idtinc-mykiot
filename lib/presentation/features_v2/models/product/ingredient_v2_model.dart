class IngredientV2Model {
  int? id;
  String? weight;
  String? name;

  IngredientV2Model({this.id, this.weight, this.name});

  IngredientV2Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weight = json['weight'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['weight'] = weight;
    data['name'] = name;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
