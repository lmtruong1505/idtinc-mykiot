import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_model.freezed.dart';
part 'role_model.g.dart';

@JsonSerializable()
class RoleModel {
    RoleModel({
        required this.id,
        required this.title,
        required this.company,
        required this.userCreatedName,
        required this.userUpdatedName,
        required this.createdAt,
        required this.updatedAt,
    });

    final int? id;
    final String? title;
    final int? company;

    @JsonKey(name: 'user_created_name') 
    final String? userCreatedName;

    @JsonKey(name: 'user_updated_name') 
    final String? userUpdatedName;

    @JsonKey(name: 'created_at') 
    final DateTime? createdAt;

    @JsonKey(name: 'updated_at') 
    final DateTime? updatedAt;

    factory RoleModel.fromJson(Map<String, dynamic> json) => _$RoleModelFromJson(json);

    Map<String, dynamic> toJson() => _$RoleModelToJson(this);

}

@freezed
class ItemModel with _$ItemModel {
  const ItemModel._();

  const factory ItemModel({
    @Default('') String title,
    @Default('') String code,
    @Default(false) bool checked,
    @Default([]) List<ItemModel> items,
  }) = _ItemModel;

  factory ItemModel.fromJson(Map<String, dynamic> json) => _$ItemModelFromJson(json);
}

