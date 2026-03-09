import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/v2/expanded_section.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/screens/order/components/selection/customer_selection.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/button/double_button.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../di/di.dart';
import '../../../features/wallet/bloc/bloc/wallet_bloc.dart';
import '../../../features/wallet/bloc/bloc/wallet_state.dart';
import '../../blocs/event/list_staff_bloc.dart';
import '../../blocs/local/bool_bloc.dart';
import '../../blocs/order_v2/customer_selection_bloc.dart';
import '../../blocs/order_v2/order_create_bloc.dart';
import '../../blocs/order_v2/product_selection_bloc.dart';
import '../../models/customer/v2/customer_point_item_model.dart';
import '../../models/event/detail_event_model.dart';
import '../../models/product/product_v2_model.dart';
import '../../blocs/order_v2/service_selection_bloc.dart';
import 'components/dialog_preview_point_exchange.dart';
import 'components/selection/product_selection.dart';
import 'components/selection/service_selection.dart';

@RoutePage()
class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({
    super.key,
    required this.type,
    this.customer,
    this.services,
    this.products,
    this.appointment,
  });

  final String type;
  final int? customer;
  final List<ServicesEvent>? services;
  final List<ProductV2Model>? products;
  final int? appointment;

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final cusBloc = CustomerSelectionBloc();
  final prodBloc = ProductSelectionBloc();
  final serviceBloc = ServiceSelectionBloc();
  final orderBloc = OrderCreateBloc();
  final empBloc = ListStaffServiceBloc();
  final boolBloc = BoolBloc();
  final walletBloc = getIt<WalletBloc>();

  @override
  void initState() {
    boolBloc.change(false);
    orderBloc.type = widget.type;
    orderBloc.appointment = widget.appointment;
    // empBloc.getList();
    cusBloc.findCus(widget.customer);
    serviceBloc.findServices(widget.services);
    if (widget.products != null) {
      for (final item in widget.products!) {
        prodBloc.addProduct(item);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBarTitleCenter(title: 'Tạo mới đơn hàng'),
        body: Container(
          padding: 16.pading,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomerSelection(
                  bloc: cusBloc,
                  type: null,
                ),
                _service,
                24.height,
                ProductSelection(bloc: prodBloc),
                500.height,
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottom,
      ),
    );
  }

  Widget get _buildBottom {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<CustomerSelectionBloc, CubitState>(
          bloc: cusBloc,
          builder: (context, state) {
            if (cusBloc.productExchangePoint?.isEmpty ?? true) {
              return const SizedBox.shrink();
            }
            return InkWell(
              onTap: () => DialogPreviewPointExchange.show(
                context,
                point: cusBloc.model?.points ?? 0,
                productsSelected: cusBloc.productExchangePoint ?? [],
                productsFromPackage: cusBloc.productsFromPackage ?? [],
                moneyExchange: cusBloc.moneyExchange ?? CustomerPointItemModel(
                  point: 0,
                  moneyExchange: 0,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(sp16),
                padding: const EdgeInsets.all(sp16),
                decoration: BoxDecoration(
                  color: AppColors.bg_white,
                  borderRadius: BorderRadius.circular(sp12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.bg_black.withOpacity(0.2),
                      blurRadius: sp4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/svg/point.svg'),
                    sp12.width,
                    Text(
                      'Quà tặng từ đổi điểm (${cusBloc.productExchangePoint?.length ?? 0})',
                      style: s14w400.copyWith(color: AppColors.text_tertiary),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.keyboard_arrow_up,
                      size: sp20,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Container(
          padding: 16.padingHor + 12.padingTop + 32.padingBottom,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.border_tertiary,
                width: 1,
              ),
            ),
          ),
          child: BlocBuilder<WalletBloc, WalletState>(
            bloc: walletBloc,
            builder: (context, state) {
              // if ((walletBloc.wallet?.balance ?? 0) == 0) {
              //   return Text(
              //     'Ví không khả dụng/Tài khoản không đủ',
              //     style: p5.copyWith(color: red_1),
              //   );
              // }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocBuilder<BoolBloc, bool>(
                    bloc: boolBloc,
                    builder: (context, state) {
                      return BlocBuilder<ProductSelectionBloc, CubitState>(
                        bloc: prodBloc,
                        builder: (context, state2) {
                          return BlocBuilder<ServiceSelectionBloc, CubitState>(
                            bloc: serviceBloc,
                            builder: (context, state3) {
                              return ExpandedSection(
                                isSelected: state,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextRow2(
                                      title: 'Tổng tiền hàng',
                                      content:
                                          '${(prodBloc.price + serviceBloc.price).formatCurrency} đ',
                                      contentStyle:
                                          AppStyle.bodyBsRegular.copyWith(
                                        color: AppColors.text_tertiary,
                                      ),
                                    ),
                                    TextRow2(
                                      title: 'Chiết khấu',
                                      content:
                                          '-${(prodBloc.chietKhau + serviceBloc.chietKhau).formatCurrency} đ',
                                      contentStyle:
                                          AppStyle.bodyBsRegular.copyWith(
                                        color: AppColors.text_tertiary,
                                      ),
                                    ),
                                    TextRow2(
                                      title: 'Giảm từ điểm',
                                      content:
                                          '-${cusBloc.moneyExchange?.moneyExchange.formatCurrency} đ',
                                      contentStyle:
                                          AppStyle.bodyBsRegular.copyWith(
                                        color: AppColors.text_tertiary,
                                      ),
                                    ),
                                    const Divider(
                                      color: AppColors.border_tertiary,
                                      thickness: 1,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  Row(
                    children: [
                      Text(
                        'Tổng thanh toán',
                        style: AppStyle.bodyBsRegular.copyWith(
                          color: AppColors.text_primary,
                        ),
                      ).expanded(),
                      BlocBuilder<ProductSelectionBloc, CubitState>(
                        bloc: prodBloc,
                        builder: (context, state) {
                          return BlocBuilder<ServiceSelectionBloc, CubitState>(
                            bloc: serviceBloc,
                            builder: (context, state) {
                              return Text(
                                '${(prodBloc.total + serviceBloc.total - (cusBloc.moneyExchange?.moneyExchange ?? 0)).formatCurrency} đ',
                                style: AppStyle.headingMd,
                              );
                            },
                          );
                        },
                      ),
                      4.width,
                      BlocBuilder<BoolBloc, bool>(
                        bloc: boolBloc,
                        builder: (context, state) {
                          return InkWell(
                            child: FaIcon(iconCode: state ? 'f078' : 'f077'),
                            onTap: () {
                              boolBloc.change(!boolBloc.state);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  4.height,
                  BlocBuilder<ServiceSelectionBloc, CubitState>(
                    bloc: serviceBloc,
                    builder: (context, state) {
                      return BlocBuilder<ProductSelectionBloc, CubitState>(
                        bloc: prodBloc,
                        builder: (context, state) {
                          return DoubleButton(
                            cancelText: 'Hủy bỏ',
                            confirmText: 'Xác nhận đơn',
                            onCancel: () {
                              context.router.maybePop();
                            },
                            onConfirm: (prodBloc.valid || serviceBloc.valid || (cusBloc.productExchangePoint?.isNotEmpty ??  false))
                                ? _handle
                                : null,
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _handle() {
    _validateBeforeNext(() {
      orderBloc.customer = cusBloc.model;
      orderBloc.productsPointExchange = cusBloc.productExchangePoint;
      orderBloc.productsFromPackage = cusBloc.productsFromPackage;
      orderBloc.moneyExchange = cusBloc.moneyExchange;
      orderBloc.products = prodBloc.list;
      orderBloc.price = prodBloc.price + serviceBloc.price;
      orderBloc.services = serviceBloc.list;
      orderBloc.chietKhau = prodBloc.chietKhau + serviceBloc.chietKhau;
      context.router.push(ConfirmOrderRoute(bloc: orderBloc)).then((value) {
        if (value is List<ProductV2Model>) {
          prodBloc.updateList(value);
        }
      });
    });
  }

  Widget get _service {
    if (widget.type != 'service') {
      return 0.height;
    }
    return Column(
      children: [
        24.height,
        FutureBuilder(
          future: empBloc.getList(),
          builder: (context, snapshot) {
            return ServiceSelection(
              bloc: serviceBloc,
              empBloc: empBloc,
              prodBloc: prodBloc,
            );
          },
        ),
      ],
    );
  }

  void _validateBeforeNext(Function onNext) {
    final valService = serviceBloc.validateBeforeNext;
    if (valService != null) {
      DialogUtils.showWarningDialog(context, content: valService);
      return;
    }

    onNext();
  }
}
