

import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/product/data/models/basic_model.dart';
import 'package:pharmago/presentation/features/product/domain/entities/basic_entity.dart';

@injectable
class BasicEntityMapper extends BaseDataMapper<BasicModel, BasicEntity> {
  @override
  BasicEntity mapToEntity(BasicModel? data) {
    return BasicEntity(
      id: data?.id,
      name: data?.name,
      code: data?.code,
    );
  }
}
