import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

import '../../../features/wholesale_medicine/domain/entities/promotion_detail_wm_entity.dart';
import '../../models/variant_kafa/params_payload/order_item_kafa_payload.dart';
import '../../models/variant_kafa/variant_kafa_model.dart';
import '../../repositories/wholesale_drug/order_kafa_repo.dart';
import '../state/init_state.dart';

@Singleton()
class ShoppingCartBloc extends Cubit<CubitState> {
  ShoppingCartBloc(this.repo) : super(CubitState());

  final OrderKafaRepo repo;
  final DelayCallBack _delay = DelayCallBack(delay: 1000.milliseconds);

  final List<VariantKafaModel> list = [];

  bool _selectAll = true;

  bool get selectAll => _selectAll;
  List<PromotionDetailEntity> promotionDetailEntityForTotalOrder = [];

  void setSelectAll(bool? value) {
    _selectAll = value ?? true;
    for(int i = 0; i < list.length; i++) {
      list[i] = list[i].copyWith(isReadyForOrder: value ?? true);
    }
    updateTotal();
    updateDiscount();
    emit(state.copyWith(status: BlocStatus.success));
  }

  String _search = '';
  String get search => _search;
  void setSearch(String value) {
    emit(state.copyWith(status: BlocStatus.loading));
    _delay.debounce(() {
      _search = value;
      emit(state.copyWith(status: BlocStatus.success));
    });
  }

  double _total = 0;
  double get total => _total;

  double _totalPriceDiscount = 0;
  double get totalPriceDiscount => _totalPriceDiscount;

  void add(VariantKafaModel model) {
    final int index = list.indexWhere((element) => element.id == model.id);
    if (index != -1) {
      list[index] = model;
      updateTotal();
      emit(state.copyWith(status: BlocStatus.success));
      return;
    }
    list.add(model);
    updateTotal();
    updateDiscount();
    emit(state.copyWith(status: BlocStatus.success));
  }

  void updateTotal() {
    promotionDetailEntityForTotalOrder = [];
    _total = list.fold(0.0, (total, element) {
      if (element.isReadyForOrder == false) {
        return total;
      }
      final price = element.price.validator;
      final quantity = element.amount.validator +
          element.promotionDetail.fold(0, (total, promo) {
            final totalInPromo =
                promo.promotionItemData?.fold(0, (total_2, variantPromo) {
              return total_2 +
                  (variantPromo.quantitySelected) *
                      (variantPromo.valueMin?.toInt() ?? 0);
            });
            return total + (totalInPromo ?? 0);
          });
      return total + price * quantity;
    });
  }

  void updateDiscount() {
     _totalPriceDiscount = promotionDetailEntityForTotalOrder.fold<double>(0, (total, el) {
      final value = el.promotionItemData?.fold<double>(0, (previous, item) {
        if (item.typeDiscount == 1) {
          previous += item.discountValue * item.quantitySelected;

        } else if (item.typeDiscount == 2) {
          previous += _total / 100 *
              (item.discountValue *
              item.quantitySelected);
        }
        return previous;
      });
      total += value ?? 0;
      return total;
    });
  }

  void changeIsReadyForOrder(int index, bool? value) {
    list[index] = list[index].copyWith(isReadyForOrder: value ?? true);
    if (value == false) {
      _selectAll = false;
    }
    if (value == true && list.every((element) => element.isReadyForOrder)) {
      _selectAll = true;
    }
    updateTotal();
    updateDiscount();
    emit(state.copyWith(status: BlocStatus.success));
  }

  void remove(int index) {
    list.removeAt(index);
    updateTotal();
    updateDiscount();
    emit(state.copyWith(status: BlocStatus.success));
  }

  void removeAll() {
    list.clear();
    updateTotal();
    updateDiscount();
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<BaseResponseModel> createOrder() async {
    final items = getOrderItem;
    final company = getCompany;
    final KafaOrderPayload payload = KafaOrderPayload(
      order: OrderKafaInfo(
        total: total,
        costs: total - totalPriceDiscount,
        discount: totalPriceDiscount,
        redInvoice: false,
        company: company,
        discountOrder: promoOrderDiscount,
        promotions: (promotionDetailEntityForTotalOrder)
            .map((e) => e.id!)
            .toList() +
            items.fold([], (list, e) {
              list += e.promotions ?? [];
              return list;
            }),
      ),
      items: items,
    );
    final res = await repo.createOrder(payload: payload.toJson());
    return res;
  }

  List<OrderItemKafaPayload> get getOrderItem {
    // Hang ban le
    final retailItem =
        list.where((variantKafaOrder) => variantKafaOrder.isReadyForOrder).map(
              (e) => OrderItemKafaPayload(
                variant: e.id,
                quantity: e.amount,
                price: e.price ?? 0,
                type: 0,
              ),
            );
    // Khuyen mai theo san pham:
    // VDL Mua 7 tang 2: // OrderItem(quantity: 7, price: 120000, type: 0, variant: 334, promotions: [211]),
    final ordersanphamtangkemnguoitieudungSell =
        <OrderItemKafaPayload>[]; // SELL
    list.where((i) => i.isReadyForOrder).toList().forEach((e) {
      for (final promo in e.promotionDetail) {
        int total = 0;
        promo.promotionItemData?.forEach((element) {
          total += element.quantitySelected * (element.valueMin?.toInt() ?? 0);
        });
        if(total == 0) return;
        ordersanphamtangkemnguoitieudungSell.add(
          OrderItemKafaPayload(
            price: e.price ?? 0,
            quantity: total,
            type: 0,
            variant: e.id,
            promotions: [promo.id ?? 0],
          ),
        );
      }
    });
    final ordersanphamtangkemnguoitieudungBonus =
        <OrderItemKafaPayload>[]; // BONUS
    list.where((e) => e.isReadyForOrder).toList().forEach((e) {
      for (final promo in e.promotionDetail) {
        promo.promotionItemData?.forEach((variantPromo) {
          if (variantPromo.quantitySelected != 0) {
            ordersanphamtangkemnguoitieudungBonus.add(
              OrderItemKafaPayload(
                promotionItem: variantPromo.id,
                quantity: variantPromo.quantitySelected *
                    (variantPromo.variantValueData?.first.quantity ?? 0),
                timesApplyPromotion: variantPromo.quantitySelected,
                type: 1,
                variantPromotion: e.id,
                variant:
                    variantPromo.variantValueData?.first.variantData?.id ?? -1,
              ),
            );
          }
        });
      }
    });

    final khuyenMaiGTDH = convertPromotionForOrder;

    final total = [
      ...retailItem,
      ...ordersanphamtangkemnguoitieudungSell,
      ...ordersanphamtangkemnguoitieudungBonus,
      ...khuyenMaiGTDH,
    ];
    return total;
  }

  List<OrderItemKafaPayload> get convertPromotionForOrder {
    final orderItemBonus = (promotionDetailEntityForTotalOrder)
        .fold(<OrderItemKafaPayload>[], (list, e) {
      final orderItemBonusForOrder =
      e.promotionItemData?.fold(<OrderItemKafaPayload>[], (list, item) {
        if (item.typeDiscount == null && item.groupVariantData.isNotEmpty) {
          list += item.groupVariantData.fold([], (list, el) {
            if (el.amount != 0) {
              list += (el.variantValue ?? [])
                  .map(
                    (elem) => OrderItemKafaPayload(
                  variant: elem.variant?.id,
                  quantity: (elem.quantity ?? 0) * el.amount,
                  type: 1,
                  promotionOrder: e.id,
                  timesApplyPromotion: item.quantitySelected,
                  // variantData: elem.variant,
                  promotionItem: item.id,
                ),
              )
                  .toList();
            }
            return list;
          });
        } else if (item.typeDiscount == null && item.groupVariantData.isEmpty) {
          if (item.quantitySelected != 0) {
            list = list +
                (item.variantValueData ?? [])
                    .map(
                      (e) => OrderItemKafaPayload(
                    variant: e.variant,
                    quantity: (e.quantity ?? 0) * item.quantitySelected,
                    type: 1,
                    timesApplyPromotion: item.quantitySelected,
                    promotionItem: item.id,
                    // variantData: VariantEntity(
                    //   title: e.title ?? '',
                    //   image: e.image ?? '',
                    //   code: e.code ?? '',
                    // ),
                    // price: (e.priceSell ?? 0).round(),
                  ),
                )
                    .toList();
          }
        }

        return list;
      });
      list += orderItemBonusForOrder ?? [];
      return list;
    });
    return orderItemBonus;
  }

  List<OrderItemKafaPayload> get promoOrderDiscount {
    final orderItemBonus = (promotionDetailEntityForTotalOrder)
        .fold(<OrderItemKafaPayload>[], (list, e) {
      final listPromo = e.promotionItemData
          ?.where((e) => e.type == TypePromotionItem.discountTicket)
          .toList();
      for (final item in (listPromo ?? <PromotionItemDataEntity>[])) {
        if (item.quantitySelected == 0) continue;
        list.add(
          OrderItemKafaPayload(
            promotionItem: item.id,
            timesApplyPromotion: item.quantitySelected,
            discount: item.discountValue,
            minValueApply: item.valueMin ?? 0,
            typeDiscount: item.typeDiscount,
          ),
        );
      }
      return list;
    });
    return orderItemBonus;
  }

  void removeSuccessOrder() {
    list.removeWhere((element) => element.isReadyForOrder);
    promotionDetailEntityForTotalOrder = [];
    updateTotal();
    updateDiscount();
    emit(state.copyWith(status: BlocStatus.success));
  }

  void orderSingleItem(VariantKafaModel variant) {
    setSelectAll(false);
    add(variant);
    updateTotal();
    updateDiscount();
  }


  void clear(){
    list.clear();
    _total = 0;
    _selectAll = true;
    _search = '';
    emit(state.copyWith(status: BlocStatus.success));
  }

  void confirmPromoForVariant({
    List<PromotionDetailEntity>? value,
    int? idVariant,
    required TypePromotion typePromotion,
  }) {
    promotionDetailEntityForTotalOrder = value ?? [];
    updateDiscount();
    emit(state.copyWith(status: BlocStatus.success));
  }

  void delete(int id) {
    list.removeWhere((element) => element.id == id);
    updateTotal();
    updateDiscount();
    emit(state.copyWith(status: BlocStatus.success));
  }

}
