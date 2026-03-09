import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:pharmago/presentation/features/wholesale_medicine/domain/entities/order_wm_payload_entity.dart';
import 'package:pharmago/presentation/features/wholesale_medicine/domain/entities/variant_wm_entity.dart';
import 'package:pharmago/presentation/features/wholesale_medicine/domain/usecase/promotion_wm_list_use_case.dart';
import '../../../../../shared/constants/pref_key.dart';
import '../../../../../shared/constants/storage/shared_preference.dart';
import '../../../../base/infinite_list.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/typography.dart';
import '../../domain/entities/order_wm_entity.dart';
import '../../domain/entities/promotion_detail_wm_entity.dart';
import '../../domain/usecase/order_wm_create_use_case.dart';
import '../../domain/usecase/variant_wm_list_use_case.dart';
import 'order_wm_create_state.dart';

@injectable
class OrderWmCreateCubit extends Cubit<OrderWmCreateState> {
  OrderWmCreateCubit(
    this._variantGetListUseCase,
    this._orderCreateUseCase,
    this._promotionDetailListUseCase,
    // this._accountListUseCase,
    // this._customerGetListUseCase,
    // this._orderQrcodeUseCase,
    // this._cardBankCubit,
    // this._updateStatusPaymentOrderUseCase,
    // this._customerCreateUseCase,
    // this._variantGetByScanBarcodeUseCase,
  ) : super(const OrderWmCreateState());

  final VariantWmListUseCase _variantGetListUseCase;
  final OrderWmCreateUseCase _orderCreateUseCase;
  final PromotionWmListUseCase _promotionDetailListUseCase;
  // final AccountListUseCase _accountListUseCase;
  // final VariantGetByScanBarcodeUseCase _variantGetByScanBarcodeUseCase;
  // final CustomerGetListUseCase _customerGetListUseCase;
  // final OrderQrcodeUseCase _orderQrcodeUseCase;
  // final CardBankCubit _cardBankCubit;
  // final UpdateStatusPaymentOrderUseCase _updateStatusPaymentOrderUseCase;
  // final CustomerCreateUseCase _customerCreateUseCase;

  final InfiniteListController<VariantWmEntity> infiniteListController =
      InfiniteListController<VariantWmEntity>.init();
  final ScrollController scrollController = ScrollController();

  final InfiniteListController<VariantWmEntity> infiniteListPromoController =
      InfiniteListController<VariantWmEntity>.init();
  final ScrollController scrollPromoController = ScrollController();

  Timer? timer;

  void selectedOrderRedChange() {
    emit(state.copyWith(selectedOrderRed: !state.selectedOrderRed));
  }

  void _totalPrice() {
    _totalPriceDefault();
    _totalPricePromo();
    final totalPrice = (state.listVariantSelect).fold(0, (total, item) {
      if (item.isChoose) {
        print(item.priceSell);
        total += item.amount * item.priceSellUnit;
        total += item.amountRetail * item.priceSell;
      }
      return total;
    });
    emit(
      state.copyWith(
        totalPrice: totalPrice,
        promotionDetailEntityForTotalOrder: [],
        totalPriceDiscount: 0,
      ),
    );
  }

  void _totalPriceDiscount() {
    final totalDiscount =
        state.promotionDetailEntityForTotalOrder?.fold<double>(0, (total, el) {
      final value = el.promotionItemData?.fold<double>(0, (previous, item) {
        if (item.typeDiscount == 1) {
          previous += item.discountValue * item.quantitySelected;
        } else if (item.typeDiscount == 2) {
          previous += state.totalPrice *
              (item.discountValue / 100) *
              item.quantitySelected;
        }
        return previous;
      });

      total += value ?? 0;

      return total;
    });

    emit(state.copyWith(totalPriceDiscount: totalDiscount ?? 0));
  }

  void _totalPriceDefault() {
    final totalPrice = state.listVariantSelect.fold(0, (total, item) {
      if (item.isChoose) {
        total += item.amount * item.priceSellDefault;
      }
      return total;
    });
    emit(state.copyWith(totalPriceDefault: totalPrice));
  }

  void _totalPricePromo() {
    final totalPrice = (state.listVariantSelect).fold(0, (total, item) {
      if (item.isChoose) {
        final totalPromo = item.promotionDetailEntity?.fold(0, (t, e) {
          final totalPromoItem = e.promotionItemData?.fold(0, (sum, item) {
            sum += item.variantValueData?.fold(0, (s, i) {
                  s = (s ?? 0) +
                      (i.priceSell?.round() ?? 0) *
                          item.quantitySelected *
                          i.quantity!.round();

                  return s;
                }) ??
                0;
            return sum;
          });

          t += totalPromoItem ?? 0;

          return t;
        });
        total += totalPromo ?? 0;
      }
      return total;
    });
    emit(state.copyWith(totalPricePromo: totalPrice));
  }

  void _updateQuantityPromoForCustomer(int idVariant) {
    final listVariantCopy = List<VariantWmEntity>.from(state.listVariantSelect);
    final index = listVariantCopy.indexWhere((e) => e.id == idVariant);

    for (PromotionDetailEntity item
        in listVariantCopy[index].promotionDetailEntity ?? []) {
      if (item.consumerData?.id == null || item.consumerData == null) {
        continue;
      }
      final totalAmount = item.promotionItemData?.fold(0, (total, item) {
        total += (item.variantValueData?.fold(0, (amount, e) {
                  amount = amount +
                      item.quantitySelected *
                          (e.variant == idVariant ? (e.quantity ?? 0) : 0);
                  return amount;
                }) ??
                0) +
            (item.quantitySelected * (item.valueMin?.round() ?? 0));
        return total;
      });
      item = item.copyWith(
        consumerData: item.consumerData?.copyWith(
          numOfApplications: ((totalAmount ?? 0) /
                  (item.consumerData?.quantityBuy != 0
                      ? (item.consumerData?.quantityBuy ?? 1)
                      : 1))
              .floor(),
        ),
      );

      final listPromo = List<PromotionDetailEntity>.from(
              listVariantCopy[index].promotionDetailEntity ?? [])
          .toList();
      final indexPromo = listVariantCopy[index]
          .promotionDetailEntity
          ?.indexWhere((e) => e.id == item.id);
      if (indexPromo == null) return;
      listPromo[indexPromo] =
          listPromo[indexPromo].copyWith(consumerData: item.consumerData);
      listVariantCopy[index] =
          listVariantCopy[index].copyWith(promotionDetailEntity: listPromo);
    }

    emit(state.copyWith(listVariantSelect: listVariantCopy));
  }

  void noteChange(String value) {
    emit(state.copyWith(note: value));
  }

  // void customerChange(int id) {
  //   emit(state.copyWith(customer: id));
  // }

  // void customerEntityChange(CustomerEntity customerEntity) {
  //   emit(
  //     state.copyWith(
  //       customerEntity: customerEntity,
  //       listVariantSelect: [],
  //       promotionDetailEntityForTotalOrder: [],
  //     ),
  //   );
  //   if (state.typeCreate == TypeCreateOrder.byPromotion) {
  //     emit(state.copyWith(limit: null));
  //     getListVariant(-1);
  //   }
  //   _totalPrice();
  // }

  // void customerNameChange(String name) {
  //   emit(state.copyWith(customerName: name));
  // }

  // void pharmacistChange(AccountEntity value) {
  //   emit(
  //     state.copyWith(
  //       pharmacist: value,
  //       customerEntity: null,
  //       customer: null,
  //       customerName: '',
  //       listVariantSelect: [],
  //       listVariantData: [],
  //     ),
  //   );
  // }

  void isBottomSrollChange(bool value) {
    emit(state.copyWith(isBottomSroll: value));
  }

  void searchKeyChange(String value) {
    emit(state.copyWith(searchKey: value.toLowerCase()));

    if (timer != null) {
      timer!.cancel();
    }

    timer = Timer(const Duration(seconds: 1), () {
      infiniteListController.onRefresh();
    });
  }

  void typePaymentChange(TypePayment item) {
    emit(state.copyWith(typePayment: item));
  }

  void initData(
    TypeOrder typeOrder,
    // int? customer,
    TypeCreateOrder? typeCreate,
  ) {
    emit(
      state.copyWith(
        typeOrder: typeOrder,
        // customer: customer,
        typeCreate: typeCreate ?? state.typeCreate,
      ),
    );
  }

  /// use when create order by order draf
  void updateOrderInfo(OrderWmDetailEntity? order) {
    emit(
      state.copyWith(
        listVariantSelect: (order?.variants ?? [])
            .map(
              (e) => VariantWmEntity(
                id: e.id,
                amount: e.amount ?? 0,
                priceSell: e.priceSell ?? 0,
                inventory: 10000000000,
              ),
            )
            .toList(),
        // customer: order?.customerData?.id,
      ),
    );
    _totalPrice();
  }

  void validateCreateOrder() {
    for (final item in state.listVariantSelect) {
      if (item.amount == 0) {
        emit(state.copyWith(failureCreateOrder: FailureCreateOrder.quantity));
        return;
      } else if (item.inventory == 0 && state.typeOrder == TypeOrder.cHTH) {
        emit(
          state.copyWith(
            failureCreateOrder: FailureCreateOrder.inventoryEmpty,
          ),
        );
        return;
      } else if (item.inventory < item.amount &&
          state.typeOrder == TypeOrder.cHTH) {
        emit(
          state.copyWith(
            failureCreateOrder: FailureCreateOrder.inventoryNotEnough,
          ),
        );
        return;
      } else {
        emit(state.copyWith(failureCreateOrder: null));
      }
    }
  }

  void checkboxToggle(VariantWmEntity variant) {
    final updatedList = List<VariantWmEntity>.from(state.listVariantSelect);
    final index = updatedList.indexWhere((e) => e == variant);
    if (state.typeCreate == TypeCreateOrder.byProduct) {
      if (index == -1) {
        updatedList.add(variant.copyWith(isChoose: true));
      } else {
        updatedList.remove(variant);
      }
    } else {
      updatedList[index] =
          updatedList[index].copyWith(isChoose: !updatedList[index].isChoose);
    }
    emit(state.copyWith(listVariantSelect: updatedList));
    _totalPrice();
  }

  void changeAmount(VariantWmEntity variant, int value) {
    final updatedList = List<VariantWmEntity>.from(state.listVariantSelect);
    final index = updatedList.indexWhere((e) => e == variant);
    updatedList[index] = updatedList[index].copyWith(amountRetail: value);
    emit(
      state.copyWith(
        listVariantSelect: updatedList,
      ),
    );
    // _updateQuantityPromoForCustomer(variant.id!);
    _totalPrice();
  }

  void changeAmountGift(VariantWmEntity variant, int value) {
    final updatedList = List<VariantWmEntity>.from(state.listVariantSelect);
    final index = updatedList.indexWhere((e) => e == variant);
    updatedList[index] = updatedList[index].copyWith(amountGift: value);
    emit(state.copyWith(listVariantSelect: updatedList));
    _totalPrice();
  }

  void updateVariantSelected(List<VariantWmEntity> value) {
    // final accountId =
    //     AppSharedPreference.instance.getValue(PrefKeys.user) as int?;
    final listVariant = List<VariantWmEntity>.from(state.listVariantSelect);
    final listId = state.listVariantSelect.map((e) => e.id).toList();
    Future.forEach(value, (e) async {
      if (!listId.contains(e.id)) {
        listVariant.add(e);
        final index = listVariant.indexWhere((el) => el.id == e.id);
        listVariant[index] = listVariant[index].copyWith(isChoose: true);
        if (listVariant[index].promotionDetailEntity?.isEmpty ?? true) {
          final inputListPromo = PromotionWmListInput(
            variantId: e.id!,
            tag: 'PMG',
            // customerId: state.customer,
          );
          final resListPromo =
              await _promotionDetailListUseCase.execute(inputListPromo);
          final dataEntity = resListPromo.response.data;
          listVariant[index] = listVariant[index].copyWith(
            promotionDetailEntity: dataEntity,
          );
        }
      }
    }).then((value) {
      _totalPrice();
      emit(state.copyWith(listVariantSelect: listVariant));
    });
  }

  void deleteVariantSelected(int id) {
    final list = List<VariantWmEntity>.from(state.listVariantSelect);
    list.removeWhere((e) => e.id == id);
    emit(
      state.copyWith(
        listVariantSelect: list,
        promotionDetailEntityForTotalOrder: [],
      ),
    );
    _totalPrice();
  }

  void checkboxTogglePromo(VariantWmEntity variant) {
    final updatedList =
        List<VariantWmEntity>.from(state.listVariantPromotionSelect);
    final index = updatedList.indexWhere((e) => e == variant);
    if (index == -1) {
      updatedList.add(variant.copyWith(isChoose: true));
    } else {
      updatedList.remove(variant);
    }
    emit(state.copyWith(listVariantPromotionSelect: updatedList));
    _totalPrice();
  }

  void changeAmountPromo(VariantWmEntity variant, int value) {
    final updatedList =
        List<VariantWmEntity>.from(state.listVariantPromotionSelect);
    final index = updatedList.indexWhere((e) => e == variant);
    updatedList[index] = updatedList[index].copyWith(amount: value);
    emit(state.copyWith(listVariantPromotionSelect: updatedList));
    _totalPrice();
  }

  void priceChange(VariantWmEntity variant, String value) {
    final updatedList = List<VariantWmEntity>.from(state.listVariantSelect);
    final index = updatedList.indexWhere((e) => e == variant);
    final newPrice =
        int.parse(value.isNotEmpty ? value.replaceAll('.', '') : '0');
    updatedList[index] = updatedList[index].copyWith(priceSell: newPrice);
    emit(state.copyWith(listVariantSelect: updatedList));
    _totalPrice();
  }

  /// -----------------------------
  Future<void> selectVariant(int variantId) async {
    // final accountId =
    //     AppSharedPreference.instance.getValue(PrefKeys.user) as int?;
    final listVariant = List<VariantWmEntity>.from(state.listVariantSelect);
    final index = listVariant.indexWhere((e) => e.id == variantId);
    listVariant[index] =
        listVariant[index].copyWith(isChoose: !listVariant[index].isChoose);
    if (listVariant[index].promotionDetailEntity?.isEmpty ?? true) {
      final inputListPromo = PromotionWmListInput(
        variantId: variantId,
        tag: 'PMG',
        // customerId: state.customer,
      );
      final resListPromo =
          await _promotionDetailListUseCase.execute(inputListPromo);
      final dataEntity = resListPromo.response.data;
      listVariant[index] = listVariant[index].copyWith(
        promotionDetailEntity: dataEntity,
      );
    }
    emit(state.copyWith(listVariantSelect: listVariant));
    _totalPrice();
  }

  Future<List<VariantWmEntity>> getListVariant(int page) async {
    final input = VariantWmListInput(
      searchKey: state.searchKey,
      status: true,
      // customer: state.customer,
      tag: 'PMG',
      page: page + 1,
      limit: state.limit,
      // account: state.pharmacist?.id,
    );
    final res = await _variantGetListUseCase.execute(input);
    if (state.typeCreate == TypeCreateOrder.byPromotion) {
      emit(state.copyWith(listVariantSelect: res.response.data ?? []));
    }
    return res.response.data ?? <VariantWmEntity>[];
  }

  Future<OrderWmCreateOutput> createOrder() async {
    // orderItem của CTKM cho người tiêu dùng
    final List<OrderWmItemPayload> orderItemPromoForCustomer =
        state.listVariantSelect.fold([], (list, item) {
      list += (item.promotionDetailEntity ?? []).fold([], (total, e) {
        if (e.consumerData?.numOfApplications > 0 &&
            e.consumerData?.id != null &&
            item.isChoose) {
          total.add(
            OrderWmItemPayload(
              variant: e.consumerData?.variantId,
              quantity: e.consumerData?.numOfApplications *
                  e.consumerData?.quantityBonus,
              type: 2,
              variantPromotion: item.id,
            ),
          );
        }
        return total;
      });
      return list;
    });

    // convert Promotion in Variant to OrderItem
    final orderItemBonus = state.listVariantSelect.fold(<OrderWmItemPayload>[],
        (previousValue, ele) {
      final orderItemBonusTotal =
          ele.promotionDetailEntity?.fold(<OrderWmItemPayload>[], (list, e) {
        final orderItemBonusForOrder_1 =
            e.promotionItemData?.fold(<OrderWmItemPayload>[], (list, item) {
          if (item.quantitySelected != 0 && ele.isChoose) {
            list = list +
                (item.variantValueData ?? [])
                    .map(
                      (e) => OrderWmItemPayload(
                        variant: e.variant,
                        quantity: (e.quantity ?? 0) * item.quantitySelected,
                        type: 1,
                        variantPromotion: ele.id,
                      ),
                    )
                    .toList();
          }

          return list;
        });
        list += orderItemBonusForOrder_1 ?? [];
        return list;
      });
      previousValue += orderItemBonusTotal ?? [];
      return previousValue;
    });

    // Convert danh sách khuyến mãi đã chọn cho đơn thành orderItem
    final orderItemBonus_1 = convertPromotionForOrder;

    // Hàng tặng được tính vào đơn theo sản phẩm
    final orderItemGift = state.listVariantSelect
        .map(
          (e) => OrderWmItemPayload(
            variant: e.id,
            quantity: e.amountGift,
            type: 1,
          ),
        )
        .toList();

    // Hàng bán lẻ
    final orderItemRetail = state.listVariantSelect
        .where((e) => e.isChoose)
        .toList()
        .map(
          (e) => OrderWmItemPayload(
            variant: e.id,
            quantity: e.amountRetail,
          ),
        )
        .toList();

    // Hàng bán theo ctkm
    final orderItem = state.listVariantSelect
            .where((e) => e.isChoose)
            .toList()
            .map(
              (e) => OrderWmItemPayload(
                variant: e.id,
                quantity: e.amount,
                // priceList: state.listVariantSelect
                //     .firstWhere((v) => v.id == e.id)
                //     .pricePolicy
                //     ?.priceList,
                promotions: e.promotionDetailEntity?.fold([], (list, item) {
                  final check =
                      item.promotionItemData?.fold(false, (value, item) {
                    if (item.quantitySelected != 0) {
                      value = true;
                    }
                    return value;
                  });
                  if (check ?? false) {
                    list?.add(item.id!);
                  }
                  return list;
                }),
              ),
            )
            .toList() +
        orderItemRetail +
        orderItemBonus +
        orderItemBonus_1 +
        orderItemGift +
        orderItemPromoForCustomer;

    orderItem.removeWhere(
      (e) =>
          (e.quantity == 0 && e.type != 0) ||
          (e.quantity == 0 && (e.promotions ?? []).isEmpty),
    );

    final userPhone =
        AppSharedPreference.instance.getValue(PrefKeys.username) as String?;
    final id =
        AppSharedPreference.instance.getValue(PrefKeys.accountId) as int?;

    final orderCreateEntity = OrderWmCreatePayloadEntity(
      order: OrderWmInfoPayload(
        title:
            'Đơn hàng mới ${DateFormat('hh:mm - dd/MM/y').format(DateTime.now())}',
        tagSystem: 'PMG',
        note: state.note,
        discount: state.totalPriceDiscount.toDouble(),
        total: state.totalPrice,
        orderRed: state.selectedOrderRed,
        // account: 2,
        userPhone: userPhone ?? '',
        userId: id ?? 1,
        discountOrder: promoOrderDiscount,
        promotions: (state.promotionDetailEntityForTotalOrder ?? [])
                .map((e) => e.id!)
                .toList() +
            orderItem.fold([], (list, e) {
              list += e.promotions ?? [];
              return list;
            }),
      ),
      orderWmItemPayload: orderItem,
    );

    print(orderItem);

    // for (final item in orderItem) {
    //   print(item.toJson());
    // }

    // return OrderCreateOutput(BaseResponseModel());

    final res = await _orderCreateUseCase.execute(
      OrderWmCreateInput(
        orderCreateEntity: orderCreateEntity,
      ),
    );
    return res;
  }

  // Future<List<AccountEntity>> getListAccount(int page, String search) async {
  //   final company =
  //       AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
  //   final input = AccountListInput(
  //     search: search,
  //     limit: state.limit,
  //     page: page + 1,
  //     code: PrefKeys.codeNVTT,
  //     company: company,
  //   );
  //   final res = await _accountListUseCase.execute(input);
  //   return res.response.data ?? [];
  // }

  void confirmPromoForVariant({
    List<PromotionDetailEntity>? value,
    int? idVariant,
    required TypePromotion typePromotion,
  }) {
    if (typePromotion == TypePromotion.product) {
      final listVariantCopy =
          List<VariantWmEntity>.from(state.listVariantSelect);
      final index = listVariantCopy.indexWhere((e) => e.id == idVariant);
      listVariantCopy[index] = listVariantCopy[index].copyWith(
        promotionDetailEntity:
            value?.where((e) => e.applyPromotion == 0).toList(),
        promotionDetailForCustomer:
            value?.firstWhere((e) => e.applyPromotion == 1),
      );
      emit(state.copyWith(listVariantSelect: listVariantCopy));
    } else {
      emit(state.copyWith(promotionDetailEntityForTotalOrder: value));
    }
    _totalPriceDiscount();
  }

  void deletePromoForVariant({
    required int idVariant,
    required int idPromo,
  }) {
    final listVariantCopy = List<VariantWmEntity>.from(state.listVariantSelect);
    final index = listVariantCopy.indexWhere((e) => e.id == idVariant);
    final listPromoInVariant = List<PromotionDetailEntity>.from(
      listVariantCopy[index].promotionDetailEntity ?? [],
    );
    listPromoInVariant.removeWhere((e) => e.id == idPromo);
    listVariantCopy[index] = listVariantCopy[index]
        .copyWith(promotionDetailEntity: listPromoInVariant);
    emit(state.copyWith(listVariantSelect: listVariantCopy));
  }

  void changeQuantityPromo(
    BuildContext context, {
    required int idVariant,
    required int idPromo,
    required int idPromoItem,
    required bool isPlus,
  }) {
    bool hasNoSameTimePromo = false;
    int? idPromoNoSameTime;
    // int? idPromoHasQuantity;

    final listVariantCopy = List<VariantWmEntity>.from(state.listVariantSelect);
    final index = listVariantCopy.indexWhere((e) => e.id == idVariant);

    // Xử lý
    final listPromoInVariant = List<PromotionDetailEntity>.from(
      listVariantCopy[index].promotionDetailEntity ?? [],
    );

    final indexPromo = listPromoInVariant.indexWhere((e) => e.id == idPromo);

    final listPromoItem = List<PromotionItemDataEntity>.from(
      listPromoInVariant[indexPromo].promotionItemData ?? [],
    );
    final indexPromoItem = listPromoItem.indexWhere((e) => e.id == idPromoItem);

    // validate

    for (final item in listVariantCopy[index].promotionDetailEntity ??
        <PromotionDetailEntity>[]) {
      for (final e in item.promotionItemData ?? <PromotionItemDataEntity>[]) {
        if (e.quantitySelected != 0 && item.sameTime == false) {
          hasNoSameTimePromo = true;
          idPromoNoSameTime = item.id;
        }
        // if (e.quantitySelected != 0) {
        //   idPromoHasQuantity = e.id;
        // }
      }
    }

    if (listPromoItem[indexPromoItem].quantitySelected == 0 && !isPlus) {
      return;
    }

    if (hasNoSameTimePromo && idPromo != idPromoNoSameTime) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: red_1,
          content: Text(
            'Đã áp dụng CTKM không đồng thời',
            style: p5.copyWith(color: whiteColor),
          ),
        ),
      );
      return;
    }
    // else if (listPromoInVariant[indexPromo].sameTime == false && idPromoHasQuantity != null && isPlus) {
    //   ScaffoldMessenger.of(context).clearSnackBars();
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       backgroundColor: red_1,
    //       content: Text(
    //         'Đã áp dụng CTKM không đồng thời !',
    //         style: p5.copyWith(color: whiteColor),
    //       ),
    //     ),
    //   );
    //   return;
    // }

    if (listPromoInVariant[indexPromo].manyTime == false &&
        listPromoItem[indexPromoItem].quantitySelected == 1 &&
        isPlus) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: red_1,
          content: Text(
            'CTKM không áp dụng nhiều lần',
            style: p5.copyWith(color: whiteColor),
          ),
        ),
      );
      return;
    }
    listPromoItem[indexPromoItem] = listPromoItem[indexPromoItem].copyWith(
      quantitySelected:
          listPromoItem[indexPromoItem].quantitySelected + (isPlus ? 1 : -1),
    );
    listPromoInVariant[indexPromo] = listPromoInVariant[indexPromo]
        .copyWith(promotionItemData: listPromoItem);

    final totalAmount = listPromoInVariant.fold(0, (total, item) {
      total += (item.promotionItemData ?? []).fold(0, (previousValue, e) {
        previousValue += e.quantitySelected * (e.valueMin ?? 0).round();
        return previousValue;
      });

      return total;
    });

    listVariantCopy[index] = listVariantCopy[index].copyWith(
      promotionDetailEntity: listPromoInVariant,
      amount: totalAmount,
    );

    emit(state.copyWith(listVariantSelect: listVariantCopy));
    _updateQuantityPromoForCustomer(idVariant);
    _totalPrice();
  }

  List<OrderWmItemPayload> get convertPromotionForOrder {
    final orderItemBonus = (state.promotionDetailEntityForTotalOrder ?? [])
        .fold(<OrderWmItemPayload>[], (list, e) {
      final orderItemBonusForOrder =
          e.promotionItemData?.fold(<OrderWmItemPayload>[], (list, item) {
        if (item.typeDiscount == null && item.groupVariantData.isNotEmpty) {
          list += item.groupVariantData.fold([], (list, el) {
            if (el.amount != 0) {
              list += (el.variantValue ?? [])
                  .map(
                    (elem) => OrderWmItemPayload(
                      variant: elem.variant?.id,
                      quantity: (elem.quantity ?? 0) * el.amount,
                      type: 1,
                      promotionOrder: e.id,
                      timesApplyPromotion: item.quantitySelected,
                      variantData: elem.variant,
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
                      (e) => OrderWmItemPayload(
                        variant: e.variant,
                        quantity: (e.quantity ?? 0) * item.quantitySelected,
                        type: 1,
                        timesApplyPromotion: item.quantitySelected,
                        promotionItem: item.id,
                        variantData: VariantWmEntity(
                          id: e.id,
                          title: e.title ?? '',
                          image: e.image ?? '',
                          code: e.code ?? '',
                        ),
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

  /// This function convert [PromotionDetailEntity] => [Orderitem]
  ///
  /// If item [PromotionItemDataEntity] has type [TypePromotionItem.discountTicket]
  List<OrderWmItemPayload> get promoOrderDiscount {
    final orderItemBonus = (state.promotionDetailEntityForTotalOrder ?? [])
        .fold(<OrderWmItemPayload>[], (list, e) {
      final listPromo = e.promotionItemData
          ?.where((e) => e.type == TypePromotionItem.discountTicket)
          .toList();
      for (final item in (listPromo ?? <PromotionItemDataEntity>[])) {
        if (item.quantitySelected == 0) continue;
        list.add(
          OrderWmItemPayload(
            promotionItem: item.id,
            timesApplyPromotion: item.quantitySelected,
            discount: item.discountValue,
            minValueAplly: item.valueMin ?? 0,
            typeDiscount: item.typeDiscount,
          ),
        );
      }
      return list;
    });
    return orderItemBonus;
  }
}

class CustomerDropdownValue {
  final int? id;
  final String? name;
  final String? phone;

  CustomerDropdownValue({
    this.id,
    this.name,
    this.phone,
  });
}
