import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/customer/data/mapper/customer_entity_mapper.dart';
import 'package:pharmago/presentation/features/order/data/models/order_detail_model.dart';
import 'package:pharmago/presentation/features/order/domain/entities/order_detail_entity.dart';
import 'package:pharmago/presentation/features/product/data/mapper/unit_entity_mapper.dart';

import 'payment_v2_mapper.dart';

@injectable
class OrderDetailMapper
    extends BaseDataMapper<OrderDetailModel, OrderDetailEntity> {

  OrderDetailMapper(this._itemOderDetailMapper, this._customerEntityMapper,
      this._paymentV2ModelMapper,);

  final ItemOderDetailMapper _itemOderDetailMapper;
  final CustomerEntityMapper _customerEntityMapper;
  final PaymentV2Mapper _paymentV2ModelMapper;

  @override
  OrderDetailEntity mapToEntity(OrderDetailModel? data) {
    return OrderDetailEntity(
        id: data?.id,
        code: data?.code,
        createdAt: data?.createdAt,
        roleName: data?.roleName,
        totalPaid: data?.totalPaid,
        type: data?.type,
        redInvoice: data?.redInvoice,
        description: data?.description,
        userCreated: data?.userCreated,
        customer: _customerEntityMapper.mapToEntity(data?.customer),
        items: _itemOderDetailMapper.mapToListEntity(data?.items),
        totalPrice: data?.totalPrice,
        qrCode: data?.qrCode,
        payments: _paymentV2ModelMapper.mapToListEntity(data?.payments),
    );
  }
}

@injectable
class ItemOderDetailMapper
    extends BaseDataMapper<ItemOrderDetailModel, ItemOrderDetail> {

  ItemOderDetailMapper(this._unitEnityMapper);
  final UnitEnityMapper _unitEnityMapper;

  @override
  ItemOrderDetail mapToEntity(ItemOrderDetailModel? data) {
    return ItemOrderDetail(
      title: data?.title,
      name: data?.name,
      totalPrice: data?.totalPrice,
      discount: data?.discount,
      unitPrice: data?.unitPrice,
      quantity: data?.quantity,
      itemId: data?.itemId,
      units: _unitEnityMapper.mapToListEntity(data?.units),
    );
  }
}
