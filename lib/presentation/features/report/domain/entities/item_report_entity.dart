import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_report_entity.freezed.dart';
part 'item_report_entity.g.dart';

@freezed
class ItemReportEntity with _$ItemReportEntity {
  const ItemReportEntity._();

  const factory ItemReportEntity({
    String? title,
    int? value,
    int? valueExtra,
  }) = _ItemReportEntity;

  factory ItemReportEntity.fromJson(Map<String, dynamic> json) =>
      _$ItemReportEntityFromJson(json);
}
