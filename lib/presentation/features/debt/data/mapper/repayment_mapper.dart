import 'package:injectable/injectable.dart';

import '../../../../../data/mapper/base/data_mapper.dart';
import '../../domain/entities/debt_note_entity.dart';
import '../models/debt_note_model.dart';

@injectable
class RepaymentMapper extends BaseDataMapper<RepaymentModel, RepaymentEntity> {
  @override
  RepaymentEntity mapToEntity(RepaymentModel? data) {
    return RepaymentEntity(
      id: data?.id,
      code: data?.code,
      money: data?.money,
      debt: data?.debt,
      userCreated: data?.userCreated,
      userCreatedName: data?.userCreatedName,
      createdAt: data?.createdAt,
    );
  }
}
