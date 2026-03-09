import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features_v2/models/product/voucher_model.dart.dart';

@injectable
class CartVouchersRepo {
  final BaseDio dio;

  CartVouchersRepo({required this.dio});

  Future<BaseResponseModel<List<VoucherModel>>> getVouchers() async {
    try {
      final res = await dio.get(Api.vouchers);
      final list = (res.data['details'] as List)
          .map((e) => VoucherModel.fromJson(e))
          .toList();

      if (res.data['code'] == 200) {
        return BaseResponseModel(
          code: res.data['code'],
          message: res.data['message'],
          data: list,
        );
      } else {
        return BaseResponseModel(
          code: res.data['code'],
          message: res.data['message'],
        );
      }
    } catch (e) {
      if (kDebugMode) {
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
