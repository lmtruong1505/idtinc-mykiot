import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_count_model.freezed.dart';
part 'order_count_model.g.dart';

@freezed
class OrderCountModel with _$OrderCountModel {
  const OrderCountModel._();

  const factory OrderCountModel({
    int? draft,
    @JsonKey(name: 'in_process')
    int? inProcess,
    int? complete,
    int? cancel,
    int? service,
    int? product,
  }) = _OrderCountModel;

  factory OrderCountModel.fromJson(Map<String, dynamic> json) => _$OrderCountModelFromJson(json);
}
