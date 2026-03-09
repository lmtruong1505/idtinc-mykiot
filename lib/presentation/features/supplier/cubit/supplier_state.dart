import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/supplier/domain/entities/supplier_entity.dart';

part 'supplier_state.freezed.dart';

@freezed
class SupplierState with _$SupplierState {
  const factory SupplierState({
    @Default('') String search,
    @Default(0) int total,
    @Default(SupplierEntity()) SupplierEntity supplier,
  }) = _SupplierState;
}
