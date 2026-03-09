import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/product/domain/entities/basic_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/brand_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/category_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/company_pharma_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/ingredient_payload_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/product_payload_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/product_type_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_payload_entity.dart';

import '../../domain/entities/unit_payload_entity.dart';

part 'product_create_state.freezed.dart';

@freezed
class ProductCreateState with _$ProductCreateState {
  const factory ProductCreateState({
    @Default(ProductPayloadEntity()) ProductPayloadEntity productPayload,
    @Default(UnitPayloadEntity()) UnitPayloadEntity unitsPayload,
    @Default(<UnitChangePayloadEntity>[])
    List<UnitChangePayloadEntity> unitChangesPayload,
    @Default(<IngredientPayloadEntity>[])
    List<IngredientPayloadEntity> ingredientPayload,
    @Default(<VariantPayloadEntity>[
      VariantPayloadEntity(
        isDefault: true,
      ),
    ])
    List<VariantPayloadEntity> variantsPayload,
    @Default(<File>[]) List<File> imagesProduct,
    BrandEntity? brandSelected,
    CategoryEntity? categorySelected,
    ProductTypeEntity? productTypeEntity,
    BasicEntity? classify,
    BasicEntity? preparationType,
    BasicEntity? productionStandard,
    CompanyPharmaEntity? congTySx,
    CompanyPharmaEntity? congTyDk,
    @Default(false) bool isUpdate,
  }) = _ProductCreateState;
}
