import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';

import '../../../../shared/constants/pref_key.dart';
import '../../../base/cache_image.dart';
import '../../../constants/typography.dart';
import '../../../shared/utils/event.dart';
import '../cubit/order_create_cubit/order_create_cubit.dart';
import '../cubit/order_create_cubit/order_create_state.dart';

class OrderCreatePreview extends StatelessWidget {
  const OrderCreatePreview({
    super.key,
    required this.myBloc,
  });

  final OrderCreateCubit myBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCreateCubit, OrderCreateState>(
      bloc: myBloc,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: sp24,
            horizontal: sp16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(sp16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp12),
                    color: whiteColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thông tin đơn hàng',
                        style: h6.copyWith(color: blackColor),
                      ),
                      gapHeight(sp24),
                    ],
                  ),
                ),
                gapHeight(sp16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(sp16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp12),
                    color: whiteColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thông tin khách hàng',
                        style: h6.copyWith(color: blackColor),
                      ),
                      gapHeight(sp24),
                      Text(
                        state.customerSelected?.name ?? 'Chưa có thông tin',
                        style: h6.copyWith(color: blackColor),
                      ),
                      gapHeight(sp8),
                      Text(
                        state.customerSelected?.address.toString() ??
                            'Chưa có thông tin',
                        style: p7.copyWith(color: greyColor),
                      ),
                      gapHeight(sp16),
                      RowItem(
                        title: 'Số điện thoại',
                        content: state.customerSelected?.phone ??
                            'Chưa có thông tin',
                      ),
                      gapHeight(sp12),
                      RowItem(
                        title: 'Ngày sinh',
                        content: 'Chưa có thông tin',
                      ),
                      gapHeight(sp12),
                      RowItem(
                        title: 'Email',
                        content: state.customerSelected?.email ??
                            'Chưa có thông tin',
                      ),
                      gapHeight(sp12),
                      RowItem(
                        title: 'CCCD/CMT',
                        content: 'Chưa có thông tin',
                      ),
                    ],
                  ),
                ),
                gapHeight(sp16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(sp16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp12),
                    color: whiteColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thông tin thanh toán',
                        style: h6.copyWith(color: blackColor),
                      ),
                      gapHeight(sp24),
                      Text(
                        '${FormatCurrency(state.orderPayment.mustPaid)} đ',
                        style: p3.copyWith(color: blackColor),
                      ),
                      gapHeight(sp8),
                      Text(
                        '${state.orderInfo.vat} %',
                        style: p5.copyWith(color: greyColor),
                      ),
                      gapHeight(sp24),
                      RowItem(
                        title: 'Trạng thái',
                        content: 'Chưa thanh toán',
                        contetnColor: yellow_1,
                      ),
                      gapHeight(sp12),
                      RowItem(
                        title: 'Chiết khấu',
                        content: '${state.orderInfo.discount ?? '0'} %',
                      ),
                      gapHeight(sp12),
                      RowItem(
                        title: 'Phí dịch vụ',
                        content:
                            '${FormatCurrency(state.orderInfo.servicePrice)} đ',
                      ),
                      gapHeight(sp12),
                      RowItem(
                        title: 'Khách phải trả',
                        content:
                            '${FormatCurrency(state.orderPayment.mustPaid)} đ',
                      ),
                      gapHeight(sp12),
                      RowItem(
                        title: 'Khách trả',
                        content:
                            '${FormatCurrency(state.orderPayment.hadPaid)} đ',
                      ),
                      gapHeight(sp12),
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: state.paymentItems.map((e) {
                          return Container(
                            padding: const EdgeInsets.all(sp16),
                            margin: const EdgeInsets.only(bottom: sp12),
                            decoration: BoxDecoration(
                              color: accentColor_4,
                              borderRadius: BorderRadius.circular(sp12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${e.title} (${e.isPaid ? 'Đã thanh toán' : 'Chưa thanh toán'})',
                                    style: p5.copyWith(color: greyColor),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${FormatCurrency(e.value)} đ',
                                    style: p5.copyWith(color: blackColor),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                gapHeight(sp24),
                Text(
                  'Danh sách sản phẩm',
                  style: h6.copyWith(color: blackColor),
                ),
                gapHeight(sp12),
                AppInputSupport(
                  hintText: 'Tìm kiếm sản phẩm',
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                  ),
                  backgroundColor: whiteColor,
                ),
                gapHeight(sp16),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: state.variantSelected.map((e) {
                    return Container(
                      padding: const EdgeInsets.all(sp16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(sp12),
                        color: whiteColor,
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: SizedBox(
                              height: sp48,
                              width: sp48,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(sp8),
                                child: BaseCacheImage(
                                  url: e.media ?? PrefKeys.imgProductDefault,
                                ),
                              ),
                            ),
                            title: Text(
                              e.name ?? 'Chưa có dữ liệu',
                              style: p5.copyWith(color: blackColor),
                            ),
                            subtitle: Text(
                              e.code ?? 'Chưa có dữ liệu',
                              style: p6.copyWith(color: greyColor),
                            ),
                          ),
                          RowItem(
                            title: 'Đơn giá',
                            content: '${FormatCurrency(e.priceSell)} đ',
                          ),
                          gapHeight(sp12),
                          RowItem(
                            title: 'Số lượng tồn',
                            content: e.quantityInStock.toString(),
                          ),
                          gapHeight(sp12),
                          RowItem(
                            title: 'Đơn vị',
                            content: e.units
                                    ?.firstWhere(
                                      (e) => e.isDefault,
                                    )
                                    .name ??
                                'Chưa có thông tin',
                          ),
                          gapHeight(sp12),
                          RowItem(
                            title: 'Số lượng',
                            content: e.amount.toString(),
                          ),
                          gapHeight(sp12),
                          RowItem(
                            title: 'Chiết khấu',
                            content: '${e.discount == 0 ? '' : e.discount} %',
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
