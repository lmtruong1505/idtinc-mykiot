import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../employee/employee/domain/entities/employee_entity.dart';
import '../../domain/entities/brand_entity.dart';
import '../../domain/entities/company_pharma_entity.dart';
import '../../domain/entities/service_payload_entity.dart';


part 'service_create_state.freezed.dart';

@freezed
class ServiceCreateState with _$ServiceCreateState {
  const factory ServiceCreateState({
    @Default(ServicePayloadEntity()) ServicePayloadEntity servicePayload,
    @Default(<File>[]) List<File> imageService,
    EmployeeEntity? staffSelected,
    @Default(false) isActive,
    @Default(false) isUpdate,
    int? id,
    CompanyPharmaEntity? congTySx,
    CompanyPharmaEntity? congTyDk,
    BrandEntity? brandSelected,
  }) = _ServiceCreateState;
}
