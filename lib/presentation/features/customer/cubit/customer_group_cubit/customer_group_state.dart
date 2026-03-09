import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_group_state.freezed.dart';

@freezed
class CustomerGroupState with _$CustomerGroupState {
  const factory CustomerGroupState({
    @Default('') String search,
    @Default(false) bool isLoading,
    @Default(10) int limit,
  }) = _CustomerGroupState;
}
