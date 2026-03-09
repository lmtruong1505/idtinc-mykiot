import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/presentation/features/product/data/models/basic_model.dart';
import 'package:pharmago/presentation/features_v2/models/phieu_kham/detail_pk_v2_model.dart';

import '../../../../data/models/base/response.dart';
import '../../../di/di.dart';

class PhieuKhamV2Repo  {
  final dio = getIt<BaseDio>();

  Future<BaseResponseModel<List<BasicModel>>> getBenh({
    required int page,
    int limit = 10,
    String? search,
}) async {
    try {
      final payload = {
        'page': page,
        'limit': limit,
        'search': search,
      };
      final res = await dio.get(Api.pathologies, data: payload);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['details']
            .map<BasicModel>((e) => BasicModel.fromJson(e))
            .toList(),

      );
    }
    catch(e) {
      return BaseResponseModel(
          code: 500,
        message: e.toString(),
        data: [],
      );
    }
  }

  Future<BaseResponseModel<int>> createPhieuKham({required Map<String, dynamic> payload}) async {
      try {
        final res = await dio.post('${Api.medicalBill}/create', data: payload);
        return BaseResponseModel(
          code: res.data['code'],
          message: res.data['message'],
          data: res.data['details'],
        );
      }
      catch(e) {
        return BaseResponseModel(
          code: 500,
          message: e.toString(),
        );
      }
  }

  Future<BaseResponseModel<DetailPkV2Model>> detail(int id) async {
    try {
      final res = await dio.get('${Api.detailPhieuKham}$id');
      return BaseResponseModel(
        code: int.tryParse(res.data['code'].toString()) ?? res.statusCode,
        data: res.data['details'] == null
            ? null
            : DetailPkV2Model.fromJson(res.data['details'] ?? {}),
      );
    } catch (e) {
      return BaseResponseModel(
        code: 500,
        message: e.toString(),
      );
    }
  }
}