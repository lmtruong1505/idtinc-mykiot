import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';

import '../../../../../domain/usecase/base/future_use_case.dart';
import '../../../../../domain/usecase/base/io/input.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../repositories/category_repository.dart';

@injectable
class CategoryCreateUseCase
    extends BaseFutureUseCase<CategoryCreateInput, CategoryCreateOutput> {
  CategoryCreateUseCase(this._categoryRepository);

  final CategoryRepository _categoryRepository;

  @override
  Future<CategoryCreateOutput> buildUseCase(CategoryCreateInput input) async {
    final res = await _categoryRepository.create(
      name: input.name,
      company: input.company,
      code: input.code,
      description: input.description,
      products: input.products,
    );
    final output = CategoryCreateOutput(response: res);
    return output; 
  }
}

class CategoryCreateInput extends BaseInput {
  final String? code;
  final String name;
  final String? description;
  final List<int>? products;
  final int company;
  CategoryCreateInput({
    required this.company,
    required this.name,
    this.code,
    this.description,
    this.products,
  });
}

class CategoryCreateOutput extends BaseOutput {
  final BaseResponseModel<int> response;
  CategoryCreateOutput({required this.response});
}
