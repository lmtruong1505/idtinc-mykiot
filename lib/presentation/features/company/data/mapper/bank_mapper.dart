import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/company/data/models/bank_model.dart';
import 'package:pharmago/presentation/features/company/domain/entities/bank_entity.dart';

@injectable
class BankMapper extends BaseDataMapper<BankModel, BankEntity> {
  @override
  BankEntity mapToEntity(BankModel? data) {
    return BankEntity(
      id: data?.id ?? 0,
      name: data?.name ?? '',
      code: data?.code ?? '',
      bin: data?.bin ?? '',
      logo: data?.logo ?? '',
      shortName: data?.shortName ?? '',
    );
  }

}