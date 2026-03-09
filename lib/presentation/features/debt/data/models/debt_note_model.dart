

import 'package:freezed_annotation/freezed_annotation.dart';

part 'debt_note_model.freezed.dart';
part 'debt_note_model.g.dart';

@freezed
class DebtNoteModel with _$DebtNoteModel {
  const DebtNoteModel._();

  factory DebtNoteModel({
    int? id,
    String? code,
    String? title,
    EntityModel? entity,
    int? money,
    int? paymented,
    String? note,
    String? type,
    String? status,
    int? company,
    @JsonKey(name: 'user_created')
    int? userCreated,
    DateTime? exprise,
    @JsonKey(name: 'debt_note_at')
    DateTime? debtNoteAt,
    @JsonKey(name: 'user_created_name')
    String? userCreatedName,
    List<RepaymentModel>? repayments,
  }) = _DebtNoteModel;

  factory DebtNoteModel.fromJson(Map<String, dynamic> json) => _$DebtNoteModelFromJson(json);
}

@freezed
class RepaymentModel with _$RepaymentModel {
  const RepaymentModel._();

  factory RepaymentModel({
    int? id,
    String? code,
    int? money,
    int? debt,
    @JsonKey(name: 'user_created')
    int? userCreated,
    @JsonKey(name: 'user_created_name')
    String? userCreatedName,
    @JsonKey(name: 'created_at')
    DateTime? createdAt,
  }) = _RepaymentModel;

  factory RepaymentModel.fromJson(Map<String, dynamic> json) => _$RepaymentModelFromJson(json);
}

@freezed
class EntityModel with _$EntityModel {
  const EntityModel._();

  factory EntityModel({
    int? id,
    String? code,
    String? name,
  }) = _EntityModel;

  factory EntityModel.fromJson(Map<String, dynamic> json) => _$EntityModelFromJson(json);
}