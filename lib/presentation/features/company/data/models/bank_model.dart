
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_model.freezed.dart';
part 'bank_model.g.dart';

@freezed
class BankModel with _$BankModel {
  const BankModel._();

  const factory BankModel({
    int? id,
    String? name,
    String? code,
    String? bin,
    String? logo,
    String? shortName,
  }) = _BankModel;

  factory BankModel.fromJson(Map<String, dynamic> json) => _$BankModelFromJson(json);
}