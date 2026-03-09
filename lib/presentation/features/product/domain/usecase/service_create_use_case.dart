import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/presentation/features/product/domain/entities/service_payload_entity.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/service_repository.dart';

import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';

@injectable
class ServiceCreateUseCase
    extends BaseFutureUseCase<ServiceCreateInput, ServiceCreateOutput> {

  ServiceCreateUseCase(
    this._serviceRepository,
  );

  final ServiceRepository _serviceRepository;

  @override
  Future<ServiceCreateOutput> buildUseCase(ServiceCreateInput input) async {
    final payload = {
      'code': input.payload.code,
      'title': input.payload.title,
      'entity': input.payload.entity,
      'staff': input.payload.staff,
      'frequency': input.payload.frequency,
      'unit': input.payload.unit,
      'price': input.payload.price,
      'description': input.payload.description,
      'company': input.payload.company,
      'reminderTime': input.payload.reminderTime,
      'brand': input.payload.brand,
      'actionTime': input.payload.actionTime,
      'chiDinh': input.payload.chiDinh,
      'chongChiDinh': input.payload.chongChiDinh,
      'congDung': input.payload.congDung,
      'luuY': input.payload.luuY,
      'hinhThuc': input.payload.hinhThuc,
      'tacDungPhu': input.payload.tacDungPhu,
      'soDangKy': input.payload.soDangKy,
      'soQuyetDinh': input.payload.soQuyetDinh,
      'congTyDk': input.payload.congTyDk,
      'message': input.payload.message,
      'images': input.payload.image,
      'active': input.payload.active,
    };
    payload.removeWhere((key, value) => value == null || value == '');
    final res = await _serviceRepository.createService(service: payload);
    final output = ServiceCreateOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: res.data,
      ),
    );
    return output;
  }

}

class ServiceCreateInput extends BaseInput {
  final ServicePayloadEntity payload;
  ServiceCreateInput({required this.payload});
}

class ServiceCreateOutput extends BaseOutput {
  final BaseResponseModel response;
  ServiceCreateOutput({required this.response});
}
