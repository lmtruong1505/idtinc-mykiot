

import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/warehouse_payload_entity.dart';

import '../repositories/warehouse_repository.dart';

@injectable
class WarehouseCreateUsecase extends BaseFutureUseCase<WarehouseCreateInput, WarehouseCreateOutput> {
  WarehouseCreateUsecase(this._warehouseRepository);
  final WarehouseRepository _warehouseRepository;
  
  @override
  Future<WarehouseCreateOutput> buildUseCase(WarehouseCreateInput input) async {
    final res = await _warehouseRepository.create(input.payload.toJson());
    final output = WarehouseCreateOutput(
      response: res,
    );
    return output;
  }
}

class WarehouseCreateInput extends BaseInput {
  final WarehousePayloadEntity payload;
  WarehouseCreateInput({required this.payload});
}

class WarehouseCreateOutput extends BaseOutput {
  final BaseResponseModel<int> response;
  WarehouseCreateOutput({required this.response});
}