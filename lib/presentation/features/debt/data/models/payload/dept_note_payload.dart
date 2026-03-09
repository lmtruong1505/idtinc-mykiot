import 'package:freezed_annotation/freezed_annotation.dart';
part 'dept_note_payload.freezed.dart';
part 'dept_note_payload.g.dart';

@freezed
class DebtNotePayload with _$DebtNotePayload {
  const factory DebtNotePayload({
    int? company,
    String? code,
    String? entity,
    String? title,
    String? money,
    String? paymented,
    String? note,
    String? type,
    String? exprise,
    String? createdAt,
  }) = _DebtNotePayload;
  factory DebtNotePayload.fromJson(Map<String, dynamic> json) => _$DebtNotePayloadFromJson(json);
}