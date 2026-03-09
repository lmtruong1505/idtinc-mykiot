import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/authentication/data/mapper/account_entity_mapper.dart';
import 'package:pharmago/presentation/features/customer/data/models/medical_record_model.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/medical_record_entity.dart';
import 'package:pharmago/presentation/features/product/data/mapper/variant_entity_mapper.dart';

@injectable
class MedicalRecordMapper
    extends BaseDataMapper<MedicalRecordModel, MedicalRecordEntity> {

      MedicalRecordMapper(this._accountEntityMapper, this._variantEntityMapper);

      final AccountEntityMapper _accountEntityMapper;
      final VariantEntityMapper _variantEntityMapper;

  @override
  MedicalRecordEntity mapToEntity(MedicalRecordModel? data) {
    return MedicalRecordEntity(
      id: data?.id,
      code: data?.code,
      customer: data?.customer,
      weight: data?.weight,
      long: data?.long,
      symptom: data?.symptom,
      diagnostic: data?.diagnostic,
      result: data?.result,
      doctor: _accountEntityMapper.mapToEntity(data?.doctor),
      reExamination: data?.reExamination,
      note: data?.note,
      variants: _variantEntityMapper.mapToListEntity(data?.variants),
      createdAt: DateTime.parse(data?.createdAt ?? ''),
      updatedAt: DateTime.parse(data?.updatedAt ?? ''),
      userCreated: _accountEntityMapper.mapToEntity(data?.userCreated),
    );
  }
}
