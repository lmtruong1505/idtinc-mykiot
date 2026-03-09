import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/variant_repository.dart';

import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../entities/inventory_voucher_payload_entity.dart';

@injectable
class InventoryVoucherCreateUsecase extends BaseFutureUseCase<
    InventoryVoucherCreateInput, InventoryVoucherCreateOutput> {
  InventoryVoucherCreateUsecase(this._variantRepositoty);

  final VariantRepositoty _variantRepositoty;

  @override
  Future<InventoryVoucherCreateOutput> buildUseCase(
      InventoryVoucherCreateInput input) async {
    final data = input.payload.toPayload();
    final res = await _variantRepositoty.importVariant(data: data);
    final output = InventoryVoucherCreateOutput(
      res,
    );
    return output;
  }
}

class InventoryVoucherCreateInput extends BaseInput {
  final InventoryVoucherPayloadEntity payload;
  InventoryVoucherCreateInput(this.payload);
}

class InventoryVoucherCreateOutput extends BaseOutput {
  final BaseResponseModel response;
  InventoryVoucherCreateOutput(this.response);
}
