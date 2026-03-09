import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/models/product/voucher_model.dart.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

@injectable
class CartVoucherBloc extends Cubit<CubitState> {
  CartVoucherBloc() : super(CubitState());

  String? search;
  List<VoucherModel>? vouchers;
  num totalPrice = 0;
  VoucherModel? voucherSelect;
  final delay = DelayCallBack();

  PromotionVoucherItem? get promotionVoucherSelect {
    final items = voucherSelect?.promotionItems;
    //tìm chương trình khuyến mãi hợp lệ trong màn voucher giảm giá
    //lấy chương trình đang chọn
    //chọn item đang thoả mãn cuối cùng
    return items?.lastWhereOrNull((item) => totalPrice >= (item.valueMin ?? 0));
  }

  List<VoucherModel>? get vouchersSearch => vouchers!
      .where(
        (v) => (v.title ?? '').contains(search ?? ''),
      )
      .toList();

  num get totalDiscountInVoucherScreen {
    final items = voucherSelect?.promotionItems;

    final typeDiscount =
        items?.firstOrNull?.type; //tìm discount type :dạng % hay tiền mặt :1-2

    return (typeDiscount == 1) //==1 tiền mặt ,==2 %
        ? promotionVoucherSelect?.discount ?? 0
        : totalPrice * (promotionVoucherSelect?.discount ?? 0) / 100;
  }

  void selectVoucher(VoucherModel? voucher) {
    voucherSelect = voucher;
    emit(state.copyWith(status: BlocStatus.success));
  }

  void onVoucherSearch(String value) {
    delay.debounce(() {
      search = value;
      emit(state.copyWith(status: BlocStatus.reload));
    });
  }

  void initData(
    List<VoucherModel>? listVoucher,
    num price,
    VoucherModel? voucher,
  ) {
    vouchers = listVoucher;
    totalPrice = price;
    voucherSelect = voucher;
    emit(state.copyWith(status: BlocStatus.success));
  }
}
