import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/debt/data/models/debt_note_model.dart';
import 'package:pharmago/presentation/features/debt/data/models/payload/dept_note_payload.dart';
import 'package:pharmago/presentation/features/debt/domain/repositories/debt_repository.dart';

import '../models/debt_report_model.dart';

@LazySingleton(as: DebtRepository)
class DebtRepositoryImpl extends DebtRepository {
  DebtRepositoryImpl(this._baseDio);
  final BaseDio _baseDio;

  @override
  Future<BaseResponseModel<List<DebtNoteModel>>> list({
    int? page,
    int? limit,
    String? search,
    required int company,
    String? type,
  }) async {
    try {
      final data = {
        'company': company,
        'page': page,
        'limit': limit,
        'search': search,
        ...?(type != null && type != ''
            ? {
                'type': type,
              }
            : null),
      };
      final res = await _baseDio.get('${Api.debtNote}/list', data: data);
      final dataModel = (res.data['details'] as List)
          .map((e) => DebtNoteModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: dataModel,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<int>> create({required DebtNotePayload data}) async {
    try {
      final res =
          await _baseDio.post('${Api.debtNote}/create', data: data.toJson());
      final int debtId = res.data['details'];
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: debtId,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<DebtNoteModel>> detail({required int debtId}) async {
    try {
      final res = await _baseDio.get('${Api.debtNote}/detail/$debtId');
      final dataModel = DebtNoteModel.fromJson(res.data['details']);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: dataModel,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<DebtReportModel>> report({
    required int company,
    String? status,
    String? type,
  }) async {
    try {
      final data = {
        'company': company,
        'status': status,
        'type': type,
      };
      data.removeWhere((key, value) => value == null);
      final res = await _baseDio.get('${Api.debtNote}/report', data: data);
      final dataModel = DebtReportModel.fromJson(res.data['details']);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: dataModel,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
