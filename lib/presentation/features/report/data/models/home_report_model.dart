import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/company/data/models/company_model.dart';

import '../../../product/data/models/variant_model.dart';

part 'home_report_model.freezed.dart';
part 'home_report_model.g.dart';

@freezed
class HomeReportModel with _$HomeReportModel {
  const HomeReportModel._();

  const factory HomeReportModel({
    CompanyModel? company,
    @JsonKey(name: 'order_complete')
    int? ordersComplete,
    double? revenue,
    @JsonKey(name: 'variant_best_sale')
    List<VariantModel>? variantBestSale,
  }) = _HomeReportModel;

  factory HomeReportModel.fromJson(Map<String, dynamic> json) => _$HomeReportModelFromJson(json);
}