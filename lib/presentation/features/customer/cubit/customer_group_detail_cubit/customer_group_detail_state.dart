import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/customer_group_entity.dart';

part 'customer_group_detail_state.freezed.dart';

@freezed
class CustomerGroupDetailState with _$CustomerGroupDetailState{
  const factory CustomerGroupDetailState({
    @Default(false) bool isLoading,
    CustomerGroupEntity? customerGroup,
  }) = _CustomerGroupDetailState;
}
