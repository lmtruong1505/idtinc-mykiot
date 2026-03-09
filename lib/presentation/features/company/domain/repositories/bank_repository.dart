import 'package:pharmago/presentation/features/company/data/models/bank_model.dart';

import '../../../../../data/models/base/response.dart';

abstract class BankRepository {
  Future<BaseResponseModel<List<BankModel>>> getBanks();

  Future<BaseResponseModel<String>> getAccNameBank({
    required int bank,
    required String accountNumber,
  });
  getData(){}
}