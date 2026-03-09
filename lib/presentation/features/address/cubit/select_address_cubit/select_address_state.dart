import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_item_entity.dart';

part 'select_address_state.freezed.dart';

@freezed
class SelectAddressState with _$SelectAddressState {
  const factory SelectAddressState({
    @Default(false) bool isLoading,
    @Default(<AddressItemEntity>[]) List<AddressItemEntity> listAddress,
    AddressItemEntity? province,
    AddressItemEntity? district,
    AddressItemEntity? ward,
    @Default('') String detail,
  }) = _SelectAddressState;
}

enum AddressUnit {
  province,
  district,
  ward,
}
