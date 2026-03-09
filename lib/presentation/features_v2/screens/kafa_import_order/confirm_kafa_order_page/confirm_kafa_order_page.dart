import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../../base/svg.dart';
import '../../../../di/di.dart';
import '../../../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../../../models/variant_kafa/variant_kafa_model.dart';
import '../components/variant_order_confirm_card.dart';

@RoutePage()
class ConfirmKafaOrderPage extends StatefulWidget {
  const ConfirmKafaOrderPage({super.key});

  @override
  State<ConfirmKafaOrderPage> createState() => _ConfirmKafaOrderPageState();
}

class _ConfirmKafaOrderPageState extends State<ConfirmKafaOrderPage> {
  final shoppingBloc = getIt.get<ShoppingCartBloc>();

  List<VariantKafaModel> list = [];

  @override
  void initState() {
    list = shoppingBloc.list.where((e) => e.isReadyForOrder).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        title: 'Xác nhận đơn hàng',
      ),
      backgroundColor: ColorApp.greyF5,
      body: Container(
        padding: 16.pading,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInfoDelivery(),
              8.height,
              _buildAddress(),
              8.height,
              _buildListProd(),
              8.height,
              _buildTypePayment(),
              8.height,
              _buildElectronicInvoice(),
              8.height,
              _buildTotalPrice(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottom(),
    );
  }

  _buildInfoDelivery() {
    return Column(
      children: [
        Container(
          padding: 12.pading,
          decoration: BoxDecoration(
            color: ColorApp.black79,
            borderRadius: 8.radius,
            border: Border.all(color: ColorApp.black.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              IcSvg.asset('/ic_truck.svg')
                  .size(height: 20, width: 20)
                  .container(
                    bgColor: ColorApp.black79,
                    radius: 999,
                    padding: 8.pading,
                  ),
              8.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Giao nhanh',
                    style: StyleApp.bold(
                      color: ColorApp.black,
                    ),
                  ),
                  Text(
                    'Nhận trước ngày DD/MM/YYYY',
                    style: StyleApp.bold(
                      color: ColorApp.grey79,
                    ),
                  ),
                ],
              ).expanded(),
              4.width,
              Text(
                'Thay đổi',
                style: StyleApp.bold(color: ColorApp.main),
              ).unDev(context),
            ],
          ),
        ),
        const Divider(
          thickness: 1,
        ),
        Row(
          children: [
            IcSvg.asset('/ic_paymoney.svg'),
            8.width,
            Text(
              'Hoàn trả trong 15 ngày',
              style: StyleApp.normal(fontSize: 12, color: ColorApp.grey76),
            ).expanded(),
            const Icon(Icons.keyboard_arrow_right_outlined),
          ],
        ).unDev(context),
        Row(
          children: [
            IcSvg.asset('/ic_guard.svg'),
            8.width,
            Text(
              'Mua trước trả sau',
              style: StyleApp.normal(fontSize: 12, color: ColorApp.grey76),
            ).expanded(),
            const Icon(Icons.keyboard_arrow_right_outlined),
          ],
        ).unDev(context),
      ],
    ).container(padding: 16.pading);
  }

  _buildAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.location_on_sharp,
              color: ColorApp.grey79,
            ).container(
              bgColor: ColorApp.black79,
              padding: 8.pading,
              radius: 999,
            ),
            8.width,
            Text(
              'Địa chỉ giao hàng',
              style: StyleApp.bold(),
            ).expanded(),
          ],
        ),
        14.height,
        Text(
          'Địa chỉ',
          style: StyleApp.normal(color: ColorApp.grey79),
        ),
        Row(
          children: [
            Text(
              getAddressCompany.validator,
              style: StyleApp.bold(),
            ).expanded(),
            8.width,
            const Icon(
              Icons.edit_outlined,
              size: 16,
            )
                .container(
                  bgColor: ColorApp.black79,
                  padding: 8.pading,
                  radius: 999,
                )
                .unDev(context),
          ],
        ),
      ],
    ).container(padding: 16.pading);
  }

  _buildListProd() {
    return Column(
      children: [
        _buildListProdHeader(),
        _buildListProdItem(),
        _buildListPromoHeader(),
        16.height,
        _buildListPromoItem(),
      ],
    ).container(padding: 16.pading);
  }

  _buildListProdHeader() {
    return Row(
      children: [
        const Icon(
          Icons.list_alt_outlined,
          size: 16,
          color: ColorApp.grey79,
        ),
        4.width,
        Text(
          'Danh sách sản phẩm (${shoppingBloc.list.where((e) => e.isReadyForOrder).length})',
          style: StyleApp.bold(
            color: ColorApp.grey79,
          ),
        ).expanded(),
        InkWell(
          onTap: () {
            context.router.maybePop();
          },
          child: Text(
            'Chỉnh sửa',
            style: StyleApp.bold(color: ColorApp.main),
          ),
        ),
      ],
    );
  }

  _buildListProdItem() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return VariantOrderConfirmCard(
          variant: list[index],
        );
      },
      separatorBuilder: (context, index) {
        return 8.height;
      },
      itemCount: list.length,
    );
  }

  _buildListPromoHeader() {
    return Row(
      children: [
        IcSvg.asset('/ic_badge_per_v2.svg').size(height: 16, width: 16),
        4.width,
        Text(
          'Giảm giá đơn hàng',
          style: StyleApp.bold(
            color: ColorApp.grey79,
          ),
        ).expanded(),
        // InkWell(
        //   onTap: () {
        //     context.router.maybePop();
        //   },
        //   child: Text(
        //     'Chỉnh sửa',
        //     style: StyleApp.bold(color: ColorApp.main),
        //   ),
        // ),
      ],
    );
  }

  _buildListPromoItem() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final promo = shoppingBloc.promoOrderDiscount[index];
        return RowItem(
          title:
              'Giá trị tối thiểu ${FormatCurrency(promo.minValueApply)}đ (SL: ${promo.timesApplyPromotion.toString()})',
          content: promo.typeDiscount == 1
              ? '${FormatCurrency((promo.timesApplyPromotion ?? 0) * promo.discount)}đ'
              : '${(promo.timesApplyPromotion ?? 0) * promo.discount}%',
          titleStyle: StyleApp.normal(color: ColorApp.grey79),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 8,
      ),
      itemCount: shoppingBloc.promoOrderDiscount.length,
    );
  }

  _buildTypePayment() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phương thức thanh toán (sắp có)',
              style: StyleApp.bold(),
            ),
            4.height,
            Text(
              'Vui lòng chọn phương thức thanh toán',
              style: StyleApp.normal(
                fontSize: 12,
                color: ColorApp.grey79,
              ),
            ),
          ],
        ).expanded(),
        Text(
          'Chọn',
          style: StyleApp.bold(
            color: ColorApp.main,
          ),
        ).unDev(context),
      ],
    ).container();
  }

  _buildElectronicInvoice() {
    return Row(
      children: [
        Text(
          'Xuất hóa đơn điện tử',
          style: StyleApp.bold(),
        ).expanded(),
        const Icon(Icons.keyboard_arrow_right_outlined),
      ],
    ).container().unDev(context);
  }

  _buildTotalPrice() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RowItem(
          title: 'Tạm tính',
          content: '${FormatCurrency(shoppingBloc.total - shoppingBloc.totalPriceDiscount)} đ',
          titleStyle: StyleApp.normal(
            color: ColorApp.grey79,
          ),
        ),
        const Divider(
          thickness: 1,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tổng tiền',
              style: StyleApp.normal(color: ColorApp.black),
            ),
            16.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${FormatCurrency(shoppingBloc.total - shoppingBloc.totalPriceDiscount)} đ',
                  style: StyleApp.bold(color: ColorApp.main),
                ),
                Text(
                  '(Giá này đã bao gồm các thể loại phí VAT, VAC, và nhiều loại thuế phí khác)',
                  style: StyleApp.normal(
                    color: ColorApp.grey79,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ).expanded(),
          ],
        ),
      ],
    ).container();
  }

  _buildBottom() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            AppInput(
              hintText: '',
              label: 'Tổng tiền',
              readOnly: true,
              autofocus: true,
              initialValue: '${FormatCurrency(shoppingBloc.total)} đ',
              labelStyle: StyleApp.normal(
                fontSize: 12,
                color: ColorApp.grey79,
              ),
              style: StyleApp.bold(
                color: ColorApp.main,
              ),
            ).expanded(flex: 5),
            16.width,
            MainButton(
              title: 'Mua ngay',
              radius: 999,
              event: _onBuyNow,
            ).expanded(flex: 2),
          ],
        ),
      ],
    ).container();
  }

  _onBuyNow() {
    DialogUtils.showLoadingDialog(context, 'Đang tạo đơn hàng...');
    shoppingBloc.createOrder().then((value) {
      Navigator.of(context).pop();
      if (value.code == 200) {
        shoppingBloc.removeSuccessOrder();
        DialogUtils.showSuccessDialog(
          context,
          content: 'Tạo đơn hàng thành công',
          titleClose: 'Danh sách',
          titleConfirm: 'Xem đơn hàng',
          close: () {
            context.router
                .popUntil((route) => route.settings.name == 'HomeRoute');
            context.router.push(const ListImportOrderRoute());
          },
          accept: () {
            context.router
                .popUntil((route) => route.settings.name == 'HomeRoute');

            context.router.push(const ListImportOrderRoute());
            context.router.push(KafaOrderDetailRoute(id: value.data));
          },
        );
      } else {
        DialogUtils.showErrorDialog(context, content: '${value.message}');
      }
    });
  }
}
