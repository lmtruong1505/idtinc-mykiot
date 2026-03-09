import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/product/data/models/basic_model.dart';
import 'package:pharmago/presentation/features/product/data/models/company_pharma_model.dart';
import 'package:pharmago/presentation/features/product/data/models/packaging_model.dart';
import 'package:pharmago/presentation/features/product/data/models/product_detail_model.dart';
import 'package:pharmago/presentation/features/product/data/models/product_model.dart';

import '../../../../../data/apis/end_point.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/count_model.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl extends ProductRepository {
  ProductRepositoryImpl(this._dio);

  final BaseDio _dio;

  @override
  Future<BaseResponseModel<List<ProductModel>>> getProductLibrary({
    required String search,
    required int limit,
    required int page,
    required int? company,
  }) async {
    try {
      final res = await _dio.get(
        Api.product,
        data: {
          'page': page,
          'limit': limit,
          'search': search,
          ...(company == null ? {} : {'company': company}),
        },
      );
      final data = (res.data['details'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      print(e);
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<List<ProductModel>>> getProducts({
    required String search,
    required int limit,
    required int page,
    required int? company,
    int? brand,
    bool? active,
  }) async {
    try {
      final query = {
        'page': page,
        'limit': limit,
        'company': company,
        'search': search,
        'brand': brand,
        'active': active,
      };
      query.removeWhere((key, value) => value == '' || value == null);
      final res = await _dio.get('${Api.product}/list', data: query);
      final counts = (res.data['count'] as List)
          .map((e) => CountModel.fromJson(e))
          .toList();
      if (res.data['details'] == null) {
        return BaseResponseModel(
          code: res.data['code'],
          message: res.data['message'],
          extra: counts,
        );
      }
      final data = (res.data['details'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
        extra: counts,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<List<PackagingModel>>> getPackaging({
    required int idProduct,
  }) async {
    try {
      final res = await _dio.get(Api.brand, data: {'product': idProduct});
      final data = (res.data['details'] as List)
          .map((e) => PackagingModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<ProductDetailModel>> getDetail(
      {required int id}) async {
    try {
      final res = await _dio.get('${Api.productDetail}$id');
      final data = ProductDetailModel.fromJson(res.data['details']);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<int>> createProduct({
    required Map<String, dynamic> product,
    required Map<String, dynamic> unit,
    required List<Map<String, dynamic>> variant,
    List<Map<String, dynamic>>? unitChange,
    List<Map<String, dynamic>>? ingredients,
  }) async {
    try {
      final payload = {
        'product': product,
        'unit': unit,
        'unitChanges': unitChange,
        'variants': variant,
        'ingredients': ingredients,
      };
      final res = await _dio.post('${Api.product}/create', data: payload);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['details'],
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<List<BasicModel>>> getListClassify({
    required String? search,
    required int? limit,
    required int? page,
  }) async {
    try {
      final query = {
        'page': page,
        'limit': limit,
        'search': search,
      };
      query.removeWhere((key, value) => value == null || value == '');
      final res = await _dio.get('${Api.classify}/list', data: query);
      final data = (res.data['details'] as List?)
          ?.map((e) => BasicModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<List<BasicModel>>> getListPreparationType({
    required String? search,
    required int? limit,
    required int? page,
  }) async {
    try {
      final query = {
        'page': page,
        'limit': limit,
        'search': search,
      };
      query.removeWhere((key, value) => value == null || value == '');
      final res = await _dio.get('${Api.preparationType}/list', data: query);
      final data = (res.data['details'] as List?)
          ?.map((e) => BasicModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<List<BasicModel>>> getListProductionStandard({
    required String? search,
    required int? limit,
    required int? page,
  }) async {
    try {
      final query = {
        'page': page,
        'limit': limit,
        'search': search,
      };
      query.removeWhere((key, value) => value == null || value == '');
      final res = await _dio.get('${Api.productionStandard}/list', data: query);
      final data = (res.data['details'] as List?)
          ?.map((e) => BasicModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<List<CompanyPharmaModel>>> getListCompanyPharma({
    required String? search,
    required int? limit,
    required int? page,
    required String? type,
  }) async {
    try {
      final query = {
        'page': page,
        'limit': limit,
        'search': search,
        'type': type,
      };
      query.removeWhere((key, value) => value == null || value == '');
      final res = await _dio.get('${Api.companyPharma}', data: query);
      final data = (res.data['details'] as List?)
          ?.map((e) => CompanyPharmaModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<int>> updateProduct({
    required int id,
    required Map<String, dynamic> product,
    required Map<String, dynamic> unit,
    required List<Map<String, dynamic>> variant,
    List<Map<String, dynamic>>? unitChange,
    List<Map<String, dynamic>>? ingredients,
  }) async {
    try {
      final payload = {
        'product': product,
        'unit': unit,
        'unitChanges': unitChange,
        'variants': variant,
        'ingredients': ingredients,
      };
      final res = await _dio.put('${Api.product}/detail/$id', data: payload);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['details'],
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel> deleteProduct({required int id}) async {
    try {
      final res = await _dio.delete('${Api.product}/detail/$id');
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['details'],
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<List<String>>> getBanner({
    required String typeBanner,
  }) async {
    try {
      final params = {
        'type_banner': typeBanner,
      };
      final res = await _dio.get('${Api.product}/banner', data: params);
      final data = (res.data['data'] as List)
          .map(
            (e) => e['image'] as String,
          )
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
