import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/order/data/models/order_preview_model.dart';
import 'package:pharmago/presentation/features/order/domain/entities/order_preview_entity.dart';

@injectable
class OrderPreviewEntityMapper extends BaseDataMapper<OrderPreviewModel, OrderPreviewEntity> {
  @override
  OrderPreviewEntity mapToEntity(OrderPreviewModel? data) {
    return OrderPreviewEntity(
      id: data?.id,
      code: data?.code,
      createdAt: data?.createdAt,
      customerName: data?.customerName,
      status: data?.status,
      totalPrice: data?.totalPrice,
      userCreated: data?.userCreated,
      type: data?.type,
      totalPaid: data?.totalPaid,
    );
  }
}