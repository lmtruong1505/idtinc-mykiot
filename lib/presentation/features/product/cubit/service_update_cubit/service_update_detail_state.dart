import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../employee/employee/domain/entities/employee_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/variant_entity.dart';

part 'service_update_detail_state.freezed.dart';

@freezed
class ServiceUpdateDetailState with _$ServiceUpdateDetailState {
  const factory ServiceUpdateDetailState({
    @Default(false) bool isLoading,
    ServiceEntity? service,
    @Default(<VariantEntity>[]) List<VariantEntity> variants,
    @Default(<VariantEntity>[])
    List<VariantEntity> variantsSearch,
    EmployeeEntity? staffSelected,
    File? imageService,
  }) = _ServiceUpdateDetailState;
}
