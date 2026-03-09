import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_entity.freezed.dart';
part 'bank_entity.g.dart';

@freezed
class BankEntity with _$BankEntity {
  const BankEntity._();

  const factory BankEntity({
     int? id,
     String? name,
    String? code,
     String? bin,
     String? logo,
     String? shortName,
  }) = _BankEntity;

  factory BankEntity.fromJson(Map<String, dynamic> json) => _$BankEntityFromJson(json);
}
