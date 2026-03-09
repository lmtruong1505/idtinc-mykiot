import 'package:freezed_annotation/freezed_annotation.dart';
part 'order_wm_count_filter_model.freezed.dart';
part 'order_wm_count_filter_model.g.dart';

@freezed
class OrderCountFilterModel with _$OrderCountFilterModel {
  const factory OrderCountFilterModel({
    String? type,
    int? count,
  }) = _OrderCountFilterModel;

  factory OrderCountFilterModel.fromJson(Map<String, dynamic> json) => _$OrderCountFilterModelFromJson(json);
}