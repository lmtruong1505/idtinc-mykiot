import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/customer/domain/repositories/medical_record_repository.dart';

import '../entities/medical_record_payload.dart';

@injectable
class MedicalRecordCreateUseCase
    extends BaseFutureUseCase<MedicalRecordCreateInput, MedicalRecordCreateOutput> {
  MedicalRecordCreateUseCase(
    this._medicalRecordRepository,
  );

  final MedicalRecordRepository _medicalRecordRepository;

  @override
  Future<MedicalRecordCreateOutput> buildUseCase(
    MedicalRecordCreateInput input,
  ) async {
    final res = await _medicalRecordRepository.create(input.payload.toJson());
    return MedicalRecordCreateOutput(
      BaseResponseModel(
        code: res.code,
        message: res.message,
        data: res.data,
      ),
    );
  }
}

class MedicalRecordCreateInput extends BaseInput {
  final MedicalRecordPayloadEntity payload;
  MedicalRecordCreateInput({
    required this.payload,
  });
}

class MedicalRecordCreateOutput extends BaseOutput {
  final BaseResponseModel<int> response;
  MedicalRecordCreateOutput(this.response);
}
