import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_count_entity.freezed.dart';

@freezed
class OrderCountEntity with _$OrderCountEntity {
  const OrderCountEntity._();

  const factory OrderCountEntity({
    @Default(0) int draft,
    @Default(0) int inProcess,
    @Default(0) int complete,
    @Default(0) int cancel,
    @Default(0) int service,
    @Default(0) int product,
  }) = _OrderCountEntity;
}
