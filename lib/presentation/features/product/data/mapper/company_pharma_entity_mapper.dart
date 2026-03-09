

import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';

import '../../domain/entities/company_pharma_entity.dart';
import '../models/company_pharma_model.dart';

@injectable
class CompanyPharmaEntityMapper extends BaseDataMapper<CompanyPharmaModel, CompanyPharmaEntity> {
  @override
  CompanyPharmaEntity mapToEntity(CompanyPharmaModel? data) {
    return CompanyPharmaEntity(
      id: data?.id,
      name: data?.name,
      code: data?.code,
      address: data?.address,
      country: data?.country,
      type: data?.type,
    );
  }
}
