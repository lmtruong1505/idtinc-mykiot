import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/customer/data/mapper/medical_record_mapper.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/medical_record_entity.dart';
import 'package:pharmago/presentation/features/customer/domain/repositories/medical_record_repository.dart';

@injectable
class MedicalRecordListUseCase
    extends BaseFutureUseCase<MedicalRecordListInput, MedicalRecordListOutput> {
  MedicalRecordListUseCase(
      this._medicalRecordMapper, this._medicalRecordRepository);

  final MedicalRecordRepository _medicalRecordRepository;
  final MedicalRecordMapper _medicalRecordMapper;

  @override
  Future<MedicalRecordListOutput> buildUseCase(
    MedicalRecordListInput input,
  ) async {
    final res = await _medicalRecordRepository.getList(
      customer: input.customer,
      search: input.search,
      page: input.page,
      limit: input.limit,
    );
    final dataEntity = _medicalRecordMapper.mapToListEntity(res.data);
    return MedicalRecordListOutput(
      BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
  }
}

class MedicalRecordListInput extends BaseInput {
  final int customer;
  final String? search;
  final int? page;
  final int? limit;
  MedicalRecordListInput({
    required this.customer,
    this.limit,
    this.page,
    this.search,
  });
}

class MedicalRecordListOutput extends BaseOutput {
  final BaseResponseModel<List<MedicalRecordEntity>> response;
  MedicalRecordListOutput(this.response);
}
