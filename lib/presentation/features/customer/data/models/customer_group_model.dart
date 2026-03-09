import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_group_model.freezed.dart';

part 'customer_group_model.g.dart';

@freezed
class CustomerGroupModel with _$CustomerGroupModel {
  const CustomerGroupModel._();

  const factory CustomerGroupModel({
    int? id,
    String? code,
    String? name,
    int? company,
    String? note,
    @JsonKey(name: 'user_created')
    int? userCreated,
    @JsonKey(name: 'user_updated')
    int? userUpdated,
    @JsonKey(name: 'created_at')
    String? createdAt,
    @JsonKey(name: 'user_created_name')
    String? userCreatedName,
    @JsonKey(name: 'user_updated_name')
    String? userUpdatedName,
    @JsonKey(name: 'updated_at')
    String? updatedAt,
  }) = _CustomerGroupModel;

  factory CustomerGroupModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerGroupModelFromJson(json);
}
