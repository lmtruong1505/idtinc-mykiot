import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features_v2/blocs/dashboard/order_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../../constants/colors.dart';
import '../../../models/dashboard/order.dart';
import 'bg_widget_dashboard.dart';

class OrderDashboard extends StatelessWidget {
  final OrderDashboardBloc bloc;
  const OrderDashboard({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDashboardBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        final bool check =
            (bloc.order?.currentMonth ?? 0) > (bloc.order?.lastMonth ?? 0);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: sp16,
                  backgroundColor: AppColors.bg_secondary,
                  child: FaIcon(
                    iconCode: 'e473',
                    size: sp16,
                    color: AppColors.fg_tertiary,
                    type: FaIconType.solid,
                  ),
                ),
                sp8.width,
                Text(
                  'Tổng quan',
                  style: s18w700.copyWith(
                    color: AppColors.text_primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            sp12.height,
            SizedBox(
              width: widthDevice(context),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    BgWidgetDashboard(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: sp12,
                                        backgroundColor: AppColors.bg_secondary,
                                        child: FaIcon(
                                          iconCode: 'e529',
                                          size: sp12,
                                          color: AppColors.fg_tertiary,
                                        ),
                                      ),
                                      sp8.width,
                                      Text(
                                        'Lợi nhuận',
                                        style: s12w400.copyWith(
                                          color: AppColors.text_tertiary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  4.height,
                                  Container(
                                    padding: const EdgeInsets.all(sp12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(sp12),
                                      color: check
                                          ? AppColors.green10
                                          : AppColors.red10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Trước thuế',
                                          style: s10w400.copyWith(
                                            color: AppColors.grey90,
                                          ),
                                        ),
                                        Text(
                                          '${bloc.order?.revenueMonthConvert ?? 0}',
                                          style: s14w600.copyWith(
                                            color: AppColors.green60,
                                          ),
                                        ),
                                        4.height,
                                        Row(
                                          children: [
                                            Text(
                                              '${bloc.order?.percentRevenue ?? '0'}%',
                                              style: StyleApp.semibold(
                                                fontSize: 12,
                                                color: check
                                                    ? ColorApp.green
                                                    : ColorApp.red,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            4.width,
                                            Icon(
                                              check
                                                  ? Icons.trending_up_outlined
                                                  : Icons
                                                      .trending_down_outlined,
                                              size: 15,
                                              color: check
                                                  ? ColorApp.green
                                                  : ColorApp.red,
                                            ),
                                            4.width,
                                            Text(
                                              'tháng trước',
                                              style: StyleApp.normal(
                                                color: ColorApp.grey,
                                                fontSize: 12,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    8.width,
                    BgWidgetDashboard(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: sp12,
                                        backgroundColor: AppColors.bg_secondary,
                                        child: FaIcon(
                                          iconCode: 'f53a',
                                          size: sp12,
                                          color: AppColors.fg_tertiary,
                                        ),
                                      ),
                                      sp8.width,
                                      Text(
                                        'Doanh số',
                                        style: s12w400.copyWith(
                                          color: AppColors.text_tertiary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  4.height,
                                  Container(
                                    padding: const EdgeInsets.all(sp12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(sp12),
                                      color: check
                                          ? AppColors.green10
                                          : AppColors.red10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${bloc.order?.currentMonth} đơn hàng',
                                          style: s10w400.copyWith(
                                            color: green_4,
                                          ),
                                        ),
                                        Text(
                                          '${bloc.order?.salesMonthConvert ?? 0}',
                                          style: s14w600.copyWith(
                                            color: AppColors.green60,
                                          ),
                                        ),
                                        4.height,
                                        Row(
                                          children: [
                                            Text(
                                              '${bloc.order?.percentSales ?? '0'}%',
                                              style: StyleApp.semibold(
                                                fontSize: 12,
                                                color: check
                                                    ? ColorApp.green
                                                    : ColorApp.red,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            4.width,
                                            Icon(
                                              check
                                                  ? Icons.trending_up_outlined
                                                  : Icons
                                                      .trending_down_outlined,
                                              size: 15,
                                              color: check
                                                  ? ColorApp.green
                                                  : ColorApp.red,
                                            ),
                                            4.width,
                                            Text(
                                              'tháng trước',
                                              style: StyleApp.normal(
                                                color: ColorApp.grey,
                                                fontSize: 12,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    8.width,
                    BgWidgetDashboard(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: sp12,
                                        backgroundColor: AppColors.bg_secondary,
                                        child: FaIcon(
                                          iconCode: 'f53a',
                                          size: sp12,
                                          color: AppColors.fg_tertiary,
                                        ),
                                      ),
                                      sp8.width,
                                      Text(
                                        'Doanh thu',
                                        style: s12w400.copyWith(
                                          color: AppColors.text_tertiary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  4.height,
                                  Container(
                                    padding: const EdgeInsets.all(sp12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(sp12),
                                      color: (bloc.order?.revenueMonth ?? 0) > (bloc.order?.revenueLastMonth ?? 0)
                                          ? AppColors.green10
                                          : AppColors.red10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${bloc.order?.currentMonth} đơn hàng',
                                          style: s10w400.copyWith(
                                            color: green_4,
                                          ),
                                        ),
                                        Text(
                                          '${bloc.order?.revenueMonthConvert ?? 0}',
                                          style: s14w600.copyWith(
                                            color: AppColors.green60,
                                          ),
                                        ),
                                        4.height,
                                        Row(
                                          children: [
                                            Text(
                                              '${bloc.order?.percentRevenue ?? '0'}%',
                                              style: StyleApp.semibold(
                                                fontSize: 12,
                                                color: (bloc.order?.revenueMonth ?? 0) > (bloc.order?.revenueLastMonth ?? 0)
                                                    ? ColorApp.green
                                                    : ColorApp.red,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            4.width,
                                            Icon(
                                              (bloc.order?.revenueMonth ?? 0) > (bloc.order?.revenueLastMonth ?? 0)
                                                  ? Icons.trending_up_outlined
                                                  : Icons
                                                      .trending_down_outlined,
                                              size: 15,
                                              color: (bloc.order?.revenueMonth ?? 0) > (bloc.order?.revenueLastMonth ?? 0)
                                                  ? ColorApp.green
                                                  : ColorApp.red,
                                            ),
                                            4.width,
                                            Text(
                                              'tháng trước',
                                              style: StyleApp.normal(
                                                color: ColorApp.grey,
                                                fontSize: 12,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    8.width,
                    BgWidgetDashboard(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: sp12,
                                        backgroundColor: AppColors.bg_secondary,
                                        child: FaIcon(
                                          iconCode: 'e528',
                                          size: sp12,
                                          color: AppColors.fg_tertiary,
                                        ),
                                      ),
                                      sp8.width,
                                      Text(
                                        'Công nợ',
                                        style: s12w400.copyWith(
                                          color: AppColors.text_tertiary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  4.height,
                                  Container(
                                    padding: const EdgeInsets.all(sp12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(sp12),
                                      color: AppColors.red10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tiền công nợ',
                                          style: s10w400.copyWith(
                                            color: AppColors.grey90,
                                          ),
                                        ),
                                        Text(
                                          '${bloc.order?.totalDebt.formatCurrency ?? 0} đ',
                                          style: s14w600.copyWith(
                                            color: AppColors.redAlpha90,
                                          ),
                                        ),
                                        4.height,
                                        InkWell(
                                          onTap: () {
                                            context.router.push(
                                              CustomerV2Route(isDebt: true),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                'Chi tiết danh sách khách hàng',
                                                style: s10w400.copyWith(
                                                  color:
                                                      AppColors.text_hyperlink,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                              sp4.width,
                                              FaIcon(
                                                iconCode: 'f061',
                                                color: AppColors.text_hyperlink,
                                                size: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
