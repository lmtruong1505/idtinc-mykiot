import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/medical_record_entity.dart';
import 'package:pharmago/presentation/features/customer/domain/repositories/medical_record_repository.dart';

import '../../data/mapper/medical_record_mapper.dart';

@injectable
class MedicalRecordDetailUseCase
    extends BaseFutureUseCase<MedicalRecordDetailInput, MedicalRecordDetailOutput> {
  MedicalRecordDetailUseCase(
    this._medicalRecordRepository,
    this._medicalRecordMapper,
  );

  final MedicalRecordRepository _medicalRecordRepository;
  final MedicalRecordMapper _medicalRecordMapper;

  @override
  Future<MedicalRecordDetailOutput> buildUseCase(
    MedicalRecordDetailInput input,
  ) async {
    final res = await _medicalRecordRepository.getDetail(input.id);
    final dataEntity = _medicalRecordMapper.mapToEntity(res.data);
    return MedicalRecordDetailOutput(
      BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
  }
}

class MedicalRecordDetailInput extends BaseInput {
  final int id;
  MedicalRecordDetailInput({
    required this.id,
  });
}

class MedicalRecordDetailOutput extends BaseOutput {
  final BaseResponseModel<MedicalRecordEntity> response;
  MedicalRecordDetailOutput(this.response);
}
