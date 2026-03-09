import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/register_company/domain/entities/register_company_entity.dart';

part 'register_company_state.freezed.dart';

@freezed
class RegisterCompanyState with _$RegisterCompanyState {
  const factory RegisterCompanyState({
    @Default('') String search,
    @Default(0) int total,
    @Default(RegisterCompanyEntity()) RegisterCompanyEntity item,
  }) = _RegisterCompanyState;
}
