import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/presentation/features_v2/models/order/count_prod_model.dart';
import 'package:pharmago/presentation/features_v2/models/order/preview_order_model.dart';

import '../../../../data/apis/end_point.dart';
import '../../../../data/models/base/response.dart';
import '../../../di/di.dart';
import '../../models/product/product_v2_model.dart';
import '../../screens/order/components/bts/bts_filter_order.dart';

class OrderV2Repo {
  final _dio = getIt.get<BaseDio>();

  Future<BaseResponseModel<List<PreviewOrderModel>>> getList({
    required int company,
    String? search,
    String? type,
    int limit = 10,
    required int page,
    String? medicalBill,
    String? status,
    int? priceGte,
    int? priceLte,
    int? customer,
    TimeCreated? time,
    String? typeCode,
  }) async {
    try {
      final payload = {
        'workspace': company,
        'search': search,
        'type': type,
        'limit': limit,
        'page': page,
        'medical_bill': medicalBill,
        'status': status,
        'price_gte': priceGte,
        'price_lte': priceLte,
        'customer_id': customer,
        'type_warehouse__code': typeCode,
      };
      payload.addAll(time?.range ?? {});
      payload.removeWhere((key, value) => value == null || value == '');
      final res = await _dio.get(
        Api.orderList,
        data: payload,
      );
      final List<PreviewOrderModel> list = [];
      for (final json in res.data['details'] ?? []) {
        list.add(PreviewOrderModel.fromJson(json));
      }
      late CountProdModel? count;
      if (res.data['count'] != null) {
        count = CountProdModel.fromJson(res.data['count']);
      }
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: list,
        extra: {
          'count': count,
          'revenue_in_month': res.data['revenue_in_month'],
          'revenue': res.data['revenue'],
        },
      );
    } catch (e) {
      return BaseResponseModel(
        code: 500,
        message: e.toString(),
        data: [],
      );
    }
  }

  Future<BaseResponseModel<int>> createProdOrder({
    required Map<String, dynamic> payload,
    List<File> prescriptionImagePaths = const [], // local file paths
  }) async {
    try {
      final formMap = <String, dynamic>{};

      payload.forEach((key, value) {
        // Backend CreateNewOrderAPIView hỗ trợ parse string JSON cho các field này
        if (key == 'order' ||
            key == 'items' ||
            key == 'services' ||
            key == 'product_exchange_point' ||
            key == 'items_delete') {
          formMap[key] = jsonEncode(value);
        } else {
          formMap[key] = value;
        }
      });

      final files = await Future.wait(
        prescriptionImagePaths.map(
          (file) => MultipartFile.fromFile(file.path),
        ),
      );
      formMap['prescription_images_add'] = files;
      final formData = FormData.fromMap(formMap);
      final res = await _dio.post(
        Api.orderCreate,
        data: formData,
      );

      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['details'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 500,
        message: e.toString(),
        data: -1,
      );
    }
  }

  Future<BaseResponseModel<List<ProductV2Model>>> checkTonkho({
    required int company,
    required List<int> productIds,
  }) async {
    try {
      final payload = {
        'company': company,
        'product_ids': productIds.join(','),
      };
      final res = await _dio.get(
        Api.productList,
        data: payload,
      );
      final List<ProductV2Model> list = [];
      for (final json in res.data['details'] ?? []) {
        list.add(ProductV2Model.fromJson(json));
      }
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: list,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 500,
        message: e.toString(),
        data: [],
      );
    }
  }

  Future<BaseResponseModel> createExportInvoice(
    String serial,
    int invoiceAttributeId,
    List<int>? ids,
  ) async {
    try {
      final payload = {
        'order_ids': ids,
        // 'system': 'PMG_pro',
        // 'serial': serial,
        'invoice_attribute_id': invoiceAttributeId,
      };
      payload.removeWhere((key, value) => value == null);
      final res = await _dio.post(
        Api.exportElectricInvoice,
        data: payload,
      );

      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 500,
        message: e.toString(),
        data: [],
      );
    }
  }
}
