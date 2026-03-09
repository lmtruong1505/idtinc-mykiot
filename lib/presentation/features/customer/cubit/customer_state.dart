import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/customer_entity.dart';

part 'customer_state.freezed.dart';

@freezed
class CustomerState with _$CustomerState {
  const factory CustomerState({
    @Default('') String search,
    @Default(0) int total,
    @Default(CustomerEntity()) CustomerEntity customer,
    CustomerEntity? dataSelected,
  }) = _CustomerState;
}
