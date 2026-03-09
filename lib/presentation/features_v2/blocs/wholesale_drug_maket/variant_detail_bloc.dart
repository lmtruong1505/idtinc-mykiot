import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features_v2/models/product/drug_category_model.dart.dart';
import 'package:pharmago/presentation/features_v2/models/product/voucher_model.dart.dart';
import 'package:pharmago/presentation/features_v2/repositories/wholesale_drug/cart_vouchers_repo.dart';

import '../../models/variant_kafa/variant_kafa_model.dart';
import '../../repositories/wholesale_drug/variant_kafa_repository.dart';
import '../state/init_state.dart';

@injectable
class VariantDetailBloc extends Cubit<CubitState<VariantKafaModel>> {
  VariantDetailBloc(this._repo, this.vouchersRepo) : super(CubitState());

  final VariantKafaRepository _repo;
  final CartVouchersRepo vouchersRepo;

  List<VoucherModel> vouchers = [];
  bool showTotalPrice = true;
  bool _isReloadPrePage = false;
  bool get isReloadPrePage => _isReloadPrePage;
  VoucherModel? voucherSelect;
  VoucherModel? voucherSelected;

  num get totalDiscount {
    final items = voucherSelected?.promotionItems;

    final typeDiscount =
        items?.firstOrNull?.type; //tìm discount type :dạng % hay tiền mặt :1-2

    return (typeDiscount == 1) //==1 tiền mặt ,==2 %
        ? voucherPromotionActive?.discount ?? 0
        : totalPrice * (voucherPromotionActive?.discount ?? 0) / 100;
  }

  num get totalPrice {
    final prd = state.data;
    return (prd?.quantityInCart ?? 0) * (prd?.price ?? 0);
  }

  PromotionVoucherItem? get voucherPromotionActive {
    final items = voucherSelected?.promotionItems;
    //tìm chương trình khuyến mãi hợp lệ
    //chọn item đang thoả mãn cuối cùng
    return items?.lastWhereOrNull((item) => totalPrice >= (item.valueMin ?? 0));
  }

  List<DrugCategoryModel> get prdSelected {
    final prd = state.data;
    return [prd!.toDrugCategoryModel()];
  }

  void getDetail(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getDetail(id: id);

    emit(state.copyWith(status: BlocStatus.success, data: res.data));
  }

  void toggleShowPrice() {
    showTotalPrice = !showTotalPrice;
    emit(state.copyWith(status: BlocStatus.reload));
  }

  void setReload(bool value) {
    _isReloadPrePage = value;
  }

  // void getPromotion(int variant) async {
  //   emit(state.copyWith(status: BlocStatus.loading));
  //   final res = await _repo.getPromotionKafa(variant: variant);
  //   final promo = (res.data ?? [])
  //       .where((e) => e.promotionTypeData?.id.validator == 4)
  //       .toList();
  //   emit(
  //     state.copyWith(
  //       status: BlocStatus.success,
  //       data: state.data?.copyWith(promotionDetail: promo),
  //     ),
  //   );
  // }

  // void updateVariant(VariantKafaModel model) {
  //   emit(
  //     state.copyWith(
  //       data: model,
  //     ),
  //   );
  //   getCountCTKM();
  //   getCountQuantity();
  // }

  // void getCountCTKM() {
  //   if (state.data == null) return;
  //   _countCTKM = state.data!.promotionDetail.fold(0, (total, promo) {
  //     bool haveQuantity = false;
  //     promo.promotionItemData?.forEach((element) {
  //       if (element.quantitySelected != 0) {
  //         haveQuantity = true;
  //       }
  //     });
  //     if (haveQuantity) {
  //       total++;
  //     }
  //     return total;
  //   });
  // }

  // void getCountQuantity() {
  //   if (state.data == null) return;
  //   _countQuantity = state.data!.amount + quantityVariantInPromotion;
  // }

  // int get quantityVariantInPromotion {
  //   return state.data!.promotionDetail.fold(0, (total, promo) {
  //     final totalInPromo =
  //         promo.promotionItemData?.fold(0, (total_2, variantPromo) {
  //       return total_2 +
  //           (variantPromo.quantitySelected) *
  //               (variantPromo.valueMin?.toInt() ?? 0);
  //     });
  //     return total + (totalInPromo ?? 0);
  //   });
  // }

  // bool validateModel(VariantKafaModel model) {
  //   final quantity = model.amount +
  //       model.promotionDetail.fold(0, (total, promo) {
  //         final totalInPromo =
  //             promo.promotionItemData?.fold(0, (total_2, variantPromo) {
  //           return total_2 +
  //               (variantPromo.quantitySelected) *
  //                   (variantPromo.valueMin?.toInt() ?? 0);
  //         });
  //         return total + (totalInPromo ?? 0);
  //       });
  //   return quantity > 0;
  // }

  void getVouchers() async {
    final res = await vouchersRepo.getVouchers();
    if (res.code == 200) {
      vouchers = res.data ?? [];
      // emit(state.copyWith(status: BlocStatus.success));
    } else {
      // emit(state.copyWith(status: BlocStatus.failure));
    }
  }

  void onInput(int quantity) {
    _isReloadPrePage = true;
    emit(state.copyWith(data: state.data?.copyWith(quantityInCart: quantity)));
  }

  void confirmVoucher(VoucherModel? value) {
    voucherSelected = value;
    // emit(state.copyWith(status: BlocStatus.success));
  }
}
