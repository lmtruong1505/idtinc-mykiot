import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features_v2/models/product/create_kafa_order_model.dart';
import 'package:pharmago/presentation/features_v2/models/product/drug_category_model.dart.dart';
import 'package:pharmago/presentation/features_v2/models/product/voucher_model.dart.dart';
import 'package:pharmago/presentation/features_v2/repositories/wholesale_drug/cart_vouchers_repo.dart';
import 'package:pharmago/presentation/features_v2/repositories/wholesale_drug/drug_cart_repo.dart';
import 'package:pharmago/presentation/features_v2/screens/kafa_import_order/shopping_cart/widget/drug_cart_product_item.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

import '../state/init_state.dart';

@singleton
class DrugCartBloc extends Cubit<CubitState> {
  DrugCartBloc(this.cartRepo, this.vouchersRepo) : super(CubitState());
  final DrugCartRepository cartRepo;
  final CartVouchersRepo vouchersRepo;

  bool get isSelectAll =>
      cartPrds.isNotEmpty &&
      cartPrds
          .expand((cate) => cate.products ?? [])
          .every((prd) => prd.isSelect);
  bool isRedInvoid = true;
  bool reloadPreviousPage = false;
  final delay = DelayCallBack();

  List<DrugCategoryModel> cartPrds = [];
  List<VoucherModel> vouchers = [];
  List<VoucherModel>? get vouchersSearch => vouchers
      .where(
        (v) => (v.title ?? '').contains(search ?? ''),
      )
      .toList();

  String? search;
  VoucherModel? voucherSelect;
  VoucherModel? voucherSelected;
  final _debouce = DelayCallBack();

  void resetReloadPage() {
    reloadPreviousPage = false;
  }

  void getCart() async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await cartRepo.getCart();
    if (res.code == 200) {
      final cartPrdsInit = (res.data ?? []).map((newCate) {
        cartPrds.forEach(
          (oldCate) {
            if (newCate.title == oldCate.title) {
              final prdsUpdate = newCate.products?.map(
                (newPrd) {
                  oldCate.products?.forEach((oldPrd) {
                    if (newPrd.id == oldPrd.id) {
                      newPrd = newPrd.copyWith(isSelect: oldPrd.isSelect);
                    }
                  });
                  return newPrd;
                },
              ).toList();
              newCate = newCate.copyWith(
                isSelect: oldCate.isSelect,
                products: prdsUpdate,
              );
            }
          },
        );
        return newCate;
      }).toList();
      cartPrds = cartPrdsInit;
      emit(state.copyWith(status: BlocStatus.success));
    } else {
      emit(state.copyWith(status: BlocStatus.failure));
    }
  }

  void getVouchers() async {
    final res = await vouchersRepo.getVouchers();
    if (res.code == 200) {
      vouchers = res.data ?? [];
      emit(state.copyWith(status: BlocStatus.success));
    } else {
      emit(state.copyWith(status: BlocStatus.failure));
    }
  }

  //copy logic
  int get totalPrdsSelect => cartPrds
      .expand((cate) => cate.products ?? [])
      .where((prd) => prd.isSelect == true)
      .length;
  int get cartLength => cartPrds.expand((e) => e.products ?? []).length;
  num get totalPrice => cartPrds
      .expand((cate) => cate.products!)
      .where((prd) => prd.isSelect == true)
      .fold(
        0,
        (pre, element) =>
            pre + (element.product?.price ?? 0) * (element.quantity ?? 0),
      );
  int get indexSelected => cartPrds.indexWhere(
        (cate) => cate.products!.any((product) => product.isSelect == true),
      );

  PromotionVoucherItem? get voucherPromotionActive {
    final items = voucherSelected?.promotionItems;
    //tìm chương trình khuyến mãi hợp lệ
    //chọn item đang thoả mãn cuối cùng
    return items?.lastWhereOrNull((item) => totalPrice >= (item.valueMin ?? 0));
  }

  PromotionVoucherItem? get promotionVoucherSelect {
    final items = voucherSelect?.promotionItems;
    //tìm chương trình khuyến mãi hợp lệ trong màn voucher giảm giá
    //lấy chương trình đang chọn
    //chọn item đang thoả mãn cuối cùng
    return items?.lastWhereOrNull((item) => totalPrice >= (item.valueMin ?? 0));
  }

  num get totalDiscount {
    final items = voucherSelected?.promotionItems;

    final typeDiscount =
        items?.firstOrNull?.type; //tìm discount type :dạng % hay tiền mặt :1-2

    return (typeDiscount == 1) //==1 tiền mặt ,==2 %
        ? voucherPromotionActive?.discount ?? 0
        : totalPrice * (voucherPromotionActive?.discount ?? 0) / 100;
  }

  num get totalDiscountSuggest {
    final items = voucherSelect?.promotionItems;

    final typeDiscount =
        items?.firstOrNull?.type; //tìm discount type :dạng % hay tiền mặt :1-2

    return (typeDiscount == 1) //==1 tiền mặt ,==2 %
        ? voucherPromotionActive?.discount ?? 0
        : totalPrice * (voucherPromotionActive?.discount ?? 0) / 100;
  }

  num get totalDiscountInVoucherScreen {
    final items = voucherSelect?.promotionItems;

    final typeDiscount =
        items?.firstOrNull?.type; //tìm discount type :dạng % hay tiền mặt :1-2

    return (typeDiscount == 1) //==1 tiền mặt ,==2 %
        ? promotionVoucherSelect?.discount ?? 0
        : totalPrice * (promotionVoucherSelect?.discount ?? 0) / 100;
  }

  PromotionVoucherItem? get suggestPromotion {
    final items = voucherSelected?.promotionItems;

    //tìm item đang sắp đủ thoả mãn đầu tiên
    return items?.firstWhereOrNull((item) => totalPrice < (item.valueMin ?? 0));
  }

  void onUpdateQuantity(DrugProductModel cart, int updateQuantity) {
    cartPrds = cartPrds.map(
      (products) {
        final updatePrds = products.products?.map(
          (product) {
            if (product.id == cart.id) {
              return product.copyWith(quantity: updateQuantity);
            }
            return product;
          },
        ).toList();
        return products.copyWith(products: updatePrds);
      },
    ).toList();
  }

  void onAdd(DrugProductModel prd) {
    final updateQuantity = (prd.quantity ?? 0) + 1;
    onUpdateQuantity(prd, updateQuantity);
    updatePrd(id: prd.id, quantity: updateQuantity);
  }

  void onMinus(DrugProductModel prd) {
    final updateQuantity = (prd.quantity ?? 0) - 1;
    onUpdateQuantity(prd, updateQuantity);
    updatePrd(id: prd.id, quantity: updateQuantity);
  }

  void onInput(DrugProductModel prd, int updateQuantity) {
    _debouce.debounce(() {
      onUpdateQuantity(prd, updateQuantity);
      updatePrd(id: prd.id, quantity: updateQuantity);
    });
  }

  void onSelectPrd(DrugProductModel prd) {
    cartPrds = cartPrds.map(
      (cate) {
        final updatePrds = cate.products?.map(
          (product) {
            if (product.id == prd.id) {
              return product.copyWith(isSelect: !(product.isSelect));
            }
            return product;
          },
        ).toList();
        final isSelectAll =
            updatePrds?.every((e) => e.isSelect == true) ?? false;

        if (isSelectAll) {
          cate = cate.copyWith(isSelect: true);
        } else {
          cate = cate.copyWith(isSelect: false);
        }
        return cate.copyWith(products: updatePrds);
      },
    ).toList();
    // isSelectAll = checkIsSelectAll();
    emit(state.copyWith(status: BlocStatus.success));
  }

  void onDeletePrds(List<DrugProductModel> deletePrds) {
    cartPrds = cartPrds.map(
      (cate) {
        final updatePrds = cate.products
            ?.where((product) => !deletePrds.contains(product))
            .toList();

        final isSelectAll =
            updatePrds?.every((e) => e.isSelect == true) ?? false;
        if (isSelectAll) {
          cate = cate.copyWith(isSelect: true);
        } else {
          cate = cate.copyWith(isSelect: false);
        }
        return cate.copyWith(products: updatePrds);
      },
    ).toList();
    cartPrds =
        cartPrds.where((cate) => cate.products?.isNotEmpty == true).toList();
  }

  void onSelectCategory(DrugCategoryModel category) {
    cartPrds = cartPrds.map(
      (cate) {
        if (category.title == cate.title) {
          final isSelectAll = !cate.isSelect;
          final updatePrds = cate.products
              ?.map((product) => product.copyWith(isSelect: isSelectAll))
              .toList();
          return cate.copyWith(
            products: updatePrds,
            isSelect: isSelectAll,
          );
        }
        return cate;
      },
    ).toList();
    emit(state.copyWith(status: BlocStatus.success));
  }

  void deletePrds({List<DrugProductModel>? deletePrds}) async {
    try {
      final selectPrds = cartPrds
          .expand((cate) => cate.products!)
          .where((prd) => prd.isSelect == true)
          .toList();

      final deleteIds = deletePrds?.map((prd) => prd.product?.id ?? 0).toList();

      emit(state.copyWith(status: BlocStatus.loadList));
      final res = await cartRepo.deletePrd(ids: deleteIds!);

      onDeletePrds(deletePrds ?? selectPrds);
      reloadPreviousPage = true;
      emit(
        state.copyWith(
          status: res.code == 200 ? BlocStatus.reload : BlocStatus.failure,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.failure));
    }
  }

  void updatePrd({required int? id, required num? quantity}) async {
    try {
      emit(state.copyWith(status: BlocStatus.loadList));

      final res = await cartRepo.updatePrd(id: id, quantity: quantity);
      final isSuccess = res.code == 200;
      reloadPreviousPage = true;
      emit(
        state.copyWith(
          status: isSuccess ? BlocStatus.reload : BlocStatus.failure,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.failure));
    }
  }

  void addPrdToCart({required List<DrugProductModel> prds}) async {
    try {
      emit(state.copyWith(status: BlocStatus.loadList));

      final res = await cartRepo.addPrdToCart(prds: prds);
      final isSuccess = res.code == 200;
      emit(
        state.copyWith(
          status: isSuccess ? BlocStatus.success : BlocStatus.failure,
        ),
      );

      getCart();
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.failure));
    }
  }

  void onToggleAll() {
    cartPrds = cartPrds.map(
      (cate) {
        final updatePrds = cate.products
            ?.map((product) => product.copyWith(isSelect: !isSelectAll))
            .toList();
        return cate.copyWith(
          products: updatePrds,
          isSelect: !isSelectAll,
        );
      },
    ).toList();
    emit(state.copyWith(status: BlocStatus.success));
  }

// danh sách sản phẩm được chọn cho màn xác nhận đơn
  List<DrugCategoryModel> get cartSelected => cartPrds.where((cate) {
        final isValidCate = cate.products?.any((prd) => prd.isSelect) == true;
        return isValidCate;
      }).map((newCate) {
        final updatePrd =
            newCate.products?.where((prd) => prd.isSelect).toList();
        return newCate.copyWith(products: updatePrd);
      }).toList();

  void toggleRedInvoice() {
    isRedInvoid = !isRedInvoid;
    emit(state.copyWith(status: BlocStatus.success));
  }

  void selectVoucher(VoucherModel? voucher) {
    voucherSelect = voucher;
    emit(state.copyWith(status: BlocStatus.success));
  }

  void confirmVoucher(VoucherModel? value) {
    voucherSelected = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  void onVoucherSearch(String value) {
    delay.debounce(() {
      search = value;

      emit(state.copyWith(status: BlocStatus.reload));
    });
  }

  Future<BaseResponseModel> createOrder() async {
    final order = OrderKafaModel(
      costs: 0, //thêm cost (mặc định api cũ)
      total: totalPrice,
      discount: totalDiscount,
      redInvoice: isRedInvoid,
      promotions: voucherPromotionActive != null
          ? [voucherPromotionActive?.id ?? 0]
          : null,
      company: getCompanyId,
    );
    // type: 0 bán - 1: tặng
    final itemPurchase = cartSelected.expand((cate) => cate.products!).map(
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

    for (var i = 0; i < cartSelected.length; i++) {
      final cate = cartSelected[i];
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

  void deletePrdOnMarket({List<int>? deleteIds}) async {
    try {
      emit(state.copyWith(status: BlocStatus.loadList));
      final res = await cartRepo.deletePrd(ids: deleteIds!);

      emit(
        state.copyWith(
          status: res.code == 200 ? BlocStatus.reload : BlocStatus.failure,
        ),
      );
      getCart();
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.failure));
    }
  }
}
