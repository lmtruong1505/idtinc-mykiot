import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/order/data/models/payment_v2_model.dart';
import 'package:pharmago/presentation/features/order/domain/entities/payment_v2_entity.dart';

@injectable
class PaymentV2Mapper extends BaseDataMapper<PaymentV2Model, PaymentV2Entity> {
  @override
  PaymentV2Entity mapToEntity(PaymentV2Model? data) {
    return PaymentV2Entity(
      id: data?.id,
      amount: data?.amount,
      method: data?.method == PaymentMethod.bank.code ? PaymentMethod.bank : PaymentMethod.cash,
    );
  }

}