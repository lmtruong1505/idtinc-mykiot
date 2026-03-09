import 'package:dio/dio.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/company/cubit/auth_ws_manager_cubit/auth_ws_manager_state.dart';
import 'package:pharmago/presentation/features_v2/models/product/count_v2_model.dart';
import 'package:pharmago/presentation/features_v2/models/product/product_shipments_model.dart';
import 'package:pharmago/presentation/features_v2/models/product/product_v2_model.dart';
import 'package:pharmago/presentation/features_v2/models/product/shipments_infor_model.dart';
import 'package:pharmago/presentation/features_v2/models/product/unit_v2_model.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../data/apis/end_point.dart';
import '../../../../data/models/base/response.dart';
import '../../../features/company/cubit/auth_ws_manager_cubit/auth_ws_manager_cubit.dart';
import '../../../features/product/data/models/basic_model.dart';
import '../../models/product/product_detail_v2_model.dart';

class ProductV2Repository {
  final _dio = getIt.get<BaseDio>();

  Future<BaseResponseModel<List<ProductV2Model>>> products({
    required int company,
    String? search,
    int limit = 10,
    required int page,
    bool? active,
    double? maxPrice,
    double? minPrice,
    int? category,
    int? type,
    int? brand,
    int? customer,
    List<int>? services,
    bool? exchangeable,
  }) async {
    try {
      final payload = {
        'company': company,
        'search': search,
        'limit': limit,
        'page': page,
        'active': active,
        'max_price': maxPrice,
        'min_price': minPrice,
        'category': category,
        'type': type,
        'customer_id': customer,
        'brand': brand,
        'exchangeable': exchangeable,
        'service_ids': services?.fold('', (result, id) {
          result += result != '' ? ',$id' : '$id';
          return result;
        }),
        'type_warehouse__code': getIt.get<AuthWsManagerCubit>().state.typeCodeWarehouse,
      };
      payload.removeWhere((key, value) => value == null || value == '');
      final res = await _dio.get(
        Api.productList,
        data: payload,
      );
      final List<ProductV2Model> list = [];
      for (final json in res.data['details'] ?? []) {
        final model = ProductV2Model.fromJson(json);
        final stock = model.availableStock ?? 0;
        model.unit.sort(
          (a, b) => a.level.validator.compareTo(b.level.validator),
        );
        for (int i = model.unit.length - 1; i >= 0; i--) {
          if (i == model.unit.length - 1) {
            model.unit[i].count = stock;
          } else {
            final rawValue = model.unit[i + 1].value ?? 1;
            final value = rawValue == 0 ? 1 : rawValue;

            model.unit[i].count =
                (model.unit[i + 1].count.validator / value.validator).floor();
          }
        }
        list.add(model);
      }
      final List<CountV2Model> count = [];
      for (final json in res.data['count'] ?? []) {
        count.add(CountV2Model.fromJson(json));
      }
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: list,
        extra: count,
      );
    } catch (e) {
      print('products: $e');
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: [],
      );
    }
  }

  Future<BaseResponseModel<List<ProductV2Model>>> productsKafa({
    required int company,
    String? search,
    int limit = 20,
    required int page,
    bool? active,
    double? maxPrice,
    double? minPrice,
    int? category,
    int? type,
    int? brand,
    int? customer,
    List<int>? services,
  }) async {
    try {
      final payload = {
        // 'company': company,
        'search': search,
        'limit': limit,
        'page': page,
        // 'active': active,
        // 'max_price': maxPrice,
        // 'min_price': minPrice,
        'category': category,
        // 'type': type,
        // 'customer_id': customer,
        // 'brand': brand,
        // 'service_ids': services?.fold('', (result, id) {
        //   result += result != '' ? ',$id' : '$id';
        //   return result;
        // }),
      };
      payload.removeWhere((key, value) => value == null || value == '');
      final res = await _dio.get(
        Api.productKafaList,
        data: payload,
      );
      final List<ProductV2Model> list = [];
      for (final json in res.data['details'] ?? []) {
        final model = ProductV2Model.fromJson(json);
        // final stock = model.availableStock ?? 0;
        // model.unit.sort(
        //   (a, b) => a.level.validator.compareTo(b.level.validator),
        // );
        // for (int i = model.unit.length - 1; i >= 0; i--) {
        //   if (i == model.unit.length - 1) {
        //     model.unit[i].count = stock;
        //   } else {
        //     model.unit[i].count = (model.unit[i + 1].count.validator /
        //             model.unit[i + 1].value.validator)
        //         .floor();
        //   }
        // }
        list.add(model);
      }
      // final List<CountV2Model> count = [];
      // for (final json in res.data['count'] ?? []) {
      //   count.add(CountV2Model.fromJson(json));
      // }
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: list,
        // extra: count,
      );
    } catch (e) {
      print('products: $e');
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: [],
      );
    }
  }

  Future<BaseResponseModel<ProductDetailV2Model>> getDetailProd({
    required int id,
  }) async {
    try {
      final res = await _dio.get(
        '${Api.productDetail}$id',
      );
      final model = ProductDetailV2Model.fromJson(res.data['details']);
      final stock = model.product?.availableStock ?? 0;
      model.product?.unit.sort(
        (a, b) => a.level.validator.compareTo(b.level.validator),
      );

      for (int i = (model.product?.unit ?? []).length - 1; i >= 0; i--) {
        if (i == (model.product?.unit ?? []).length - 1) {
          model.product?.unit[i].count = stock;
        } else {
          final unit = model.product?.unit[i + 1];
          model.product?.unit[i].count =
              ((unit?.count ?? 0) / (unit?.value ?? 0)).floor();
        }
      }
      print(
        model.product?.unit.map(
          (e) => e.count,
        ),
      );
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: model,
      );
    } catch (e) {
      print('getDetailProd: $e');
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: ProductDetailV2Model(),
      );
    }
  }

  Future<BaseResponseModel<List<BasicModel>>> getBasic({
    required ProductBasic type,
  }) async {
    try {
      final payload = {
        'company': getCompany,
      };
      final res = await _dio.get(
        type.endpoint,
        data: payload,
      );
      final List<BasicModel> list = [];
      for (final json in res.data['details'] ?? []) {
        list.add(BasicModel.fromJson(json));
      }
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: list,
      );
    } catch (e) {
      print('getBasic: $e');
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: [],
      );
    }
  }

  Future<BaseResponseModel<int>> create({
    required Map<String, dynamic> payload,
  }) async {
    try {
      final FormData formData = FormData.fromMap(payload);
      final res = await _dio.post(
        '${Api.product}/create',
        data: formData,
      );
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['details'],
      );
    } catch (e) {
      print('create: $e');
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> update({
    required int id,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final FormData formData = FormData.fromMap(payload);
      final res = await _dio.put(
        '${Api.product}/detail/$id',
        data: formData,
      );
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      print('create: $e');
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> delete({
    required int id,
  }) async {
    try {
      final res = await _dio.delete(
        '${Api.product}/detail/$id',
      );
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      print('delete: $e');
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel> warehouseImport({
    required Map<String, dynamic> payload,
  }) async {
    try {
      final res = await _dio.post(
        '${Api.product}/warehouse',
        data: payload,
      );
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  Future<BaseResponseModel<List<ProductV2Model>>> getDonThuoc(
    String code,
  ) async {
    try {
      final res = await _dio.get(
        '${Api.prescription}/find/$code',
      );
      final List<ProductV2Model> list = [];
      for (final json in res.data['details']['items'] ?? []) {
        final prod = ProductV2Model.fromJson(json['product']['product']);
        prod.quantity = json['quantity'];
        prod.unitSell = UnitV2Model.fromJson(json['unit']);
        list.add(prod);
      }
      print('getDonThuoc: ${list.length}');
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: list,
      );
    } catch (e) {
      print('getDonThuoc: $e');
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: [],
      );
    }
  }

  Future<BaseResponseModel<List<ProductShipmentsModel>>> getProdShipments({
    required int id,
  }) async {
    try {
      final res = await _dio.get('${Api.prdShipments}/$id');
      final data = (res.data['data'] as List)
          .map((e) => ProductShipmentsModel.fromJson(e))
          .toList();
      final extra = ShipmentsInforModel.fromJson(res.data['bonus']);
      return BaseResponseModel(
          code: res.data['code'],
          message: res.data['message'],
          data: data,
          extra: extra
          // {
          //   'totalShipments': res.data['bonus']['total_shipment_near_date'],
          //   'quantityNearDate': res.data['bonus']['quantity_near_date'],
          //   'quantityEpx': res.data['bonus']['quantity_exp_date'],
          // },
          );
    } catch (e) {
      print(e);
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: [],
      );
    }
  }

  Future<BaseResponseModel> clonePrds(
    List<ProductV2Model> listPrd,
    int workspace,
  ) async {
    try {
      final payload = {
        'product_data': listPrd
            .map(
              (e) => {
                'product_id': e.id,
                'quantity': e.quantity,
              },
            )
            .toList(),
        'workspace': workspace,
      };
      final res = await _dio.post(
        Api.productKafaList,
        data: payload,
      );

      if (res.data['code'] == 200) {
        return BaseResponseModel(
          code: res.data['code'],
        );
      } else {
        return BaseResponseModel(
          code: res.data['code'],
          message: res.data['message'],
        );
      }
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}

enum ProductBasic {
  category('v1/product/categories'),
  brand('v1/product/brands'),
  type('v1/product/types');

  const ProductBasic(this.endpoint);

  final String endpoint;
}
