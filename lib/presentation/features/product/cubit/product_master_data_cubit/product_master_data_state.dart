import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_master_data_state.freezed.dart';

@freezed
class ProductMasterDataState with _$ProductMasterDataState {
  const factory ProductMasterDataState({
    @Default(false) bool isLoading,
    @Default(20) int limit,
    @Default('') String search,
  }) = _ProductMasterDataState;
}
