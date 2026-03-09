
import 'package:freezed_annotation/freezed_annotation.dart';
part 'packaging_entity.freezed.dart';

@freezed
class PackagingEntity with _$PackagingEntity {
  const PackagingEntity._();

  const factory PackagingEntity({
    PackageTypeEntity? parentType,
    PackageTypeEntity? childType,
    PackagingEntity? childPackaging,
    @Default(0) int quantity,
    @Default(0) int quantityAction,
    int? product,
    String? code,
  }) = _PackagingEntity;
}

@freezed
class PackageTypeEntity with _$PackageTypeEntity {
  const PackageTypeEntity._();

  const factory PackageTypeEntity({
    int? id,
    String? title,
  }) = _PackageTypeEntity;
}