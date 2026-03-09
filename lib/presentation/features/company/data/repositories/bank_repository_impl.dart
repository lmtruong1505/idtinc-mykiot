import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';

import 'package:pharmago/presentation/features/company/data/models/bank_model.dart';

import '../../domain/repositories/bank_repository.dart';

@LazySingleton(as: BankRepository)
class BankRepositoryImpl extends BankRepository {
  BankRepositoryImpl(this._dio);
  final BaseDio _dio;
  @override
  Future<BaseResponseModel<List<BankModel>>> getBanks() async {
    try {
      final res = await _dio.get('${Api.company}/banks');
      final data = (res.data['details'] as List)
          .map((e) => BankModel.fromJson(e))
          .toList();
      return BaseResponseModel<List<BankModel>>(
        data: data,
        message: res.data['message'],
        code: res.data['status'],
      );
    } catch (e) {
      return BaseResponseModel<List<BankModel>>(
        data: [],
        message: e.toString(),
        code: 500,
      );
    }
  }

  @override
  Future<BaseResponseModel<String>> getAccNameBank(
      {required int bank, required String accountNumber}) async {
    try {
      final payload = {
        'bank': bank,
        'account_number': accountNumber,
      };
      final res = await _dio.post('${Api.company}/banks/verify', data: payload);
      if (res.data['details'] is String) {
        return BaseResponseModel<String>(
          data: res.data['details'],
          message: res.data['message'],
          code: res.data['status'],
        );
      }
      return BaseResponseModel<String>(
        data: null,
        message: res.data['message'],
        code: res.data['status'],
      );
    } catch (e) {
      return BaseResponseModel<String>(
        data: '',
        message: e.toString(),
        code: 500,
      );
    }
  }
}
