import 'package:pharmago/data/models/base/response.dart';
import '../../data/models/payload/debt_repayment_payload.dart';

abstract class RepaymentRepository {
  Future<BaseResponseModel<int>> create({
    required DebtRepaymentPayload data,
  });
}
