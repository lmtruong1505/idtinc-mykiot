import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/product/domain/entities/basic_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/company_pharma_entity.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/classify_list_use_case.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/company_pharma_list_use_case.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/preparation_type_list_use_case.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/production_standard_list_use_case.dart';

import 'product_master_data_state.dart';

@injectable
class ProductMasterDataCubit extends Cubit<ProductMasterDataState> {
  ProductMasterDataCubit(
    this._classifyListUseCase,
    this._preparationTypeListUseCase,
    this._productionStandardListUseCase,
    this._companyPharmaListUseCase,
  ) : super(const ProductMasterDataState());

  final ClassifyListUseCase _classifyListUseCase;
  final PreparationTypeListUseCase _preparationTypeListUseCase;
  final ProductionStandardListUseCase _productionStandardListUseCase;
  final CompanyPharmaListUseCase _companyPharmaListUseCase;

  void search(String value) {
    emit(state.copyWith(search: value));
  }

  Future<List<BasicEntity>> getListClassify(int page) async {
    final input = ClassifyListInput(
      search: state.search,
      page: page + 1,
      limit: state.limit,
    );
    final res = await _classifyListUseCase.execute(input);
    return res.response.data ?? [];
  }

  Future<List<BasicEntity>> getListPreparationType(int page) async {
    final input = PreparationTypeListInput(
      search: state.search,
      page: page + 1,
      limit: state.limit,
    );
    final res = await _preparationTypeListUseCase.execute(input);
    return res.response.data ?? [];
  }

  Future<List<BasicEntity>> getListProductionStandard(int page) async {
    final input = ProductionStandardListInput(
      search: state.search,
      page: page + 1,
      limit: state.limit,
    );
    final res = await _productionStandardListUseCase.execute(input);
    return res.response.data ?? [];
  }

  Future<List<CompanyPharmaEntity>> getListCompanyPharma(int page, String type) async {
    final input = CompanyPharmaListInput(
      search: state.search,
      page: page + 1,
      limit: state.limit,
      type: type,
    );
    final res = await _companyPharmaListUseCase.execute(input);
    return res.response.data ?? [];
  }
}
