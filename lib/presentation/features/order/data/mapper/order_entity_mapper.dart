import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/customer/data/mapper/customer_entity_mapper.dart';
import 'package:pharmago/presentation/features/order/data/models/order_model.dart';
import 'package:pharmago/presentation/features/order/domain/entities/order_entity.dart';
import 'package:pharmago/presentation/features/product/data/mapper/service_entity_mapper.dart';
import 'package:pharmago/presentation/features/product/data/mapper/variant_entity_mapper.dart';
import 'package:pharmago/presentation/features/product/domain/entities/basic_entity.dart';

import 'payment_entity_mapper.dart';

@injectable
class OrderEntityMapper extends BaseDataMapper<OrderModel, OrderEntity> {
  OrderEntityMapper(
    this._paymentEntityMapper,
    this._customerEntityMapper,
    this._variantEntityMapper,
    this._serviceEntityMapper,
  );
  final PaymentEntityMapper _paymentEntityMapper;
  final CustomerEntityMapper _customerEntityMapper;
  final VariantEntityMapper _variantEntityMapper;
  final ServiceEntityMapper _serviceEntityMapper;
  @override
  OrderEntity mapToEntity(OrderModel? data) {
    return OrderEntity(
      id: data?.id,
      code: data?.code,
      totalPrice: data?.totalPrice,
      description: data?.description,
      vat: data?.vat,
      servicePrice: data?.servicePrice,
      discount: data?.discount,
      qr: data?.qr,
      userCreated: data?.userCreated,
      updatedAt: data?.updatedAt,
      createdAt: data?.createdAt,
      type: BasicEntity(
        id: data?.type?.id,
        code: data?.type?.code,
        name: data?.type?.name,
      ),
      status: BasicEntity(
        id: data?.status?.id,
        code: data?.status?.code,
        name: data?.status?.name,
      ),
      customer: _customerEntityMapper.mapToEntity(data?.customer),
      payment: _paymentEntityMapper.mapToEntity(data?.payment),
      items: data?.items
          ?.map(
            (e) => OrderItemEntity(
              id: e.id,
              value: e.value,
              variant: _variantEntityMapper.mapToEntity(e.variant),
            ),
          )
          .toList(),
      services: data?.services
          ?.map(
            (e) => ServiceItemEntity(
              id: e.id,
              service: _serviceEntityMapper.mapToEntity(e.service),
              discount: e.discount,
              totalPrice: e.totalPrice,
              unitPrice: e.unitPrice,
              quantity: e.quantity,
            ),
          )
          .toList(),
    );
  }
}
