import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../company/domain/entities/company_entity.dart';
import '../../../product/domain/entities/variant_entity.dart';


part 'home_report_entity.freezed.dart';

@freezed
class HomeReportEntity with _$HomeReportEntity {
  const HomeReportEntity._();

  const factory HomeReportEntity({
    CompanyEntity? company,
    @Default(0) int ordersComplete,
    @Default(0) double revenue,
    List<VariantEntity>? variantBestSale,
  }) = _HomeReportEntity;

}