import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/models/local_model.dart';
import 'package:pharmago/presentation/features_v2/screens/dashboard/components/bg_widget_dashboard.dart';
import 'package:pharmago/presentation/features_v2/screens/dashboard/components/pie_chart.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../../blocs/dashboard/customer_top_bloc.dart';
import '../../../models/dashboard/customer_top.dart';

class CustomerDashboard extends StatelessWidget {
  final CustomerTopBloc bloc;
  CustomerDashboard({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerTopBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _listCustomer(),
            // sp16.height,
            // _rateCustomer(),
            // sp16.height,
            // _chartCustomer(),
            //sp16.height,
          ],
        );
      },
    );
  }

  Widget _listCustomer() {
    final customers = bloc.customerTop?.customers ?? [];
    return BgWidgetDashboard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Khách hàng đang có',
            style: StyleApp.normal(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
          4.height,
          Text(
            bloc.customerTop?.customerCount.formatPrice() ?? '0',
            style: StyleApp.bold(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
          4.height,
          RichText(
            text: TextSpan(
              text: 'Doanh số trung bình (',
              style: StyleApp.medium(color: ColorApp.grey),
              children: [
                TextSpan(
                  text:
                      '${bloc.customerTop?.pricePerCustomer.formatPrice() ?? 0}',
                  style: StyleApp.medium(color: ColorApp.red),
                ),
                TextSpan(
                  text: '/khách hàng)',
                  style: StyleApp.medium(color: ColorApp.grey),
                ),
              ],
            ),
          ),
          4.height,
          RichText(
            text: TextSpan(
              text: 'Đơn trung bình (',
              style: StyleApp.medium(color: ColorApp.grey),
              children: [
                TextSpan(
                  text:
                      '${bloc.customerTop?.orderPerCustomer.formatPrice() ?? 0} đơn',
                  style: StyleApp.medium(color: ColorApp.green),
                ),
                TextSpan(
                  text: '/khách hàng)',
                  style: StyleApp.medium(color: ColorApp.grey),
                ),
              ],
            ),
          ),
          sp16.height,
          ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: SortCustomerDashboard.values.length,
            separatorBuilder: (context, index) => 8.width,
            itemBuilder: (context, index) => MainButtonV2(
              title: SortCustomerDashboard.values[index].name,
              padding: sp8.padingHor,
              radius: 30,
              backgroundColor: SortCustomerDashboard.values[index] == bloc.sort
                  ? ColorApp.main
                  : ColorApp.greyF2,
              textStyle: StyleApp.normal(
                color: SortCustomerDashboard.values[index] == bloc.sort
                    ? ColorApp.white
                    : ColorApp.black,
              ),
              onTap: () {
                bloc.sort = SortCustomerDashboard.values[index];
              },
            ),
          ).size(height: 30),
          sp16.height,
          LoadPage(
            state: bloc.state,
            listEmpty: customers.isEmpty,
            child: Column(
              children: List.generate(
                customers.length,
                (index) => _customer(customers[index], index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final List<LinearGradient> colors = [
    const LinearGradient(
      colors: [
        Color(0xFFFFD574),
        Color(0xFFFCBA56),
      ],
    ),
    const LinearGradient(
      colors: [
        Color(0xFFEAECF0),
        Color(0xFFDDDFE2),
      ],
    ),
    const LinearGradient(
      colors: [
        Color(0xFFF3D8BE),
        Color(0xFFC9B39D),
      ],
    ),
  ];

  Widget _customer(CustomersDashboard customer, int index) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            gradient: index < 3 ? colors[index] : null,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            (index + 1).toString(),
            style: StyleApp.bold(),
          ),
        ),
        sp8.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              customer.fullName ?? '',
              style: StyleApp.semibold(
                color: ColorApp.grey47,
              ),
            ),
            sp4.height,
            RichText(
              text: TextSpan(
                text: customer.totalPrice.formatPrice(type: 'đ'),
                style: StyleApp.semibold(color: ColorApp.main),
                children: [
                  TextSpan(
                    text: ' - ${customer.totalOrder ?? 0} đơn hàng',
                    style: StyleApp.normal(color: ColorApp.grey),
                  ),
                ],
              ),
            ),
          ],
        ).expanded(),
      ],
    ).padding(8.padingVer);
  }

  Widget _chartCustomer() {
    return BgWidgetDashboard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Nguồn khách hàng',
            style: StyleApp.semibold(fontSize: 16),
          ),
          sp4.height,
          Row(
            children: [
              Text(
                '${0}%',
                style: StyleApp.bold(
                  color: 0 > 0 ? ColorApp.green : ColorApp.red,
                ),
              ),
              sp4.width,
              Text(
                'tháng này',
                style: StyleApp.normal(color: ColorApp.grey),
              ),
            ],
          ),
          sp16.height,
          PieChartDashboard(
            size: 130,
            radius: 5,
            showLabel: true,
            centerText: '${0}',
            subText: 'khách hàng',
            dataChart: [
              LocalModel(
                color: ColorApp.blue20,
                value: 10,
                title: 'Facebook',
              ),
              LocalModel(
                color: ColorApp.yellowD2,
                value: 15,
                title: 'Zalo OA',
              ),
              LocalModel(
                color: ColorApp.green,
                value: 20,
                title: 'Google',
              ),
              LocalModel(
                color: ColorApp.yellowF7,
                value: 25,
                title: 'Khác',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rateCustomer() {
    return BgWidgetDashboard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          textRow(
            title: 'Tỷ lệ khách quay lại mua hàng',
            content: '15%',
            titleStyle: StyleApp.normal(fontSize: 12),
            contentStyle: StyleApp.bold(fontSize: 16, color: ColorApp.red),
          ),
          sp8.height,
          textRow(
            title: 'Tỷ lệ tăng trưởng khách hàng mới',
            content: '10%',
            titleStyle: StyleApp.normal(fontSize: 12),
            contentStyle: StyleApp.bold(fontSize: 16, color: ColorApp.green),
          ),
          sp16.height,
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildlabel(
                    title: 'Quay lại mua hàng',
                    color: ColorApp.green,
                  ),
                  sp8.height,
                  _buildlabel(
                    title: 'Tổng số khách hàng',
                    color: ColorApp.greyEA,
                  ),
                ],
              ).expanded(),
              SizedBox(
                width: 80,
                child: PieChartDashboard(
                  centerText: '68%',
                  size: 80,
                  radius: 10,
                  dataChart: [
                    LocalModel(
                      color: ColorApp.green,
                      value: 68,
                      title: 'Khách hàng',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row _buildlabel({required String title, required Color color}) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: color,
          size: sp16,
        ),
        sp4.width,
        Text(
          title,
          style: StyleApp.semibold(fontSize: 14),
        ),
      ],
    );
  }
}
