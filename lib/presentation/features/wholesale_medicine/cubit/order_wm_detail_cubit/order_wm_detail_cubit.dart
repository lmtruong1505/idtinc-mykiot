import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/order_wm_entity.dart';
import '../../domain/usecase/order_wm_detail_use_case.dart';
import '../order_wm_create_cubit/order_wm_create_state.dart';
import 'order_wm_detail_state.dart';

@injectable
class OrderWmDetailCubit extends Cubit<OrderWmDetailState> {
  OrderWmDetailCubit(
    this._orderExportDetailUseCase,
  ) : super(const OrderWmDetailState());

  final OrderWmDetailUseCase _orderExportDetailUseCase;

  final List<DropdownMenuItem> listReaseon = [
    const DropdownMenuItem(
      value: 1,
      child: Text('Sản phẩm lỗi/hỏng'),
    ),
    const DropdownMenuItem(
      value: 2,
      child: Text('Giao hàng không đúng số lượng'),
    ),
    const DropdownMenuItem(
      value: 3,
      child: Text('Khác'),
    ),
  ];

  void reasonChange(value) {
    final reason = listReaseon.firstWhere((e) => e.value == value);
    late String titleReason;
    switch (reason.value) {
      case 1:
        titleReason = 'Sản phẩm lỗi/hỏng';
        break;
      case 2:
        titleReason = 'Giao hàng không đúng số lượng';
        break;
      default:
        titleReason = '';
    }
    emit(state.copyWith(idReasonDeny: value, titleReason: titleReason));
  }

  void titleReasonChange(String value) {
    emit(state.copyWith(titleReason: value));
  }

  Future<void> initData(data) async {
    getDetailExportOrder(data);
    emit(
      state.copyWith(
        data: data,
      ),
    );
    // if (data is OrderWmDetailEntity) {
    //   final variants = data.variants.where((e) => e.type == 0).toList();
    //   final variatnsPromo = data.variants.where((e) => e.type == 1).toList();
    //   emit(
    //     state.copyWith(
    //       orderDetail: data,
    //       variants: variants,
    //       variantsPromo: variatnsPromo,
    //     ),
    //   );
    // } else {
    //   switch (state.typeOrder) {
    //     case TypeOrder.cHTH:
    //       await getDetailExportOrder(data);
    //       break;
    //     default:
    //       // await getDetailImportOrder(data);
    //       break;
    //   }
    // }

    emit(state.copyWith(isLoading: false));

    _groupVariant();
    _groupVariantPromoGift();
  }

  void _groupVariant() {
    final orderItem = List<OrderItemEntity>.from(state.variantsPromo);
    final newOrderItem = orderItem.toList();
    for (final item in state.variantsPromo) {
      final variants =
          state.variantsPromo.where((e) => e.id == item.id).toList();

      if (variants.length == 1) {
        continue;
      } else {
        final totalQuantity = variants.fold(0, (total, item) {
          total += item.amount ?? 0;
          return total;
        });

        final variant = OrderItemEntity(
          id: item.id,
          name: item.name,
          amount: totalQuantity,
          quantityInStock: item.quantityInStock,
          priceSell: item.priceSell,
          image: item.image,
          models: item.models,
          type: item.type,
        );

        newOrderItem.removeWhere((e) => e.id == item.id);
        newOrderItem.add(variant);
      }
    }
    emit(state.copyWith(variantsPromo: newOrderItem));
  }

  void _groupVariantPromoGift() {
    final orderItem = List<OrderItemEntity>.from(state.variantsGift);
    final newOrderItem = orderItem.toList();
    for (final item in state.variantsGift) {
      final variants =
          state.variantsGift.where((e) => e.id == item.id).toList();

      if (variants.length == 1) {
        continue;
      } else {
        final totalQuantity = variants.fold(0, (total, item) {
          total += item.amount ?? 0;
          return total;
        });

        final variant = OrderItemEntity(
          id: item.id,
          name: item.name,
          amount: totalQuantity,
          quantityInStock: item.quantityInStock,
          priceSell: item.priceSell,
          image: item.image,
          models: item.models,
          type: item.type,
          variantParentPromo: item.variantParentPromo,
        );

        newOrderItem.removeWhere((e) => e.id == item.id);
        newOrderItem.add(variant);
      }
    }
    emit(state.copyWith(variantsGift: newOrderItem));
  }

  // void getDetailDrafOrder({
  //   required int id,
  // }) {
  //   final input = OrderWmDetailDrafInput(id: id);
  //   final res = _orderWmDetailDrafUseCase.buildUseCase(input);
  //   emit(state.copyWith(orderWmDetail: res.order));
  // }

  /// Delete Order has TypeOrder is Draf [TypeOrder]
  ///
  /// Delete Order by get list from local [AppSharedPreference]
  ///
  /// After Delete, set new list to local [AppSharedPreference]
  // void deleteOrderDraf() {
  //   final shared = AppSharedPreference.instance;
  //   final json = shared.getValue(PrefKeys.orderDrafExport);
  //   if (json == null) return;
  //   final listJson = jsonDecode(json as String);
  //   final listOrder = (listJson as List)
  //       .map((item) => OrderWmDetailEntity.fromJson(item))
  //       .toList();
  //   listOrder.removeWhere((e) => e.id == state.orderWmDetail?.id);
  //   shared.setValue(
  //     PrefKeys.orderDrafExport,
  //     jsonEncode(listOrder.map((e) => e.toJson()).toList()),
  //   );
  // }

  // void onConfirmHandle(BuildContext context, {required int status}) {
  //   if (state.orderWmDetail?.isOnline ?? false) {
  //     if (!validateOrderOnline) {
  //       DialogUtils.showErrorDialog(context,
  //           content:
  //               'Có sản phẩm không đủ số lượng bán.\nVui lòng cập nhật lại đơn hàng\nhoặc số lượng tồn kho của sản phẩm');
  //       return;
  //     }
  //     confirmOrderOnline(context);
  //     return;
  //   }
  //   updateStatus(status);
  // }

  // bool get validateOrderOnline {
  //   for (final item in (state.orderWmDetail?.variants ?? <OrderItemEntity>[])) {
  //     if ((item.quantityInStock ?? 0) < (item.amount ?? 0)) {
  //       return false;
  //     }
  //   }
  //   return true;
  // }

  Future<void> getDetailExportOrder(int id) async {
    final input = OrderWmDetailInput(id: id);
    final res = await _orderExportDetailUseCase.execute(input);
    final variants =
        res.response.data?.variants.where((e) => e.type == 0).toList();
    final variatnsPromo = res.response.data?.variants
        .where((e) => e.type == 1 && e.variantParentPromo == null)
        .toList();
    final variantsGift = res.response.data?.variants
        .where((e) => e.type == 1 && e.variantParentPromo != null)
        .toList();
    emit(
      state.copyWith(
        orderDetail: res.response.data,
        isLoading: false,
        variants: variants ?? [],
        variantsPromo: variatnsPromo ?? [],
        variantsGift: variantsGift ?? [],
      ),
    );
  }

  // Future<void> getDetailImportOrder(int id) async {
  //   final input = OrderImportDetailInput(id);
  //   final res = await _orderImportDetailUseCase.execute(input);
  //   emit(state.copyWith(orderWmDetail: res.response.data, isLoading: false));
  // }

  // /// update status by status id
  // /// Status id system is:
  // /// 1. Chờ xác nhận
  // /// 2. Đã xác nhận
  // /// 3. Từ chối
  // /// 4. Hoàn thành
  // /// 5. Đã huỷ
  // ///
  // /// Response is [OrderSystemUpdateStatusOutput]
  // Future<void> updateStatus(int status) async {
  //   final input = OrderUpdateStatusInput(
  //     id: state.orderWmDetail?.id ?? 0,
  //     status: status,
  //   );
  //   final res = await _orderUpdateStatusUseCase.execute(input);
  //   if (res.response.code == 200) {
  //     emit(state.copyWith(isLoading: true));
  //     await initData(
  //       state.orderWmDetail?.id,
  //       state.typeOrder!,
  //       state.isDrafOrder,
  //     );
  //   }
  // }

  // Future<void> confirmOrderOnline(BuildContext context) async {
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     context: context,
  //     builder: (context) => ConfirmPaymentBts(
  //       onConfirm: (TypePayment typePayment) async {
  //         switch (typePayment) {
  //           case TypePayment.qrCode:
  //             renderQrCode(context);
  //             break;
  //           default:
  //             Navigator.of(context).pop();
  //             updateStatus(4);
  //         }
  //       },
  //       totalPrice: state.orderWmDetail?.total ?? 0,
  //     ),
  //   );
  // }

  // Future<void> renderQrCode(BuildContext context) async {
  //   final cardBank = await getIt.get<CardBankCubit>().getCard();
  //   if (cardBank == null || state.orderWmDetail?.id == null) {
  //     return;
  //   }
  //   final input = OrderQrcodeInput(
  //     cardId: cardBank.id ?? 0,
  //     orderId: state.orderWmDetail!.id!,
  //   );
  //   final res = await _orderQrcodeUseCase.execute(input);
  //   if (state.orderWmDetail != null && context.mounted) {
  //     context.router.push(
  //       QrCodePaymentRoute(
  //         qrcodeInfo: res.response.data,
  //         cardEntity: cardBank,
  //         orderWmDetailEntity: state.orderWmDetail!,
  //         onConfirm: () {
  //           updateStatus(4);
  //           context.router.push(
  //             OrderWmDetailRoute(
  //               order: state.orderWmDetail!.id!,
  //               typeOrder: TypeOrder.cHTH,
  //             ),
  //           );
  //         },
  //       ),
  //     );
  //   }
  // }

  // Future<void> cancelOrder(BuildContext context) async {
  //   DialogUtils.showLoadingDialog(
  //     context,
  //     content: 'Đang huỷ đơn, vui lòng đợi',
  //   );
  //   if (state.typeOrder == TypeOrder.ad) {
  //     final input = OrderCancelInput(
  //       order: state.orderWmDetail?.id ?? 0,
  //       reason: state.idReasonDeny ?? 1,
  //       title: state.titleReason,
  //     );
  //     final res = await _orderCancelUseCase.execute(input);
  //     if (res.response.code == 200) {
  //       emit(state.copyWith(isLoading: true));
  //       await initData(
  //         state.data,
  //         state.typeOrder!,
  //         state.isDrafOrder,
  //       );
  //       Navigator.of(context).pop();
  //     }
  //     return;
  //   }
  // }

}
