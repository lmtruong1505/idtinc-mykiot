import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/company/data/mapper/company_mapper.dart';
import 'package:pharmago/presentation/features/product/data/mapper/variant_entity_mapper.dart';
import 'package:pharmago/presentation/features/report/data/models/home_report_model.dart';
import 'package:pharmago/presentation/features/report/domain/entities/home_report_entity.dart';

@injectable
class HomeReportMapper
    extends BaseDataMapper<HomeReportModel, HomeReportEntity> {
  HomeReportMapper(
    this._companyMapper,
    this._variantEntityMapper,
  );
  final CompanyMapper _companyMapper;
  final VariantEntityMapper _variantEntityMapper;

  @override
  HomeReportEntity mapToEntity(HomeReportModel? data) {
    return HomeReportEntity(
      company: _companyMapper.mapToEntity(data?.company),
      revenue: data?.revenue ?? 0,
      ordersComplete: data?.ordersComplete ?? 0,
      variantBestSale: _variantEntityMapper.mapToListEntity(
        data?.variantBestSale,
      ),
    );
  }
}
