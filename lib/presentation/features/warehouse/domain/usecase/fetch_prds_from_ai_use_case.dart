import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/product_ai_model.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/receipt_import_detail_model.dart';
import 'package:pharmago/presentation/features/warehouse/domain/repositories/warehouse_repository.dart';

@injectable
class FetchPrdsFromAIUseCase
    extends BaseFutureUseCase<FetchPrdsFromAIInput, FetchPrdsToAIOutput> {
  final WarehouseRepository _repository;

  FetchPrdsFromAIUseCase(this._repository);
  @override
  Future<FetchPrdsToAIOutput> buildUseCase(FetchPrdsFromAIInput input) async {
    final res = await _repository.getProductsFromAI(input);
    return FetchPrdsToAIOutput(response: res);
  }
}

class FetchPrdsFromAIInput extends BaseInput {
  final int workspaceId;
  final List<XFile> imgs;

  FetchPrdsFromAIInput({required this.workspaceId, required this.imgs});
}

class FetchPrdsToAIOutput extends BaseOutput {
  final BaseResponseModel<List<ProductAIModel>> response;

  FetchPrdsToAIOutput({required this.response});
}
