import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/order_wm_entity.dart';
import '../../domain/entities/promotion_detail_wm_entity.dart';
import '../../domain/entities/variant_wm_entity.dart';

part 'order_wm_create_state.freezed.dart';

@freezed
class OrderWmCreateState with _$OrderWmCreateState {
  const factory OrderWmCreateState({
    // AccountEntity? pharmacist,
    @Default(false) bool loadingInit,
    @Default(<VariantWmEntity>[])
    List<VariantWmEntity> listVariantData,
    @Default(<VariantWmEntity>[])
    List<VariantWmEntity> listVariantSelect,
    @Default(<VariantWmEntity>[])
    List<VariantWmEntity> listVariantPromotionSelect,
    @Default(0) int totalPrice,
    @Default(0) num totalPriceDiscount,
    @Default(0) int totalPricePromo,
    @Default(0) int totalPriceDefault,
    @Default('note') String note,
    @Default(10) int? limit,
    @Default('') String searchKey,
    @Default(TypeOrder.cHTH) TypeOrder typeOrder,
    @Default(null) FailureCreateOrder? failureCreateOrder,
    @Default(null) OrderWmDetailEntity? orderDetailEntity,
    @Default(TypePayment.cash) TypePayment typePayment,
    @Default(false) bool isBottomSroll,
    @Default(false) bool isLoading,
    @Default(false) bool selectedOrderRed,
    List<PromotionDetailEntity>? promotionDetailEntityForTotalOrder,
    @Default(TypeCreateOrder.byPromotion) TypeCreateOrder typeCreate,
  }) = _OrderWmCreateState;
}

enum TypeCreateOrder {byProduct, byPromotion}

enum TypeOrder { cHTH, ad }

enum FailureCreateOrder {
  inventoryEmpty('Số lượng tồn kho không đủ'),
  inventoryNotEnough('Số lượng tồn kho không đủ'),
  quantity('Số lượng sản phẩm đặt bằng 0');

  const FailureCreateOrder(this.errMsg);

  final String? errMsg;
}

enum TypePayment {
  cash('Tiền mặt'),
  qrCode('QR thanh toán');

  const TypePayment(this.title);

  final String title;
}
