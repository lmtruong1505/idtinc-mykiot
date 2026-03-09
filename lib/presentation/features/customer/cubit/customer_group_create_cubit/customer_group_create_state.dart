import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/customer_entity.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/customer_group_entity.dart';

part 'customer_group_create_state.freezed.dart';

@freezed
class CustomerGroupCreateState with _$CustomerGroupCreateState {
  const factory CustomerGroupCreateState({
    @Default(CustomerGroupEntity()) CustomerGroupEntity customerGroup,
    @Default(<CustomerEntity>[]) List<CustomerEntity> customerList,
    @Default(<CustomerEntity>[]) List<CustomerEntity> customerSearchList,
    @Default(false) bool isLoading,
  }) = _CustomerGroupCreateState;
}
