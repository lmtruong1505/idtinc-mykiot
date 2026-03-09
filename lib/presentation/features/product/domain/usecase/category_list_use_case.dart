import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';

import '../../data/mapper/category_enitty_mapper.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

@injectable
class CategoryListUseCase
    extends BaseFutureUseCase<CategoryListInput, CategoryListOutput> {
  CategoryListUseCase(
    this._categoryRepository,
    this._categoryEntityMapper,
  );
  final CategoryRepository _categoryRepository;
  final CategoryEntityMapper _categoryEntityMapper;

  @override
  Future<CategoryListOutput> buildUseCase(CategoryListInput input) async {
    final res = await _categoryRepository.getList(
      search: input.search,
      limit: input.limit,
      page: input.page,
      company: input.company,
    );
    final dataEntity = _categoryEntityMapper.mapToListEntity(res.data);
    final output = CategoryListOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
    return output;
  }
}

class CategoryListInput extends BaseInput {
  final int? company;
  final String? search;
  final int? page;
  final int? limit;

  CategoryListInput({
    this.company,
    this.limit,
    this.page,
    this.search,
  });
}

class CategoryListOutput extends BaseOutput {
  final BaseResponseModel<List<CategoryEntity>> response;
  CategoryListOutput({required this.response});
}
