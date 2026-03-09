import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/wholesale_medicine/data/mapper/variant_wm_mapper.dart';
import 'package:pharmago/presentation/features/wholesale_medicine/data/models/order_wm_model.dart';
import 'package:pharmago/presentation/features/wholesale_medicine/domain/entities/order_wm_entity.dart';

@injectable
class OrderWmMapper
    extends BaseDataMapper<OrderWmDetailModel, OrderWmDetailEntity> {
  final VariantWmMapper _variantDetailMapper;

  OrderWmMapper(
    this._variantDetailMapper,
  );

  @override
  OrderWmDetailEntity mapToEntity(OrderWmDetailModel? data) {
    return OrderWmDetailEntity(
      id: data?.id,
      dloId: data?.dloId,
      title: data?.title ?? '',
      note: data?.note ?? '',
      noteCancel: '',
      code: data?.code,
      orderRed: data?.orderRed ?? false,
      total: (data?.total ?? 0.0).round(),
      discount: (data?.discount ?? 0.0).round(),
      createAt: data?.createdAt,
      isOnline: data?.isOnline ?? false,
      // customerData: _customerEntityMapper.mapToEntity(data?.customerData),
      // senderData: _customerEntityMapper.mapToEntity(data?.senderData),
      orderStatus: OrderWmStatusEntity(
        id: data?.statusOrderData?.id ?? data?.statusData?.id ?? 0,
        title: data?.statusOrderData?.title ?? data?.statusData?.title ?? '',
        code: data?.statusOrderData?.code ?? data?.statusData?.code ?? '',
      ),
      // shopData: ShopDataEnity(
      //   name: data?.shopData?.title,
      //   phone: data?.shopData?.accountData?.phone,
      //   address: data?.shopData?.addressData?.title ?? '',
      // ),
      // statusPayment: data?.settings?.vietqr == null
      //     ? StatusPayment.cash
      //     : ((data?.settings?.vietqr?.status ?? false)
      //         ? StatusPayment.qrCode
      //         : StatusPayment.unpaid),
      variants: (data?.orderitems ?? data?.orderitemsystem ?? [])
          .map(
            (e) => OrderItemEntity(
              id: e.variant,
              name: e.variantData?.title ?? '',
              amount: (e.quantity ?? 0.0).round(),
              priceSell: (e.price ?? 0.0).round(),
              quantityInStock: (e.variantData?.quantityInStock ?? 0.0).round(),
              image: e.variantData?.image,
              // models: (e.variantData?.optionsData ?? []).fold('', (model, e) {
              //   model = model! + (model.isEmpty ? '' : ', ') + (e.values ?? '');
              //   return model;
              // }),
              type: e.type,
              variantParentPromo: e.variantPromotion,
              promotions: e.promotions ?? {},
              variant: _variantDetailMapper.mapToEntity(e.variantData),
            ),
          )
          .toList(),
      // qrCodePayment: data?.settings?.vietqr == null
      //     ? null
      //     : QrCodePayment(
      //         qrCode: data?.settings?.vietqr?.data?.qrCode,
      //         amount: data?.settings?.vietqr?.data?.amount,
      //         content: data?.settings?.vietqr?.data?.content,
      //       ),
      discountOrder: (data?.discountOrder ?? [])
          .map((e) => DiscountOrderEntity.fromJson(e.toJson()))
          .toList(),
    );
  }
}
