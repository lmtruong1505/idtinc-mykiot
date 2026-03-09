import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/customer_entity.dart';

part 'selection_customer_state.freezed.dart';

@freezed
class SelectionCustomerState with _$SelectionCustomerState {
  const factory SelectionCustomerState({
    @Default(<CustomerEntity>[]) List<CustomerEntity> customers,
  }) = _SelectionCustomerState;
}
