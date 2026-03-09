import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/warehouse/domain/repositories/warehouse_repository.dart';

import '../entities/warehouse_payload_entity.dart';

@injectable
class WarehouseUpdateUseCase
    extends BaseFutureUseCase<WarehouseUpdateInput, WarehouseUpdateOutput> {
  WarehouseUpdateUseCase(this._warehouseRepository);
  final WarehouseRepository _warehouseRepository;

  @override
  Future<WarehouseUpdateOutput> buildUseCase(WarehouseUpdateInput input) async {
    final res = await _warehouseRepository.update(
      id: input.id,
      payload: input.payload.toJson(),
    );
    final output = WarehouseUpdateOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: res.data,
      ),
    );
    return output;
  }
}

class WarehouseUpdateInput extends BaseInput {
  final int id;
  final WarehousePayloadEntity payload;
  WarehouseUpdateInput({
    required this.id,
    required this.payload,
  });
}

class WarehouseUpdateOutput extends BaseOutput {
  final BaseResponseModel<int> response;
  WarehouseUpdateOutput({required this.response});
}
