import 'package:injectable/injectable.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../entities/ingredient_payload_entity.dart';
import '../entities/product_payload_entity.dart';
import '../entities/unit_payload_entity.dart';
import '../entities/variant_payload_entity.dart';
import '../repositories/product_repository.dart';


@injectable
class ProductUpdateUseCase
    extends BaseFutureUseCase<ProductUpdateInput, ProductUpdateOutput> {
  ProductUpdateUseCase(
      this._productRepository,
      );
  final ProductRepository _productRepository;
  @override
  Future<ProductUpdateOutput> buildUseCase(ProductUpdateInput input) async {
    final res = await _productRepository.updateProduct(
      id: input.id,
      product: input.payload.toJson(),
      unit: input.unitPayloadEntity.toJson(),
      variant: input.variantsPayload?.map((e) => e.toJson()).toList() ?? [],
      unitChange:
      input.unitChangePayloadEntity?.map((e) => e.toJson()).toList(),
      ingredients: input.ingredientPayload?.map((e) => e.toJson()).toList(),
    );
    final output = ProductUpdateOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: res.data,
      ),
    );
    return output;
  }
}

class ProductUpdateInput extends BaseInput {
  final int id;
  final ProductPayloadEntity payload;
  final UnitPayloadEntity unitPayloadEntity;
  final List<UnitChangePayloadEntity>? unitChangePayloadEntity;
  final List<VariantPayloadEntity>? variantsPayload;
  final List<IngredientPayloadEntity>? ingredientPayload;
  ProductUpdateInput({
    required this.id,
    required this.payload,
    required this.unitPayloadEntity,
    required this.variantsPayload,
    this.unitChangePayloadEntity,
    this.ingredientPayload,
  });
}

class ProductUpdateOutput extends BaseOutput {
  final BaseResponseModel response;
  ProductUpdateOutput({required this.response});
}
