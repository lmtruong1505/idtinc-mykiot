import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_company_entity.freezed.dart';

@freezed
class ProductCompanyEntity with _$ProductCompanyEntity {
  const ProductCompanyEntity._();

  const factory ProductCompanyEntity({
    int? id,
    @Default("") String code,
    @Default("") String name,
    @Default("") String country,
    @Default("") String address,
    @Default("") String description,
    @Default(0) int number,
    @Default("") String userCreatedName,
    @Default("") String createdAt,
    @Default("") String userUpdatedName,
    @Default("") String updatedAt,
    @Default("") String company,
  }) = _ProductCompanyEntity;
}
