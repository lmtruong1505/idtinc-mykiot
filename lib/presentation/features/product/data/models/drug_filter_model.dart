import 'package:json_annotation/json_annotation.dart';
import 'package:pharmago/presentation/features/product/data/models/basic_model.dart';

part 'drug_filter_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DrugFilterModel {
  DrugFilterModel({
    this.brand,
    this.category,
    this.group,
  });

  final List<BasicModel>? brand;
  final List<BasicModel>? category;
  final List<BasicModel>? group;

  factory DrugFilterModel.fromJson(Map<String, dynamic> json) =>
      _$DrugFilterModelFromJson(json);

  Map<String, dynamic> toJson() => _$DrugFilterModelToJson(this);
}
