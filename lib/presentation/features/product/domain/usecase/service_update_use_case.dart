import 'package:injectable/injectable.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../entities/service_payload_entity.dart';
import '../repositories/service_repository.dart';

@injectable
class ServiceUpdateUseCase
    extends BaseFutureUseCase<ServiceUpdateInput, ServiceUpdateOutput> {
  ServiceUpdateUseCase(
    this._serviceRepository,
  );

  final ServiceRepository _serviceRepository;

  @override
  Future<ServiceUpdateOutput> buildUseCase(ServiceUpdateInput input) async {
    final service = {
      'code': input.service.code,
      'title': input.service.title,
      'entity': input.service.entity,
      'staff': input.service.staff,
      'frequency': input.service.frequency,
      'unit': input.service.unit,
      'price': input.service.price,
      'description': input.service.description,
      'company': input.service.company,
      'reminderTime': input.service.reminderTime,
      'brand': input.service.brand,
      'actionTime': input.service.actionTime,
      'chiDinh': input.service.chiDinh,
      'chongChiDinh': input.service.chongChiDinh,
      'congDung': input.service.congDung,
      'luuY': input.service.luuY,
      'hinhThuc': input.service.hinhThuc,
      'tacDungPhu': input.service.tacDungPhu,
      'soDangKy': input.service.soDangKy,
      'soQuyetDinh': input.service.soQuyetDinh,
      'congTyDk': input.service.congTyDk,
      'message': input.service.message,
      'images': input.service.image,
      'active': input.service.active,
    };
    final res = await _serviceRepository.updateService(service: service, id: input.id);
    final output = ServiceUpdateOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: res.data ?? -1,
      ),
    );
    return output;
  }
}

class ServiceUpdateInput extends BaseInput {

  final int id;
  final ServicePayloadEntity service;

  ServiceUpdateInput({required this.id, required this.service});
}

class ServiceUpdateOutput extends BaseOutput {
  final BaseResponseModel<int> response;

  ServiceUpdateOutput({required this.response});
}
