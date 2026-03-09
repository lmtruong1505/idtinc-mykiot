import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/features/wallet/bloc/bloc/wallet_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/order_v2/order_create_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/order_v2/order_manager_bloc.dart';
import 'package:pharmago/presentation/features_v2/models/service/service.dart';
import 'package:pharmago/presentation/features_v2/screens/order/components/product_in_cf.dart';
import 'package:pharmago/presentation/features_v2/screens/order/components/service_in_cf.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../gen/assets.dart';
import '../../../../shared/components/button/double_button.dart';
import '../../../../shared/components/button/switch_label.dart';
import '../../../../shared/components/dialog/dialog_message.dart';
import '../../../../shared/components/toast/toast_custom.dart';
import '../../../../shared/constants/pref_key.dart';
import '../../../base/cache_image.dart';
import '../../../base/v2/text_row.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../../../features/company/data/models/point_exchange_package_model.dart';
import '../../../features/home/cubit/nav_home_bloc.dart';
import '../../../router/router.gr.dart';
import '../../../shared/utils/event.dart';
import '../../models/product/product_v2_model.dart';
import 'components/confirm_order_prescription.dart';
import 'components/selection/customer_chose.dart';

@RoutePage()
class ConfirmOrderPage extends StatefulWidget {
  const ConfirmOrderPage({super.key, required this.bloc});

  final OrderCreateBloc bloc;

  @override
  State<ConfirmOrderPage> createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  OrderCreateBloc get _bloc => widget.bloc;

  final walletBloc = getIt.get<WalletBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTitleCenter(title: 'Xác nhận đơn hàng'),
      body: Container(
        padding: 16.pading,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Khách hàng',
                style: AppStyle.headingLg,
              ),
              12.height,
              _buildCustomer,
              _confirmOrderPrescription,
              _buildServices,
              24.height,
              Visibility(
                visible: widget.bloc.products.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Danh sách sản phẩm',
                      style: AppStyle.headingLg,
                    ),
                    12.height,
                    _buildProds,
                  ],
                ),
              ),
              Visibility(
                visible: widget.bloc.productsPointExchange?.isNotEmpty ?? false,
                child: Column(
                  spacing: sp16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quà tặng từ đổi điểm',
                      style: AppStyle.headingLg,
                    ),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = widget.bloc.productsPointExchange?[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.all(sp0),
                          leading: BaseCacheImage(
                            loadPharmagoLogo: true,
                            url: item?.images?.firstOrNull?.url ?? '',
                            width: 50,
                            height: 50,
                            borderRadius: 4.radius,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            item?.name ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyle.bodyBsMedium.copyWith(
                              height: 1.5,
                              color: AppColors.text_primary,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                '${item?.exchangePoint ?? 0}',
                                style: s14w500.copyWith(
                                  color: AppColors.text_primary,
                                ),
                              ),
                              sp8.width,
                              SvgPicture.asset('assets/svg/point.svg'),
                              const Spacer(),
                              Text(
                                'SL: ${item?.quantity}',
                                style: s14w500.copyWith(
                                  color: AppColors.text_primary,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const Divider(height: sp24),
                      itemCount: widget.bloc.productsPointExchange?.length ?? 0,
                    ),
                    const Divider(
                      thickness: 1,
                      color: AppColors.border_tertiary,
                    ),
                    ...(widget.bloc.productsFromPackage ?? []).map((e) {
                      return _itemPackage(e);
                    }),
                  ],
                ),
              ),
              24.height,
              Text(
                'Thanh toán',
                style: AppStyle.headingLg,
              ),
              12.height,
              _payment,
              24.height,
              _note,
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottom,
    );
  }

  Widget get _buildCustomer {
    if (widget.bloc.customer == null) {
      return Text(
        'Khách lẻ',
        style: AppStyle.headingMd.copyWith(
          color: AppColors.text_tertiary,
        ),
      ).container(
        padding: 12.pading,
        radius: 12,
        bgColor: AppColors.bg_secondary,
        border: Border.all(
          color: AppColors.border_tertiary,
          width: 1,
        ),
      );
    } else {
      return CustomerChose(
        model: widget.bloc.customer!,
        showInfo: false,
      );
    }
  }

  Widget get _buildProds {
    return ListView.separated(
      shrinkWrap: true,
      padding: 0.pading,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.bloc.products.length,
      itemBuilder: (context, index) {
        return ProductInCf(idx: index + 1, model: widget.bloc.products[index]);
      },
      separatorBuilder: (context, index) => const Divider(
        thickness: 1,
        color: AppColors.border_tertiary,
      ),
    );
  }

  Widget get _buildServices {
    if (_bloc.type != 'service') {
      return 0.height;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        24.height,
        Text(
          'Danh sách dịch vụ',
          style: AppStyle.headingLg,
        ),
        ..._bloc.services.map(
          (e) => ServiceInCf(idx: _bloc.services.indexOf(e) + 1, model: e),
        ),
      ],
    );
  }

  Widget get _payment {
    final balance = walletBloc.wallet?.balance;
    final List<ProductV2Model> products = _bloc.products
        .where(
          (element) => element.vat != 0,
        )
        .toList();
    final Map<num, num> vatInfo = {};
    for (final prod in products) {
      if (!vatInfo.containsKey(prod.vat)) {
        vatInfo[prod.vat.validator] =
            prod.quantity.validator * (prod.unitSell?.realPrice.validator ?? 0);
      } else {
        vatInfo[prod.vat.validator] = vatInfo[prod.vat.validator]! +
            prod.quantity.validator * (prod.unitSell?.realPrice.validator ?? 0);
      }
    }
    // for (final item in vatInfo.entries) {
    //   print('vat ${item.key} - ${item.value}');
    // }
    final totalPoint = widget.bloc.products.fold<num>(
      0,
      (total, e) {
        total += (e.totalShipmentQuantitySelected) * (e.point ?? 0);
        return total;
      },
    );
    final num totalPointProductUsed =
        (widget.bloc.productsPointExchange ?? []).fold(
      0,
      (total, e) {
        return total += (e.quantity ?? 0) * (e.exchangePoint ?? 0);
      },
    );

    final num totalPointPackageUsed =
        (widget.bloc.productsFromPackage ?? []).fold(
      0,
      (total, e) {
        final listProductSelected =
            e.items?.where((e) => e.product?.isSelected == true) ?? [];
        if (listProductSelected.isNotEmpty) {
          total += e.point ?? 0;
        }
        return total;
      },
    );

    final num totalPointUsed = totalPointProductUsed +
        totalPointPackageUsed +
        (widget.bloc.moneyExchange?.point ?? 0);
    return Column(
      children: [
        TextRow2(
          title: 'Tổng tiền hàng',
          content: '${widget.bloc.price.formatCurrency} đ',
          contentStyle: AppStyle.bodyBsRegular.copyWith(
            color: AppColors.text_tertiary,
          ),
        ),
        8.height,
        TextRow2(
          title: 'Chiết khấu',
          content: '${widget.bloc.chietKhau.formatCurrency} đ',
          contentStyle: AppStyle.bodyBsRegular.copyWith(
            color: AppColors.text_tertiary,
          ),
        ),
        8.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tích điểm',
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_secondary,
              ),
            ),
            const Spacer(),
            Text(
              'Hiển thị sau khi đơn hàng được thanh toán',
              style: p9.copyWith(
                color: greyTextColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        8.height,
        Row(
          spacing: sp8,
          children: [
            Text(
              'Quy đổi điểm',
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_secondary,
              ),
            ),
            const Spacer(),
            Text(
              '${totalPointUsed.formatCurrency} điểm',
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_tertiary,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.text_tertiary,
            ),
          ],
        ),
        8.height,
        Row(
          spacing: sp8,
          children: [
            sp64.width,
            Text(
              'Quy đổi điểm theo giá trị đơn hàng',
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_secondary,
              ),
            ),
            const Spacer(),
            Text(
              '${widget.bloc.moneyExchange?.point.formatCurrency ?? 0} điểm',
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_tertiary,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '-${widget.bloc.moneyExchange?.moneyExchange.formatCurrency ?? 0}đ',
              style: s14w700.copyWith(
                color: AppColors.text_primary,
              ),
            ),
          ],
        ),
        8.height,
        Row(
          spacing: sp8,
          children: [
            sp64.width,
            Text(
              'Quy đổi điểm theo sản phẩm',
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_secondary,
              ),
            ),
            const Spacer(),
            Text(
              '${totalPointProductUsed.formatCurrency} điểm',
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_tertiary,
              ),
            ),
          ],
        ),
        8.height,
        Row(
          spacing: sp8,
          children: [
            sp64.width,
            Text(
              'Quy đổi điểm theo gói sản phẩm',
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_secondary,
              ),
            ),
            const Spacer(),
            Text(
              '${totalPointPackageUsed.formatCurrency} điểm',
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_tertiary,
              ),
            ),
          ],
        ),
        8.height,
        SwitchLabel(
          value: widget.bloc.red,
          onChanged: (val) {
            if ((balance ?? 0) > 450) {
              setState(() {
                _bloc.zns = val;
              });
            }
          },
          label: 'Gửi tin ZNS cho khách hàng',
          style: AppStyle.bodyBsMedium.copyWith(height: 1),
        ),
        8.height,
        SwitchLabel(
          value: widget.bloc.red,
          onChanged: (val) {
            setState(() {
              _bloc.red = val;
            });
            if ((balance ?? 0) > 400) {}
          },
          label: 'Hóa đơn đỏ',
          style: AppStyle.bodyBsMedium.copyWith(height: 1),
        ),
        4.height,
        Visibility(
          visible: _bloc.red,
          child: Column(
            children: [
              const Divider(
                thickness: 1,
                color: AppColors.border_tertiary,
              ),
              4.height,
              for (final item in vatInfo.entries)
                TextRow2(
                  title:
                      'VAT ${item.key.formatCurrency}% của (${item.value.formatCurrency} đ)',
                  content: '${(item.value * item.key / 100).formatCurrency} đ',
                  contentStyle: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                ).padding(8.padingBottom),
              // ListView.separated(
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemBuilder: (context, index) {
              //     final prod = products[index];
              //     if (prod.vat == 0) 0.height;
              //
              //     return TextRow2(
              //       title:
              //           'VAT ${prod.vat.formatCurrency}% của (${prod.unitSell?.realPrice.formatCurrency} đ)',
              //       content:
              //           '${(prod.quantity.validator * (prod.unitSell?.realPrice.validator ?? 0) * prod.vat.validator / 100).formatCurrency} đ',
              //       contentStyle: AppStyle.bodyBsRegular.copyWith(
              //         color: AppColors.text_tertiary,
              //       ),
              //     );
              //   },
              //   separatorBuilder: (context, index) =>
              //       products[index].vat == 0 ? 0.height : 8.height,
              //   itemCount: products.length,
              // ),

              4.height,
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = _bloc.services[index];
                  if (item.vat == 0) 0.height;
                  return TextRow2(
                    title:
                        'VAT ${item.vat.formatCurrency}% của (${item.totalPrice.formatCurrency} đ)',
                    content: '${item.vatPrice.formatCurrency} đ',
                    contentStyle: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.text_tertiary,
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    _bloc.services[index].vat == 0 ? 0.height : 8.height,
                itemCount: _bloc.services.length,
              ),
            ],
          ),
        ),
        4.height,
        const Divider(
          thickness: 1,
          color: AppColors.border_tertiary,
        ),
        4.height,
        TextRow2(
          title: 'Tổng thanh toán',
          content: '${widget.bloc.total.formatCurrency} đ',
          contentStyle: AppStyle.headingLg,
          titleStyle: AppStyle.bodyBsRegular,
        ),
      ],
    );
  }

  Widget get _note {
    return InputColumn(
      label: 'Ghi chú đơn hàng',
      onChanged: (val) {
        widget.bloc.note = val;
      },
      hintText: 'Nhập ghi chú',
      textInputType: TextInputType.multiline,
      minLines: 4,
      padding: 0.pading,
    );
  }

  Widget get _buildBottom {
    return Container(
      padding: 16.padingHor + 12.padingTop + 32.padingBottom,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.border_tertiary,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DoubleButton(
            cancelText: 'Quay lại',
            confirmText: 'Tạo đơn',
            onCancel: () {
              context.pop();
            },
            onConfirm: () async {
              DialogUtils.showLoadingDialog(context, 'Đang tạo đơn hàng...');
              final res = await widget.bloc.checkTonKho();
              if (!mounted) return;
              if (res.data?.isNotEmpty ?? false) {
                context.pop();
                context.pop(result: res.data ?? []);
                context.dialog(
                  DialogMessage(
                    title: 'Thông báo',
                    content: 'Sản phẩm ${res.data!.map((e) => e.name).join(
                          ', ',
                        )} không đủ tồn kho',
                    isError: true,
                  ),
                );
                return;
              }
              widget.bloc.create().then((value) async {
                if (!mounted) return;
                context.pop();
                if (value.code == 200) {
                  context.router.popUntil(
                    (route) =>
                        route.settings.name == OrderManagerV2Route.name ||
                        route.settings.name == HomeRoute.name,
                  );
                  getIt<OrderManagerBloc>().getList();
                  context.read<NavHomeBloc>().onChanged(TabCodeNav.order);
                  context.pushRoute(
                    OrderDetailProdV2Route(
                      id: value.data ?? -1,
                      isProd: _bloc.type.toLowerCase() == 'product',
                    ),
                  );
                  ToastCustom.show(
                    context,
                    title: 'Thành công',
                    msg: 'Tạo đơn hàng thành công',
                    svgIcon: Assets.iconsSuccess,
                    color: AppColors.ultility_brand_60,
                    timeClose: 2.seconds,
                  );
                } else {
                  context.dialog(
                    DialogMessage(
                      title: 'Thông báo',
                      content: value.message ?? 'Tạo đơn hàng không thành công',
                      isError: true,
                    ),
                  );
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _itemPackage(PointExchangePackageModel item) {
    return Column(
      children: [
        Row(
          spacing: sp4,
          children: [
            SvgPicture.asset('assets/svg/point.svg'),
            Text(
              '${item.point.formatCurrency} điểm',
              style: s14w700.copyWith(
                color: AppColors.text_primary,
              ),
            ),
            const Spacer(),
            Text(
              'Đổi từ',
              style: s12w400.copyWith(
                color: AppColors.text_secondary,
              ),
            ),
            Text(
              '${item.name}',
              style: s12w500.copyWith(
                color: AppColors.text_primary,
              ),
            ),
          ],
        ),
        sp12.height,
        ...(item.items ?? [])
            .where((e) => e.product?.isSelected == true)
            .map((e) {
          return Row(
            spacing: sp8,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(sp4),
                child: Image.network(
                  e.product?.images?.firstOrNull?.url ??
                      PrefKeys.imgProductDefault,
                  width: sp48,
                  height: sp48,
                  fit: BoxFit.cover,
                ),
              ),
              gapWidth(sp16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.product?.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: s14w500.copyWith(color: AppColors.text_primary),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '${FormatCurrency(e.unit?.sellPrice)} đ',
                          style: p5.copyWith(color: blackColor),
                        ),
                        Text(
                          '/${e.unit?.name}',
                          style: p5.copyWith(color: blackColor),
                        ),
                        const Spacer(),
                        Text(
                          '${FormatCurrency(e.quantity)} ${e.unit?.name}',
                          style: p3.copyWith(color: mainColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
        const Divider(height: sp12),
      ],
    );
  }

  Widget get _confirmOrderPrescription {
    return ConfirmOrderPrescription(bloc: widget.bloc);
  }
}
