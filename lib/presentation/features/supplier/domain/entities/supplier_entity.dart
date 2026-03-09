import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';

part 'supplier_entity.freezed.dart';

@freezed
class SupplierEntity with _$SupplierEntity {
  const SupplierEntity._();

  const factory SupplierEntity({
    int? id,
    @Default("") String code,
    @Default("") String name,
    @Default("") String deputyName,
    @Default("") String phone,
    @Default("") String email,
    @Default("") String company,
    AddressEntity? address,
  }) = _SupplierEntity;
}
