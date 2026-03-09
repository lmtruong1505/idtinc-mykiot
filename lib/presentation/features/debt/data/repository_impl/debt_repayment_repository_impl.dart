

import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/debt/data/models/payload/debt_repayment_payload.dart';

import '../../domain/repositories/repayment_repository.dart';

@LazySingleton(as: RepaymentRepository)
class DebtRepaymentRepositoryImpl extends RepaymentRepository {
  DebtRepaymentRepositoryImpl(this._dio);
  final BaseDio _dio;

  @override
  Future<BaseResponseModel<int>> create({required DebtRepaymentPayload data}) async {
    try {
      final res = await _dio.post('${Api.debtRepayment}/create', data: data.toJson());
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['details'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}