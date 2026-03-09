

import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/debt/data/models/debt_note_model.dart';
import 'package:pharmago/presentation/features/debt/domain/entities/debt_note_entity.dart';

@injectable
class EntityEntityMapper extends BaseDataMapper<EntityModel, EntityEntity> {
  @override
  EntityEntity mapToEntity(EntityModel? data) {
    return EntityEntity(
      id: data?.id,
      code: data?.code,
      name: data?.name,
    );
  }
}
