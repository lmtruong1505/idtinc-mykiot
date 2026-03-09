import 'package:injectable/injectable.dart';

import '../../../../../data/mapper/base/data_mapper.dart';
import '../../domain/entities/category_entity.dart';
import '../models/category_model.dart';

@injectable
class CategoryEntityMapper extends BaseDataMapper<CategoryModel, CategoryEntity> {
  @override
  CategoryEntity mapToEntity(CategoryModel? data) {
    return CategoryEntity(
      id: data?.id,
      name: data?.name,
      code: data?.code,
      company: data?.company,
      updatedAt: data?.updatedAt,
      createdAt: data?.createdAt,
      userCreated: data?.userCreated,
      userUpdated: data?.userUpdated,
      description: data?.description,
    );
  }
}