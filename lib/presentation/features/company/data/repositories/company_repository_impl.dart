import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/company/data/models/company_model.dart';
import 'package:pharmago/presentation/features/company/data/models/point_exchange_package_model.dart';
import 'package:pharmago/presentation/features/company/data/models/point_exchange_package_payload_model.dart';
import 'package:pharmago/presentation/features/company/data/models/setting_point_model.dart';
import 'package:pharmago/presentation/features/company/domain/repositories/company_repository.dart';
import 'package:pharmago/presentation/features/product/data/models/basic_model.dart';

import '../models/company_menu.dart';

@LazySingleton(as: CompanyRepository)
class CompanyRepositoryImpl extends CompanyRepository {
  CompanyRepositoryImpl(this._dio);

  final BaseDio _dio;

  @override
  Future<BaseResponseModel<CompanyModel>> createCompany(
    Map<String, dynamic> payload,
    int? id,
  ) async {
    try {
      final res = id != null
          ? await _dio.put(
              '${Api.company}/detail/$id',
              data: payload,
            )
          : await _dio.post(
              '${Api.company}/create',
              data: payload,
            );
      CompanyModel? data;
      if (res.data['details'] is Map) {
        data = CompanyModel.fromJson(res.data['details']);
      }

      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      String message = e.toString();
      if (e is DioException) {
        message = e.message ?? 'Lỗi tạo Workspace';
      }

      return BaseResponseModel(
        code: 400,
        message: message,
      );
    }
  }

  @override
  Future<BaseResponseModel<List<CompanyModel>>> getCompanies({
    int? page,
    int? limit,
    String? search,
    int? parent,
    String? type,
    String? status,
    String? time,
    String? revenue,
    bool? isOwner = true,
    bool? isWorkingPlace = false,
    bool? includeCurrentWorkspace,
  }) async {
    // time = -id, id; revenue = -total_sales, total_sales
    try {
      final query = {
        'page': page,
        'limit': limit,
        'search': search,
        'parent': parent,
        'type': type,
        'status': status,
        'sales_order_by': revenue,
        'date_order_by': time,
        'is_owner': isOwner,
        'is_working_place': isWorkingPlace,
        'include_current_workspace': includeCurrentWorkspace,
      };

      query.removeWhere((key, value) => value == null || value == '');
      final res = await _dio.get('${Api.company}/list', data: query);
      final List<CompanyModel> list = [];
      if (res.data['details'] is List) {
        list.addAll(
          (res.data['details'] as List)
              .map((e) => CompanyModel.fromJson(e))
              .toList(),
        );
      }
      final extra = res.data['revenue'] ?? {};

      if (res.data['count'] != null) {
        extra['total_company_working'] =
            res.data['count']['total_company_working'];
        extra['total_company'] = res.data['count']['total_company'];
      }

      extra['count_type'] = res.data['count_type'];
      extra['count_status'] = res.data['count_status'];

      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
        data: list,
        extra: extra,
      );
    } catch (e) {
      if (kDebugMode) {
        print('adaskdjla $e');
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<CompanyModel>> getDetail({required int id}) async {
    try {
      final res = await _dio.get('${Api.company}/detail/$id');
      final data = res.data['details'] == null
          ? null
          : CompanyModel.fromJson(res.data['details']);
      return BaseResponseModel(
        code: res.data['code'] ?? res.statusCode,
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
  Future<BaseResponseModel> assignStaff({
    required int company,
    required List<int> assign,
    required List<int> remove,
  }) async {
    try {
      final payload = {
        'company': company,
        'assign': assign,
        'remove': remove,
      };
      final res =
          await _dio.post('${Api.company}/assign_employee', data: payload);
      return BaseResponseModel(
        code: res.statusCode,
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
  Future<BaseResponseModel> updateCompany({
    required int id,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final res = await _dio.put('${Api.company}/detail/$id', data: payload);
      return BaseResponseModel(
        code: res.statusCode,
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
  Future<BaseResponseModel<List<BasicModel>>> getCompanyType() async {
    try {
      final res = await _dio.get(Api.workspaceTypes);
      final data = (res.data['data'] as List)
          .map((e) => BasicModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      if (kDebugMode) {
        print('error $e');
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<bool>> remove(int id) async {
    try {
      final res = await _dio.delete('${Api.company}/detail/$id');

      final code = res.data['code'] ?? res.statusCode;

      return BaseResponseModel(
        code: code,
        message: res.data['details'] != null && code == 200
            ? 'Xoá Workspace thành công'
            : res.data['message'] ?? 'Lỗi. Xoá không thành công',
        data: res.data['details'] != null && code == 200,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<bool>> setActive(int id, bool value) async {
    try {
      final res = await _dio.put(
        '${Api.company}/detail/$id',
        data: {
          'company': {
            'status': value ? 'ACTIVE' : 'INACTIVE',
          },
        },
      );

      final code = res.data['code'] ?? res.statusCode;

      return BaseResponseModel(
        code: code,
        message: res.data['details'] != null && code == 200
            ? 'Cập nhật trạng thái Workspace thành công'
            : res.data['message'] ??
                'Lỗi. Cập nhật trạng thái Workspace không thành công',
        data: res.data['details'] != null && code == 200,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<bool>> setInWork(int id, bool value) async {
    try {
      final res = await _dio.patch(
        '${Api.company}/detail/$id',
        data: {
          'status_ws_user': value ? 'ACTIVE' : 'DECLINED',
        },
      );

      final code = res.data['code'] ?? res.statusCode;

      return BaseResponseModel(
        code: code,
        message: code == 200
            ? '${value ? 'Xác nhận' : "Từ chối"} làm việc tại Workspace thành công'
            : res.data['message'] ??
                'Lỗi. ${value ? 'Xác nhận' : "Từ chối"} làm việc tại Workspace không thành công',
        data: code == 200,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<List<CompanyMenu>>> companyMenu(int? id) async {
    try {
      final res = await _dio.get(
        '${Api.workspaceMenu}$id',
      );
      final List<CompanyMenu> list = [];
      if (res.data['details'] is List) {
        for (final json in res.data['details']) {
          list.add(CompanyMenu.fromJson(json));
        }
      }
      print('list menu: ${list.join(', ')}');
      return BaseResponseModel(
        code: res.statusCode,
        data: list,
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
  Future<BaseResponseModel<SettingPointModel>> settingPoint({
    required int idCompany,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final res = await _dio.put(
        '${Api.company}/detail/$idCompany/setting-point',
        data: payload,
      );
      return BaseResponseModel(
        code: res.statusCode,
        data: SettingPointModel.fromJson(res.data['details']),
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<PointExchangePackageModel>>
      createPointExchangePackage(
    PointExchangePackagePayload payload,
  ) async {
    try {
      final res = await _dio.post(
        '${Api.company}/point_exchange_package/create',
        data: payload.toJson(),
      );
      return BaseResponseModel(
        code: res.statusCode,
        data: PointExchangePackageModel.fromJson(res.data['details']),
      );
    } catch (e) {
      log('$e');
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<List<PointExchangePackageModel>>>
      listPointExchangePackage({
    required int ws,
    bool? status,
    String? search,
    int? page,
    int? pageSize,
  }) async {
    final params = {
      'workspace': ws,
      'status': status,
      'search': search,
      'page': page ?? 1,
      'page_size': pageSize ?? 10,
    };
    try {
      final res = await _dio.get(
        '${Api.company}/point_exchange_package',
        data: params,
      );
      return BaseResponseModel(
        code: res.statusCode,
        data: (res.data['details'] as List)
            .map((e) => PointExchangePackageModel.fromJson(e))
            .toList(),
      );
    } catch (e) {
      log('$e');
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
