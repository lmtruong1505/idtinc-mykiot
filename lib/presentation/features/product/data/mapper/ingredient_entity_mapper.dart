import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/product/data/models/ingredient_model.dart';
import 'package:pharmago/presentation/features/product/domain/entities/ingredient_entity.dart';

@injectable
class IngredientEntityMapper extends BaseDataMapper<IngredientModel, IngredientEntity>{
  @override
  IngredientEntity mapToEntity(IngredientModel? data) {
    return IngredientEntity(
      id: data?.id,
      name: data?.name,
      weight: data?.weight,
      unit: data?.unit,
    );
  }

}