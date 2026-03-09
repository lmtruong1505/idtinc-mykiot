import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features_v2/models/product/create_kafa_order_model.dart';
import 'package:pharmago/presentation/features_v2/models/product/drug_category_model.dart.dart';

@injectable
class DrugCartRepository {
  final BaseDio dio;

  DrugCartRepository({required this.dio});

  Future<BaseResponseModel<List<DrugCategoryModel>>> getCart() async {
    try {
      final res = await dio.get(Api.carts);
      final list = (res.data['data'] as List)
          .map((e) => DrugCategoryModel.fromJson(e))
          .toList();

      if (res.data['code'] == 200) {
        return BaseResponseModel(
          code: res.data['code'],
          message: res.data['message'],
          data: list,
        );
      } else {
        return BaseResponseModel(
          code: res.data['code'],
          message: res.data['message'],
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: null,
      );
    }
  }

  Future<BaseResponseModel> deletePrd({required List<int> ids}) async {
    try {
      final payload = {'product_kafa_id': ids};
      final res = await dio.post(Api.deleteCartPrds, data: payload);

      if (res.data['code'] == 200) {
        return BaseResponseModel(
          code: res.data['code'],
          message: res.data['message'],
        );
      } else {
        return BaseResponseModel(
          code: res.data['code'],
          message: res.data['message'],
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: null,
      );
    }
  }

  Future<BaseResponseModel> updatePrd({int? id, num? quantity}) async {
    try {
      final payload = {
        'product_kafa_id': id,
        'quantity': quantity,
      };
      final res = await dio.post(
        Api.updateProduct,
        data: payload,
      );

      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: null,
      );
    }
  }

  Future<BaseResponseModel> createOrder(CreateOrderKafaModel orderKafa) async {
    try {
      final payload = orderKafa.toJson();
      payload.removeWhere((key, value) => value == null);
      final res = await dio.post(Api.orderKafa, data: payload);

      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: null,
      );
    }
  }

  Future<BaseResponseModel> addPrdToCart({
    required List<DrugProductModel> prds,
  }) async {
    try {
      final payload = prds
          .map((e) => {'product_kafa_id': e.id, 'quantity': e.quantity})
          .toList();
      final res = await dio.post(
        Api.addProductToCart,
        data: payload,
      );

      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: null,
      );
    }
  }
}
