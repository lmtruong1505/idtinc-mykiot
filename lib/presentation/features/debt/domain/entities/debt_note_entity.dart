import 'package:freezed_annotation/freezed_annotation.dart';

import '../../screens/debt_list_page.dart';

part 'debt_note_entity.freezed.dart';

@freezed
class DebtNoteEntity with _$DebtNoteEntity {
  const DebtNoteEntity._();

  factory DebtNoteEntity({
    @Required() int? id,
    @Required() String? code,
    @Required() String? title,
    @Required() EntityEntity? entity,
    @Required() int? money,
    @Required() int? paymented,
    @Required() String? note,
    @Required() String? type,
    @Required() String? status,
    @Required() DebtNoteStatus? statusData,
    @Required() int? company,
    @Required() int? userCreated,
    @Required() DateTime? exprise,
    @Required() DateTime? debtNoteAt,
    @Required() String? userCreatedName,
    @Required() List<RepaymentEntity>? repayments,
  }) = _DebtNoteEntity;
}

@freezed
class RepaymentEntity with _$RepaymentEntity {
  const RepaymentEntity._();

  factory RepaymentEntity({
    @Required() int? id,
    @Required() String? code,
    @Required() int? money,
    @Required() int? debt,
    @Required() int? userCreated,
    @Required() String? userCreatedName,
    @Required() DateTime? createdAt,
  }) = _RepaymentEntity;
}

@freezed
class EntityEntity with _$EntityEntity {
  const EntityEntity._();

  factory EntityEntity({
    int? id,
    String? code,
    String? name,
  }) = _EntityEntity;
}
