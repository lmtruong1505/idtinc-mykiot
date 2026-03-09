import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/apis/end_point.dart';
import '../../../../data/config/dio.dart';
import '../../../../data/models/base/response.dart';
import '../../../di/di.dart';

@injectable
class OrderKafaRepo {

  final _dio = getIt<BaseDio>();

  Future<BaseResponseModel> createOrder({
    required Map<String, dynamic> payload,
  }) async {
    try{
      final res = await _dio.post(Api.orderKafa, data: payload);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['details'],
      );
    }
    catch(e) {
      if(kDebugMode) {
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