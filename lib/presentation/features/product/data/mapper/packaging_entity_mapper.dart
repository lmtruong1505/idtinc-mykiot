import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/product/data/models/packaging_model.dart';
import 'package:pharmago/presentation/features/product/domain/entities/packaging_entity.dart';

@injectable
class PackagingEntityMapper
    extends BaseDataMapper<PackagingModel, PackagingEntity> {
  @override
  PackagingEntity mapToEntity(PackagingModel? data) {
    return PackagingEntity(
      parentType: PackageTypeEntity(
        id: data?.parentTypeData?.id,
        title: data?.parentTypeData?.title,
      ),
      childType: PackageTypeEntity(
        id: data?.childTypeData?.id,
        title: data?.childTypeData?.title,
      ),
      childPackaging: data?.childPackagingData == null
          ? null
          : PackagingEntityMapper().mapToEntity(data?.childPackagingData),
      quantity: data?.quantity ?? 0,
      product: data?.product,
      code: data?.code,
    );
  }
}
