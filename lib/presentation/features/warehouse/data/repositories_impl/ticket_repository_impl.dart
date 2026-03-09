import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/base/date.dart';
import 'package:pharmago/presentation/features/product/data/models/basic_model.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/ticket_model.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/variant_warehouse_model.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/list_warehouse_use_case.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/warehouse_use_case.dart';

import '../../domain/repositories/ticket_repository.dart';
import '../models/warehouse_model.dart';

@LazySingleton(as: TicketRepository)
class TicketRepositoryImpl extends TicketRepository {
  TicketRepositoryImpl(this._dio);

  final BaseDio _dio;

  @override
  Future<BaseResponseModel<BasicModel>> create(
    WarehouseCreateInput input,
  ) async {
    try {
      final bs = [];
      for (final b in input.batchs) {
        final item = {
          'code': b.code,
          'quantity': int.tryParse(b.amount),
          'variant': b.variantId,
          'expiredAt': Date.formatDate(b.expiry),
          'producedAt': Date.formatDate(b.productionDate),
        };
        item.removeWhere((key, value) => value == null || value == '');
        bs.add(item);
      }
      final query = {
        'ticket': {
          'type': input.type,
          'status': input.status,
          'note': input.note,
          'totalPrice': input.totalPrice,
          'exportTo': input.exportTo,
          'importFrom': input.importFrom,
          'warehouse': input.warehouse,
        },
        'consignment': bs,
      };
      final res = await _dio.post(Api.warehouseCreate, data: query);
      BasicModel? data;
      final dataRes = res.data['details'];
      if (dataRes is int) {
        return BaseResponseModel(
          code: 200,
          message: 'Tạo phiếu thành công',
        );
      }
      if (dataRes != null) {
        data = BasicModel.fromJson(res.data['details']);
      }
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

  @override
  Future<BaseResponseModel<List<WarehouseModel>>> getList(
      WarehouseInput input) async {
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
  Future<BaseResponseModel<List<WarehouseModel>>> getWareHouseDetail(
      InventoryInputV2 input) {
    // TODO: implement getWareHouseDetail
    throw UnimplementedError();
  }
}
