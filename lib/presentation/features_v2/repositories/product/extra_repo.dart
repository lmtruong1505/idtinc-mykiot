import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/product/data/models/basic_model.dart';
import 'package:pharmago/presentation/features_v2/screens/product/components/bts_chose_extra.dart';

import '../../../../data/models/base/response.dart';

class ExtraRepo {
  final dio = getIt<BaseDio>();

  Future<BaseResponseModel<List<BasicModel>>> getList({
    required int id,
    required ExtraType type,
    String? search,
  }) async {
    try {
      final payload = {'company': id, 'search': search};
      payload.removeWhere((key, value) => value == null || value == '');
      final res = await dio.get('${Api.product}/${type.name}', data: payload);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['details'].map<BasicModel>((e) => BasicModel.fromJson(e)).toList(),
      );
    } catch (e) {
      return BaseResponseModel(code: 500, message: e.toString(), data: []);
    }
  }

  Future<BaseResponseModel> create({required ExtraType type, required Map<String, dynamic> payload}) async {
    try {
      final res = await dio.post('${Api.product}/${type.name}', data: payload);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      return BaseResponseModel(code: 500, message: e.toString());
    }
  }
}
