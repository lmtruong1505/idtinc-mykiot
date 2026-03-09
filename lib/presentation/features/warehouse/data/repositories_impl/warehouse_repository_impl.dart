import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/product/data/models/product_model.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/inventory_model_v2.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/product_ai_model.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/receipt_import_detail_model.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/receipt_import_model.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/ticket_model.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/variant_warehouse_model.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/payload_create_export_receipt_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/payload_create_import_receipt_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/repositories/warehouse_repository.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/fetch_prds_from_ai_use_case.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/import_receipt_use_case.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/list_product_use_case.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/list_warehouse_use_case.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/receipt_import_detail_use_case.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/warehouse_use_case.dart';
import 'package:pharmago/presentation/features_v2/models/employee/user_data_model.dart';

import '../../../../shared/utils/get.dart';
import '../../../image_picker/domain/entities/image_receipt_entity.dart';
import '../models/payload_create_export_receipt_model.dart';
import '../models/receipt_export_model.dart';
import '../models/shipment_data_model.dart';
import '../models/warehouse_model.dart';

@LazySingleton(as: WarehouseRepository)
class WarehouseRepositoryImpl extends WarehouseRepository {
  WarehouseRepositoryImpl(this._dio, this._dioAI);

  final BaseDio _dio;
  final BaseDioAI _dioAI;

  @override
  Future<BaseResponseModel<int>> create(
    Map<String, dynamic> payload,
  ) async {
    try {
      payload.removeWhere((key, value) => value == null || value == '');
      final res = await _dio.post(
        Api.warehouseV3,
        data: payload,
      );
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['data']['id'],
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
  Future<BaseResponseModel<List<WarehouseModel>>> getList(
    WarehouseInput input,
  ) async {
    try {
      final query = {
        'page': input.page,
        'limit': input.limit,
        'company': input.company,
        'search': input.search,
      };
      final res = await _dio.get(Api.warehouseList, data: query);
      final data = (res.data['data'] as List)
          .map((e) => WarehouseModel.fromJson(e))
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
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel<List<TicketModel>>> getListTicket({
    required int company,
    int? page,
    int? limit,
    String? search,
  }) async {
    try {
      final query = {
        'page': page,
        'limit': limit,
        'company': company,
        'search': search,
      };
      final res = await _dio.get(Api.ticketList, data: query);
      final data = (res.data['details'] as List)
          .map((e) => TicketModel.fromJson(e))
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
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<dynamic> getTicket(int id) async {
    try {
      return await _dio.get('${Api.ticketDetail}$id');
    } catch (e) {
      if (kDebugMode) print(e);
      return null;
    }
  }

  @override
  Future<BaseResponseModel<List<VariantWarehouseModel>>> getVariantList(
      VariantListInput input) async {
    try {
      final query = {
        'page': input.page,
        'limit': input.limit,
        'company': input.company,
        'search': input.search,
      };
      final res = await _dio.get(Api.variantList, data: query);
      final data = (res.data['details'] as List)
          .map((e) => VariantWarehouseModel.fromJson(e))
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
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel> updateTicketStatus(int id, String status) async {
    try {
      final query = {'id': id, 'status': status, 'note': ''};
      final res = await _dio.put(Api.ticketStatus, data: query);
      return BaseResponseModel(
          code: res.data['code'], message: res.data['message']);
    } catch (e) {
      if (kDebugMode) print(e);
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel<WarehouseModel>> detail({required int id}) async {
    try {
      final res = await _dio.get('${Api.warehouseV3}$id');
      final data = WarehouseModel.fromJson(res.data['data']);
      return BaseResponseModel<WarehouseModel>(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      if (kDebugMode) print(e);
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<int>> update({
    required int id,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final res = await _dio.put(
        '${Api.warehouseV3}$id',
        data: payload,
      );
      return BaseResponseModel<int>(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['data']['warehouse'],
      );
    } catch (e) {
      if (kDebugMode) print(e);
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<List<ProductModel>>> getProductWarehouse(
    int idWarehouse,
  ) async {
    try {
      final res = await _dio.get(
        '${Api.warehouseList}/product?warehouse=$idWarehouse',
      );
      final data = (res.data['data'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
      return BaseResponseModel<List<ProductModel>>(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      if (kDebugMode) print(e);
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<List<WarehouseModel>>> getListWareHouse(
    ListWarehouseInput input,
  ) async {
    try {
      final query = {
        'connect_system__code': 'PHARMAGO',
        'exp_date': input.expired,
        'company': input.workspace,
        'type_warehouse__code': input.typeCode,
      };
      query.removeWhere((key, value) => value == null);
      final res = await _dio.get(Api.warehouseListV2, data: query);
      final data = (res.data['data'] as List)
          .map((e) => WarehouseModel.fromJson(e))
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
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel<List<InventoryModelV2>>> getListInventory(
    InventoryInputV2 input,
  ) async {
    try {
      final query = {
        'offset': input.page,
        'limit': input.limit,
        'search': input.search,
        'warehouse_id': input.id,
        'connect_system': 'PHARMAGO',
        'exp_date': input.expired,
        'workspace': input.workspace,
        'type_warehouse__code': input.typeCode,
      };
      query.removeWhere((key, value) => value == null || value == 0 || value == '');
      final res = await _dio.get(Api.inventoryListV2, data: query);
      final data = (res.data['data'] as List)
          .map((e) => InventoryModelV2.fromJson(e))
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
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel<List<ReceitExportModel>>> getListImportReceipt(
    ImportReceiptInput input,
  ) async {
    try {
      final query = {
        'page': input.page,
        'limit': 10,
        'search': input.search,
        'warehouse': input.id,
        'status__code': input.status,
        'type_warehouse__code': input.typeCode,
      };
      query.removeWhere((key, value) => value == null);
      final res = await _dio.get(Api.importReceipts, data: query);
      final data = (res.data['data'] as List)
          .map((e) => ReceitExportModel.fromJson(e))
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
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel<List<ReceiptImportDetailModel>>> getListLot(
    ReceiptDetailInput input,
  ) async {
    try {
      final query = {
        'warehouse_import': input.warehouseId,
        'import_receipt': input.id,
      };
      query.removeWhere((key, value) => value == null);
      final res = await _dio.get(Api.importReceiptDetail, data: query);
      final data = (res.data['data'] as List).map((e) {
        final item = ReceiptImportDetailModel.fromJson(e);
        return item.copyWith(quantityPrint: item.currentQuantity?.toInt() ?? 0);
      }).toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel<ReceitExportModel>> getReceiptInfor(
    ReceiptDetailInput input,
  ) async {
    try {
      final res = await _dio.get('${Api.importReceiptInfor}/${input.id}');
      final data = ReceitExportModel.fromJson(res.data['data']);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel<List<ProductV3Model>>> getProductsWarehouse(
    ProductsWarehouseInput input,
  ) async {
    try {
      final payload = {
        'company': input.company,
        'search': input.search,
        'page': input.page,
      };
      payload.removeWhere((key, value) => value == null || value == '');
      final res = await _dio.get(
        Api.productList,
        data: payload,
      );
      final data = (res.data['details'] as List)
          .map((e) => ProductV3Model.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
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

  @override
  Future<BaseResponseModel> createReceipt(CreateReceiptInput input) async {
    try {
      final inputJson = (input.toJson());
      inputJson.removeWhere((key, value) => value == null || value == '');

      final payload = {'data': jsonEncode(inputJson)};
      // final payload = jsonEncode(inputJson);
      final FormData formData = FormData.fromMap(payload);
      if (input.images != null) {
        for (final element in input.images!) {
          final image = await MultipartFile.fromFile(element.path);
          formData.files.add(MapEntry('files', image));
        }
      }
      final res = await _dio.post(Api.createImportReceipt, data: formData);
      if (res.data['code'] == 200) {
        return BaseResponseModel(
          code: res.data['code'],
          message: res.data['message'],
        );
      } else {
        return BaseResponseModel(
          code: res.data['code'],
          message: res.data['data'],
        );
      }
    } catch (e) {
      print('products: $e');
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
        data: [],
      );
    }
  }

  @override
  Future<BaseResponseModel<List<UserDataModel>>> getListUserWarehouse(
    int workspace,
  ) async {
    try {
      final payload = {'workspace': workspace};
      final res = await _dio.get(Api.listUserWarehouse, data: payload);
      final data = (res.data['data'] as List)
          .map((e) => UserDataModel.fromJson(e))
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
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel<List<ProductAIModel>>> getProductsFromAI(
    FetchPrdsFromAIInput input,
  ) async {
    try {
      final payload = {'workspace_id': input.workspaceId};
      final FormData formData = FormData.fromMap(payload);

      for (final element in input.imgs) {
        final image = await MultipartFile.fromFile(element.path);
        formData.files.add(MapEntry('file', image));
      }

      final res = await _dioAI.post(Api.prdsFromAI, data: formData);
      final data = (res.data['details'] as List)
          .map((e) => ProductAIModel.fromJson(e))
          .toList();
      final extra = (res.data['images'] as List)
          .map((e) => ImageAIStatusModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
        extra: extra,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel<ShipmentDataModel>> getListShipmentByProduct({
    required int workspace,
    required int productId,
  }) async {
    try {
      final query = {
        'workspace': workspace,
        'product': productId,
      };
      final res = await _dio.get(Api.listShipmentByProduct, data: query);
      final data = ShipmentDataModel.fromJson(res.data);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel<ShipmentItemModel>> scanShipmentDetail(
      {required String code}) async {
    try {
      final res = await _dio.get('${Api.scanShipmentDetail}/$code');
      final data = ShipmentItemModel.fromJson(res.data['data']);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel<int>> createExportReceipt(
    PayloadCreateExportReceiptEntity payload,
  ) async {
    try {
      final payloadModel = PayloadCreateExportReceiptModel(
        exportInfor: payload.exportInfor,
        exportReceipt: payload.exportReceipt,
      );
      final res = await _dio.post(
        Api.exportReceipt,
        data: payloadModel.toJson(),
      );
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data:
            res.data['code'] == 200 ? res.data['data']['export_receipt'] : null,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel<List<ReceiptExportModel>>> listExportReceipt({
    required int warehouse,
    required int page,
    required int limit,
    int? accountPeriod,
    String? statusCode,
    String? search,
    String? typeCode,
  }) async {
    try {
      final params = {
        'warehouse': warehouse,
        'page': page,
        'limit': limit,
        'account_period': accountPeriod,
        'status__code': statusCode,
        'search': search,
        'type_warehouse__code': typeCode,
      };
      params.removeWhere((key, value) => value == null);
      final res = await _dio.get(
        Api.exportReceipt,
        data: params,
      );
      final data = (res.data['data'] as List)
          .map((e) => ReceiptExportModel.fromJson(e))
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
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel<ReceiptExportModel>> detailExportReceipt({
    required int id,
  }) async {
    try {
      final res = await _dio.get(
        '${Api.exportReceipt}/$id',
      );
      final data = ReceiptExportModel.fromJson(res.data['data']);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel<List<ReceiptItemModel>>> listShipmentExportReceipt({
    required int id,
  }) async {
    try {
      final res = await _dio.get(
        Api.inforexportshipment,
        data: {
          'export_receipt': id,
        },
      );
      final data = (res.data['data'] as List)
          .map((e) => ReceiptItemModel.fromJson(e))
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
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel<List<ShipmentItemModel>>> getListShipment({
    required int workspace,
    required int offset,
    required int limit,
    String? search,
  }) async {
    try {
      final res = await _dio.get(
        Api.listShipment,
        data: {
          'workspace': workspace,
          'offset': offset,
          'limit': limit,
          'search': search,
        },
      );
      final data = (res.data['data'] as List)
          .map((e) => ShipmentItemModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
        extra: res.data['bonus'],
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  @override
  Future<BaseResponseModel<int>> createImportReceipt(
    PayloadCreateImportReceiptEntity payload,
  ) async {
    try {
      final formData = FormData.fromMap({
        'data': jsonEncode(payload.data?.toJson()),
        'company': getCompany,
      });

      for (final element in payload.file ?? []) {
        final image = await MultipartFile.fromFile(element.path);
        formData.files.add(MapEntry('files', image));
      }

      final res = await _dio.post(
        Api.createImportReceiptV2,
        data: formData,
      );

      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['code'] == 200
            ? res.data['data']['import_receipt']
            : null, // Sửa từ export_receipt thành data
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }
  
  @override
  Future<BaseResponseModel<int>> updateImportReceipt(PayloadUpdateImportReceiptEntity payload) async {
    try {
      final formData = FormData.fromMap({
        'data': jsonEncode(payload.data?.toJson()),
        'company': getCompany,
      });

      for (final element in payload.file ?? <ImageReceiptEntity>[]) {
        final image = await MultipartFile.fromFile(element.path!);
        formData.files.add(MapEntry('files', image));
      }

      final res = await _dio.put(
        '${Api.updateImportReceiptV2}/${payload.id}',
        data: formData,
      );

      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['code'] == 200
            ? res.data['data']['id']
            : null, // Sửa từ export_receipt thành data
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }
}
