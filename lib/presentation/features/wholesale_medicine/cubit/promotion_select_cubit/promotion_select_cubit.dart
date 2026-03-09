import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/promotion_detail_wm_entity.dart';
import '../../domain/usecase/promotion_wm_detail_use_case.dart';
import '../../domain/usecase/promotion_wm_list_use_case.dart';
import 'promotion_select_state.dart';

@injectable
class PromotionSelectCubit extends Cubit<PromotionSelectState> {
  PromotionSelectCubit(
    this._promotionsUseCase,
    this._promotionDetailUseCase,
  ) : super(const PromotionSelectState());

  final PromotionWmListUseCase _promotionsUseCase;
  final PromotionDetailUseCase _promotionDetailUseCase;

  void initData({
    int? quantityVariantBuy,
    int? totalPriceBuy,
    TypePromotion? typePromotion,
    List<PromotionDetailEntity>? listPromoInit,
  }) {
    emit(
      state.copyWith(
        quantityVariantBuy: quantityVariantBuy,
        totalPriceBuy: totalPriceBuy,
        typePromotion: typePromotion ?? state.typePromotion,
        listPromoInit: listPromoInit ?? [],
      ),
    );
  }

  Future<void> getListPromotion(
    TypePromotion type,
    int value,
  ) async {
    emit(state.copyWith(valueQuery: value, isLoading: true));
    try {
      final input = PromotionWmListInput(
        variantId: type == TypePromotion.product ? state.valueQuery : null,
        orderValue: type == TypePromotion.orderTotal ? state.valueQuery : null,
        tag: 'PMG',
      );
      final res = await _promotionsUseCase.execute(input);
      if (res.response.code == 200) {
        emit(
          state.copyWith(
            promotions: res.response.data ?? [],
            isLoading: false,
            promotionDetailSelectedPromo: state.listPromoInit,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> getDetailPromo(int idPromo) async {
    emit(state.copyWith(isLoadingBts: true));
    try {
      final input = PromotionDetailInput(idPromo);
      final res = await _promotionDetailUseCase.execute(input);
      if (res.response.code == 200) {
        emit(
          state.copyWith(
            promotionDetail: res.response.data,
            isLoadingBts: false,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoadingBts: false));
    }
  }

  void changeAmountApply({
    required int idPromoItem,
    required int quantity,
    int? idGroupVariantItem,
  }) {
    if (quantity < 0) {
      return;
    }
    var promoDetail = state.promotionDetail;
    final listPromoItem = List<PromotionItemDataEntity>.from(
      promoDetail?.promotionItemData ?? [],
    );
    final index = listPromoItem.indexWhere((e) => e.id == idPromoItem);

    if (idGroupVariantItem != null) {
      final indexGroup = listPromoItem[index]
          .groupVariantData
          .indexWhere((e) => e.id == idGroupVariantItem);
      final listGroupCoppy = List<GroupVariantItemEntity>.from(
        listPromoItem[index].groupVariantData,
      );
      listGroupCoppy[indexGroup] =
          listGroupCoppy[indexGroup].copyWith(amount: quantity);
      listPromoItem[index] =
          listPromoItem[index].copyWith(groupVariantData: listGroupCoppy);
    } else {
      listPromoItem[index] =
          listPromoItem[index].copyWith(quantitySelected: quantity);
    }
    promoDetail = promoDetail?.copyWith(promotionItemData: listPromoItem);
    final listPromoSelected = List<PromotionDetailEntity>.from(
      state.promotionDetailSelectedPromo ?? [],
    );
    final indexPromoSelected =
        listPromoSelected.indexWhere((e) => e.id == promoDetail?.id);
    if (promoDetail != null && indexPromoSelected != -1) {
      listPromoSelected[indexPromoSelected] = promoDetail;
    }
    emit(
      state.copyWith(
        promotionDetail: promoDetail,
        promotionDetailSelectedPromo: listPromoSelected,
      ),
    );
  }

  ///Khi người dùng đến màn danh sách khuyến mãi cho sản phẩm
  ///
  ///Sau đó chọn vào 1 Khuyến mãi -> Validate Promo -> Show [BtsProductPromotionView]
  ///
  ///Hàm này được sử dụng khi người dùng nhấn Xác nhận bên trong Bottom Sheet đó [BtsProductPromotionView]
  void confirmProductForPromotion() {
    final listPromoDetailSelect = List<PromotionDetailEntity>.from(
      state.promotionDetailSelectedPromo ?? [],
    );
    if (state.promotionDetail != null) {
      final index = listPromoDetailSelect
          .indexWhere((e) => e.id == state.promotionDetail?.id);
      if (index == -1) {
        listPromoDetailSelect.add(state.promotionDetail!);
      } else {
        listPromoDetailSelect[index] = state.promotionDetail!;
      }
    }

    //validate if quantity select == 0 => remove from promotionDetailSelectedPromo
    final totalAmount =
        state.promotionDetail?.promotionItemData?.fold(0, (total, item) {
      if (item.typeDiscount != null || item.groupVariantData.isEmpty) {
        total += item.quantitySelected;
      } else {
        total += item.groupVariantData.fold(0, (previousValue, el) {
          previousValue += el.amount;
          return previousValue;
        });
      }
      return total;
    });
    if (totalAmount == 0 || totalAmount == null) {
      listPromoDetailSelect
          .removeWhere((e) => e.id == state.promotionDetail?.id);
    }
    emit(state.copyWith(promotionDetailSelectedPromo: listPromoDetailSelect));
  }

  ///This function validate button cancel, return quantity selected of state.promotionDetail
  void cancelBSTChangeQuantitySelected(PromotionDetailEntity? promotion) {
    final listPromoDetailSelect = List<PromotionDetailEntity>.from(
      state.promotionDetailSelectedPromo ?? [],
    );
    final index =
        listPromoDetailSelect.indexWhere((e) => e.id == promotion?.id);
    if (index != -1 && promotion != null) {
      listPromoDetailSelect[index] = promotion;
    }
    emit(
      state.copyWith(
        promotionDetail: promotion,
        promotionDetailSelectedPromo: listPromoDetailSelect,
      ),
    );
  }

  bool validateQuantity() {
    if (state.typePromotion == TypePromotion.orderTotal) {
      var totalPriceCanUse = state.totalPriceBuy ?? 0;
      final totalPrice =
          state.promotionDetail?.promotionItemData?.fold(0, (total, item) {
        if (item.typeDiscount != null || item.groupVariantData.isEmpty) {
          total += item.valueMin!.round() * item.quantitySelected;
        } else {
          total += item.groupVariantData.fold(0, (value, el) {
            value += el.amount * (item.valueMin?.round() ?? 0);
            return value;
          });
        }
        return total;
      });
      if (state.promotionDetail?.sameTime == true) {
        final totalCheck =
            state.promotionDetail?.promotionItemData?.fold(0, (total, e) {
          if (e.groupVariantData.isNotEmpty) {
            total += e.groupVariantData.fold(0, (value, el) {
              value += el.amount * (e.valueMin?.round() ?? 0);
              return value;
            });
          } else if (e.groupVariantData.isEmpty) {
            total += e.valueMin!.round() * e.quantitySelected;
          }
          return total;
        });
        final check = (totalCheck ?? 0) <= (state.totalPriceBuy ?? 0);
        if (!check) {
          emit(
            state.copyWith(
              messageErr: 'Số lượt áp dụng vượt quá điều kiện thực tế',
            ),
          );
          return false;
        }
        return check;
      }
      state.promotionDetailSelectedPromo?.forEach((item) {
        final totalCheck = item.promotionItemData?.fold(0, (total, e) {
          if ((e.typeDiscount == null && e.groupVariantData.isNotEmpty) &&
              item.id != state.promotionDetail?.id) {
            total += e.groupVariantData.fold(0, (value, el) {
              value += el.amount * (e.valueMin?.round() ?? 0);
              return value;
            });
          } else if ((e.typeDiscount != null || e.groupVariantData.isEmpty) &&
              item.id != state.promotionDetail?.id) {
            total += e.valueMin!.round() * e.quantitySelected;
          }
          return total;
        });
        totalPriceCanUse -= totalCheck ?? 0;
      });
      if ((totalPrice ?? 0) > totalPriceCanUse) {
        emit(
          state.copyWith(
            messageErr: 'Số lượt áp dụng vượt quá điều kiện thực tế',
          ),
        );
        return false;
      }
      return true;
    }
    var quantityCanUse = state.quantityVariantBuy ?? 0;
    final total =
        state.promotionDetail?.promotionItemData?.fold(0, (total, item) {
      total += item.valueMin!.round() * item.quantitySelected;
      return total;
    });
    // Kiểm tra trong List Promo Select đã áp dụng bao nhiêu khuyến mãi
    // Từ đó trừ vào [quantityCanUse]
    state.promotionDetailSelectedPromo?.forEach((item) {
      final totalCheck = item.promotionItemData?.fold(0, (total, item) {
        if (item.typeDiscount == null) {
          total += item.groupVariantData.fold(0, (value, el) {
            value += el.amount * (item.valueMin?.round() ?? 0);
            return value;
          });
        } else if (item.typeDiscount != null) {
          total += item.valueMin!.round() * item.quantitySelected;
        }
        return total;
      });
      quantityCanUse -= totalCheck ?? 0;
    });

    if ((total ?? 0) > quantityCanUse) {
      emit(
        state.copyWith(
          messageErr: 'Số lượt áp dụng vượt quá điều kiện thực tế',
        ),
      );
      return false;
    }
    emit(state.copyWith(messageErr: null));
    return true;
  }

  void handleClickPromo(int? idPromo) {
    emit(state.copyWith(messageErr: null));
    final indexPromo =
        state.promotionDetailSelectedPromo?.indexWhere((e) => e.id == idPromo);
    if (indexPromo == null || idPromo == null) return;
    if (indexPromo == -1) {
      getDetailPromo(idPromo);
    } else {
      emit(
        state.copyWith(
          promotionDetail: state.promotionDetailSelectedPromo?[indexPromo],
        ),
      );
    }
  }

  void unSelectedPromo(int? idPromo) {
    final listPromoSelected = List<PromotionDetailEntity>.from(
      state.promotionDetailSelectedPromo ?? [],
    );
    listPromoSelected.removeWhere((e) => e.id == idPromo);
    emit(state.copyWith(promotionDetailSelectedPromo: listPromoSelected));
  }

  /// Hàm này dùng để check xem điều kiện chọn khuyến mãi có hợp lệ không
  /// - Người dùng đã chọn Khuyến mại không áp dụng đồng thời và chọn 1 loại khuyến mãi khác -> [String]
  /// - Người dùng đã chọn 1 loại khuyến mãi và chọn tiếp loại khuyến mãi không áp dụng đồng thời -> [String]
  ///
  /// Hàm này sẽ trả về kiểu [String?]
  /// Nếu là kiểu [String] thì đã có lỗi xảy ra
  /// Nếu là kiểu [Null] thì các điều kiện đều hợp lệ
  String? validatePromotionSameTime(PromotionDetailEntity promoClick) {
    final indexInPromoSelected = state.promotionDetailSelectedPromo
        ?.indexWhere((e) => e.id == promoClick.id);

    final listPromotion = state.promotionDetailSelectedPromo ?? [];
    if (indexInPromoSelected != -1) {
      return null;
    }

    for (final item in listPromotion) {
      final bool isLimitOrderTrue =
          promoClick.limitOrder == true && item.limitOrder == true;

      final bool isLimitOrderFalse =
          promoClick.limitOrder == false && item.limitOrder == false;

      final bool isLimitOrder = isLimitOrderTrue || isLimitOrderFalse;

      if (item.sameTime == false) {
        return 'Đã chọn khuyến mãi không đồng thời';
      } else if (promoClick.sameTime == true && !isLimitOrder) {
        return promoClick.limitOrder == true
            ? 'Chỉ áp dụng cùng CTKM giới hạn theo tổng tiền'
            : 'Chỉ áp dụng cùng CTKM không giới hạn theo tổng tiền';
      }
    }

    if (promoClick.sameTime == false && listPromotion.isNotEmpty) {
      return 'Khuyến mãi áp dụng không đồng thời';
    }

    return null;
  }
}
