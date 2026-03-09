import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/models/product/create_kafa_order_model.dart';
import 'package:pharmago/presentation/features_v2/models/product/drug_category_model.dart.dart';
import 'package:pharmago/presentation/features_v2/models/product/voucher_model.dart.dart';
import 'package:pharmago/presentation/features_v2/repositories/wholesale_drug/drug_cart_repo.dart';
import 'package:pharmago/presentation/features_v2/screens/kafa_import_order/shopping_cart/widget/drug_cart_product_item.dart';

@injectable
class ConfirmKafaOrderBloc extends Cubit<CubitState> {
  ConfirmKafaOrderBloc(this.cartRepo) : super(CubitState());

  final DrugCartRepository cartRepo;
  bool isRedInvoid = true;
  num totalDiscount = 0;
  num totalPrice = 0;
  PromotionVoucherItem? promotionActive;

  void toggleRedInvoice() {
    isRedInvoid = !isRedInvoid;
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<BaseResponseModel> createOrder() async {
    final order = OrderKafaModel(
      costs: 0, //thêm cost (mặc định api cũ)
      total: totalPrice,
      discount: totalDiscount,
      redInvoice: isRedInvoid,
      promotions: promotionActive != null ? [promotionActive?.id ?? 0] : null,
      company: getCompanyId,
    );
    // type: 0 bán - 1: tặng
    final itemPurchase = readySaleCategory.expand((cate) => cate.products!).map(
      (prd) {
        return KafaPrdModel(
          type: 0,
          quantity: prd.quantity,
          // price: prd.product?.price,
          variant: prd.id,
          promotions: getPrmDataActive(prd) != null
              ? [getPrmDataActive(prd)?.id ?? 0]
              : null,
        );
      },
    ).toList();
    final List<KafaPrdModel> itemPromotions = [];

    for (var i = 0; i < readySaleCategory.length; i++) {
      final cate = readySaleCategory[i];
      for (final prd in cate.products ?? []) {
        final prmItem = getPrmActive(prd);
        for (final bonus in prmItem?.bonusVariantInfor ?? []) {
          itemPromotions.add(
            KafaPrdModel(
              type: 1,
              quantity: bonus.quantity,
              variant: bonus.variant?.id,
              variantPromotionId: bonus.variant?.id,
              promotionItemId: prmItem?.id,
              timesApplyPromotion:
                  ((prd.quantity ?? 0) / (prmItem?.valueRange ?? 1)).floor(),
            ),
          );
        }
      }
    }

    final item = [...itemPurchase, ...itemPromotions];

    final orderKafa = CreateOrderKafaModel(order: order, items: item);
    final res = await cartRepo.createOrder(orderKafa);
    return res;
  }

  List<DrugCategoryModel> readySaleCategory = [];

  void initData(
    List<DrugCategoryModel> value,
    num discount,
    num price,
    PromotionVoucherItem? promotion,
  ) {
    readySaleCategory = value;
    totalDiscount = discount;
    totalPrice = price;
    promotionActive = promotion;

    emit(state.copyWith(status: BlocStatus.success));
  }
}
