import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/product/domain/entities/ingredient_payload_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/product_payload_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/unit_payload_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_payload_entity.dart';
import 'package:pharmago/presentation/features/product/domain/repositories/product_repository.dart';

@injectable
class ProductCreateUseCase
    extends BaseFutureUseCase<ProductCreateInput, ProductCreateOutput> {
  ProductCreateUseCase(
    this._productRepository,
  );
  final ProductRepository _productRepository;
  @override
  Future<ProductCreateOutput> buildUseCase(ProductCreateInput input) async {
    final res = await _productRepository.createProduct(
      product: input.payload.toJson(),
      unit: input.unitPayloadEntity.toJson(),
      variant: input.variantsPayload?.map((e) => e.toJson()).toList() ?? [],
      unitChange:
          input.unitChangePayloadEntity?.map((e) => e.toJson()).toList(),
      ingredients: input.ingredientPayload?.map((e) => e.toJson()).toList(),
    );
    final output = ProductCreateOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: res.data,
      ),
    );
    return output;
  }
}

class ProductCreateInput extends BaseInput {
  final ProductPayloadEntity payload;
  final UnitPayloadEntity unitPayloadEntity;
  final List<UnitChangePayloadEntity>? unitChangePayloadEntity;
  final List<VariantPayloadEntity>? variantsPayload;
  final List<IngredientPayloadEntity>? ingredientPayload;
  ProductCreateInput({
    required this.payload,
    required this.unitPayloadEntity,
    required this.variantsPayload,
    this.unitChangePayloadEntity,
    this.ingredientPayload,
  });
}

class ProductCreateOutput extends BaseOutput {
  final BaseResponseModel<int> response;
  ProductCreateOutput({required this.response});
}
