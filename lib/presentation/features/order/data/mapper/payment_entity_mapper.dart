import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/order/data/models/payment_model.dart';
import 'package:pharmago/presentation/features/order/domain/entities/payment_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/basic_entity.dart';

@injectable
class PaymentEntityMapper extends BaseDataMapper<PaymentModel, PaymentEntity> {
  @override
  PaymentEntity mapToEntity(PaymentModel? data) {
    return PaymentEntity(
      id: data?.id,
      code: data?.code,
      totalPrice: data?.totalPrice,
      needPay: data?.needPay,
      hadPaid: data?.hadPaid,
      items: data?.items
          ?.map(
            (e) => PaymentItemEntity(
              id: e.id,
              type: BasicEntity(
                id: e.type?.id,
                code: e.type?.code,
                name: e.type?.name,
              ),
              isPaid: e.isPaid,
              value: e.value,
            ),
          )
          .toList(),
    );
  }
}
