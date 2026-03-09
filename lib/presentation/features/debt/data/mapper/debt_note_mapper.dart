import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/debt/data/mapper/entity_mapper.dart';
import 'package:pharmago/presentation/features/debt/screens/debt_list_page.dart';

import '../../../../../data/mapper/base/data_mapper.dart';
import '../../domain/entities/debt_note_entity.dart';
import '../models/debt_note_model.dart';
import 'repayment_mapper.dart';

@injectable
class DebtNoteMapper extends BaseDataMapper<DebtNoteModel, DebtNoteEntity> {
  DebtNoteMapper(this._repaymentMapper, this._entityMapper);
  final RepaymentMapper _repaymentMapper;
  final EntityEntityMapper _entityMapper;

  @override
  DebtNoteEntity mapToEntity(DebtNoteModel? data) {
    return DebtNoteEntity(
      id: data?.id,
      code: data?.code,
      title: data?.title,
      entity: _entityMapper.mapToEntity(data?.entity),
      money: data?.money,
      paymented: data?.paymented,
      note: data?.note,
      type: data?.type,
      status: data?.status,
      company: data?.company,
      userCreated: data?.userCreated,
      exprise: data?.exprise,
      debtNoteAt: data?.debtNoteAt,
      repayments: _repaymentMapper.mapToListEntity(data?.repayments),
      userCreatedName: data?.userCreatedName,
      statusData: DebtNoteStatus.values.firstWhere((e) => e.code == data?.status),
    );
  }
}
