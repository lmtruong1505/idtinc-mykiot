import 'package:pharmago/presentation/features/product/data/models/product_detail_model.dart';

import '../../../../../data/models/base/response.dart';
import '../../data/models/basic_model.dart';
import '../../data/models/company_pharma_model.dart';
import '../../data/models/packaging_model.dart';
import '../../data/models/product_model.dart';

abstract class
ProductRepository {
  Future<BaseResponseModel<List<ProductModel>>> getProductLibrary({
    required String search,
    required int limit,
    required int page,
    required int? company,
  });

  Future<BaseResponseModel<List<ProductModel>>> getProducts({
    required String search,
    required int limit,
    required int page,
    required int? company,
    int? brand,
    bool? active,
  });

  Future<BaseResponseModel> deleteProduct({
    required int id,
  });


  Future<BaseResponseModel<List<PackagingModel>>> getPackaging({
    required int idProduct,
  });

  Future<BaseResponseModel<ProductDetailModel>> getDetail({
    required int id,
  });

  Future<BaseResponseModel<int>> createProduct({
    required Map<String, dynamic> product,
    required Map<String, dynamic> unit,
    required List<Map<String, dynamic>> variant,
    List<Map<String, dynamic>>? unitChange,
    List<Map<String, dynamic>>? ingredients,
  });

  Future<BaseResponseModel<int>> updateProduct({
    required int id,
    required Map<String, dynamic> product,
    required Map<String, dynamic> unit,
    required List<Map<String, dynamic>> variant,
    List<Map<String, dynamic>>? unitChange,
    List<Map<String, dynamic>>? ingredients,
  });

  Future<BaseResponseModel<List<BasicModel>>> getListClassify({
    required String? search,
    required int? limit,
    required int? page,
  });

  Future<BaseResponseModel<List<BasicModel>>> getListPreparationType({
    required String? search,
    required int? limit,
    required int? page,
  });

  Future<BaseResponseModel<List<BasicModel>>> getListProductionStandard({
    required String? search,
    required int? limit,
    required int? page,
  });

  Future<BaseResponseModel<List<CompanyPharmaModel>>> getListCompanyPharma({
    required String? search,
    required int? limit,
    required int? page,
    required String? type,
  });

  Future<BaseResponseModel<List<String>>> getBanner({
    required String typeBanner,
  });
}