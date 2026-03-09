import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/product/data/models/brand_model.dart';
import 'package:pharmago/presentation/features/product/domain/entities/brand_entity.dart';

@injectable
class BrandEntityMapper extends BaseDataMapper<BrandModel, BrandEntity> {
  @override
  BrandEntity mapToEntity(BrandModel? data) {
    return BrandEntity(
      id: data?.id,
      name: data?.name,
      code: data?.code,
      company: data?.company,
      updatedAt: data?.updatedAt,
      createdAt: data?.createdAt,
      userCreated: data?.userCreated,
      userUpdated: data?.userUpdated,
      description: data?.description,
    );
  }
}
