import 'package:injectable/injectable.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/company/data/models/company_model.dart';

import '../../../../../data/apis/end_point.dart';
import '../models/associate_model.dart';

@injectable
class WsAssociateRepositoryImpl {
  WsAssociateRepositoryImpl(this._baseDio);
  final BaseDio _baseDio;

  Future<BaseResponseModel<List<AssociateModel>>> getListAssociate(
    int workspace, {
    int? page,
    int? limit,
    String? search,
  }) async {
    try {
      final params = {
        'workspace': workspace,
        'page': page,
        'limit': limit,
        'search': search,
      };
      params.removeWhere((key, value) => value == null || value == '');
      final res = await _baseDio.get(Api.warehouseAssociate, data: params);
      return BaseResponseModel(
        message: res.data['message'],
        code: res.data['code'],
        data: (res.data['details'] as List)
            .map((e) => AssociateModel.fromJson(e))
            .toList(),
      );
    } catch (e) {
      return BaseResponseModel(
        message: e.toString(),
        code: 400,
      );
    }
  }

  Future<BaseResponseModel<CompanyModel>> findWsByAssociateCode(
    String code,
  ) async {
    try {
      final params = {'associate_code': code};
      final res = await _baseDio.get(Api.warehouseAssociate, data: params);
      return BaseResponseModel(
        message: res.data['message'],
        code: res.data['code'],
        data: CompanyModel.fromJson(res.data['details']),
      );
    } catch (e) {
      return BaseResponseModel(
        message: e.toString(),
        code: 400,
      );
    }
  }

  Future<BaseResponseModel<AssociateModel>> connectWsAssociate({
    required int workspace,
    required int workspaceAssociate,
    bool? isConnect,
  }) async {
    try {
      final payload = {
        'workspace': workspace,
        'workspace_associate': workspaceAssociate,
        'connected': isConnect,
      };
      final res = await _baseDio.post(Api.warehouseAssociate, data: payload);
      return BaseResponseModel(
        message: res.data['message'],
        code: res.data['code'],
        data: AssociateModel.fromJson(res.data['details']),
      );
    } catch (e) {
      return BaseResponseModel(
        message: e.toString(),
        code: 400,
      );
    }
  }
}
