import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/product_company/domain/entities/product_company_entity.dart';

part 'product_company_state.freezed.dart';

@freezed
class ProductCompanyState with _$ProductCompanyState {
  const factory ProductCompanyState({
    @Default('') String search,
    @Default(0) int total,
    @Default(ProductCompanyEntity()) ProductCompanyEntity item,
  }) = _ProductCompanyState;
}
