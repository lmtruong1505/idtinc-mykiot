
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../employee/employee/domain/entities/employee_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_entity.dart';

part 'service_entity.freezed.dart';

@freezed
class ServiceEntity with _$ServiceEntity{
  const ServiceEntity._();

  const factory ServiceEntity({
    int? id,
    String? image,
    String? code,
    String? title,
    String? entity,
    EmployeeEntity? staff,
    String? frequency,
    String? unit,
    double? price,
    String? description,
    int? company,
    int? userCreated,
    int? userUpdated,
    List<VariantEntity>? variants,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? reminderTime,
    bool? active,
    @Default(0) int amount,
    @Default(false) bool isChoose,
    double? directDiscount,
    String? congTyDk,
    String? soQuyetDinh,
    String? soDangKy,
    String? brand,
    String? type,
    String? actionTime,
    String? chiDinh,
    String? chongChiDinh,
    String? congDung,
    String? tacDungPhu,
    String? luuY,
    String? hinhThuc,
    String? message,
    List<String>? images,
  }) = _ServiceEntity;
}