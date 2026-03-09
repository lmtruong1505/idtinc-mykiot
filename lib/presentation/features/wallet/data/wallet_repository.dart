import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';

import '../../../../data/models/base/response.dart';
import 'models/deep_link_bank_model.dart';
import 'models/wallet_deposit_response.dart';
import 'models/wallet_model.dart';
import 'models/wallet_transaction_model.dart';

@injectable
class WalletRepository {
  final _dio = BaseDio();

  Future<BaseResponseModel<WalletModel>> detailWallet() async {
    late BaseResponseModel<WalletModel> response;
    try {
      final res = await _dio.get('${Api.wallet}/manage');
      final data = WalletModel.fromJson(res.data['details']);
      response = BaseResponseModel(
        data: data,
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      response = BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
    return response;
  }

  Future<BaseResponseModel<List<TransactionModel>>> walletTransaction({
    int? page,
    int? limit,
  }) async {
    late BaseResponseModel<List<TransactionModel>> response;
    try {
      final query = {
        'page': page,
        'limit': limit,
      };
      final res = await _dio.get(
        '${Api.wallet}/transaction',
        data: query,
      );
      final data = (res.data['details'] as List)
          .map((e) => TransactionModel.fromJson(e))
          .toList();
      response = BaseResponseModel(
        data: data,
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      response = BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
    return response;
  }

  Future<BaseResponseModel<WalletDepositRes>> urlDepositWallet({
    required int amount,
  }) async {
    late BaseResponseModel<WalletDepositRes> response;
    try {
      final payload = {
        'amount': amount,
        'cancelUrl': 'https://api.pharmago.asia/api',
        'returnUrl': 'https://api.pharmago.asia/api',
      };
      final res =
          await _dio.post('${Api.wallet}/get-deposit-url', data: payload);
      final data =
          WalletDepositRes.fromJson(res.data['details']['payment_data']);
      final isIos = Platform.isIOS;
      final dataDeeplinks = isIos
          ? res.data['details']['ios_banks']
          : res.data['details']['android_banks'];
      final dlBanks = (dataDeeplinks as List)
          .map((e) => DeepLinkBankModel.fromJson(e))
          .toList();
      response = BaseResponseModel(
        data: data,
        code: res.data['code'],
        message: res.data['message'],
        extra: dlBanks,
      );
    } catch (e) {
      response = BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
    return response;
  }

  Future<BaseResponseModel<List<DebebtTransactionModel>>> listDebt({
    int? page,
    int? limit,
  }) async {
    late BaseResponseModel<List<DebebtTransactionModel>> response;
    try {
      final query = {
        'page': page,
        'limit': limit,
      };
      final res = await _dio.get(
        '${Api.wallet}/debt-transaction',
        data: query,
      );
      final data = (res.data['details'] as List)
          .map((e) => DebebtTransactionModel.fromJson(e))
          .toList();
      response = BaseResponseModel(
        data: data,
        code: res.data['code'],
        message: res.data['message'],
      );
    } catch (e) {
      response = BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
    return response;
  }
}
