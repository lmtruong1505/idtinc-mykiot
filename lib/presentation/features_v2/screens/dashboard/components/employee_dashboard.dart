import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/screens/dashboard/components/bg_widget_dashboard.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../../../../shared/components/input/overlay_input.dart';
import '../../../../di/di.dart';
import '../../../blocs/dashboard/dashboard_staff_bloc.dart';
import '../../../blocs/order_v2/product_selection_bloc.dart';
import '../../../models/dashboard/employee.dart';
import '../../../models/product/product_v2_model.dart';
import '../../product/components/product_list_item.dart';

class EmployeeDashboard extends StatefulWidget {
  final DashboardStaffBloc bloc;
  const EmployeeDashboard({required this.bloc});

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  final _productSelectionBloc = getIt.get<ProductSelectionBloc>();
  final _focusNode = FocusNode();
  final _textCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardStaffBloc, CubitState>(
      bloc: widget.bloc,
      builder: (context, state) {
        final employees = widget.bloc.employeeData;
        return BgWidgetDashboard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                spacing: sp12,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.bg_secondary,
                    child: FaIcon(
                      iconCode: 'f466',
                      color: AppColors.fg_tertiary,
                    ),
                  ),
                  Text(
                    'Top nhân viên bán hàng',
                    style: StyleApp.normal(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              sp16.height,
              ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: SortEmployeeDashboard.values.length,
                separatorBuilder: (context, index) => 8.width,
                itemBuilder: (context, index) => MainButtonV2(
                  title: SortEmployeeDashboard.values[index].name,
                  padding: sp8.padingHor,
                  radius: 30,
                  backgroundColor: SortEmployeeDashboard.values[index] ==
                          widget.bloc.employeeSort
                      ? ColorApp.main
                      : ColorApp.greyF2,
                  textStyle: StyleApp.normal(
                    color: SortEmployeeDashboard.values[index] ==
                            widget.bloc.employeeSort
                        ? ColorApp.white
                        : ColorApp.black,
                  ),
                  onTap: () {
                    widget.bloc.employeeSort =
                        SortEmployeeDashboard.values[index];
                  },
                ),
              ).size(height: 30),
              sp16.height,
              if (widget.bloc.employeeSort ==
                  SortEmployeeDashboard.totalSalesByProduct)
                _buildSearch,
              if (widget.bloc.employeeSort !=
                      SortEmployeeDashboard.totalSalesByProduct ||
                  widget.bloc.product.id != null)
                LoadPage(
                  state: widget.bloc.state,
                  listEmpty: employees.isEmpty,
                  child: Column(
                    children: List.generate(
                      employees.length,
                      (index) => _employee(employees[index], index),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
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

  Widget _employee(DashboardEmployeeModel employee, int index) {
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
        sp12.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              employee.fullName ?? '',
              style: StyleApp.semibold(
                color: ColorApp.grey47,
              ),
            ),
            sp4.height,
            if (widget.bloc.employeeSort ==
                SortEmployeeDashboard.totalOrder) ...[
              RichText(
                text: TextSpan(
                  text: employee.totalSales.formatPrice(type: 'đ'),
                  style: StyleApp.semibold(color: ColorApp.main),
                  children: [
                    TextSpan(
                      text: ' - ${employee.totalOrder ?? 0} đơn hàng',
                      style: StyleApp.normal(color: ColorApp.grey),
                    ),
                  ],
                ),
              ),
            ] else if (widget.bloc.employeeSort ==
                SortEmployeeDashboard.totalSalesByProduct) ...[
              RichText(
                text: TextSpan(
                  text: 'Đã bán ',
                  style: StyleApp.normal(color: ColorApp.grey),
                  children: [
                    TextSpan(
                      text: '${employee.saleQuantity} ${widget.bloc.product.unit.last.name}',
                      style: StyleApp.semibold(color: ColorApp.main),
                    ),
                    TextSpan(
                      text: ' - ${employee.totalSales.formatCurrency} đ',
                      style: StyleApp.normal(color: ColorApp.grey),
                    ),
                  ],
                ),
              ),
            ] else ...[
              RichText(
                text: TextSpan(
                  text: 'Doanh số: ',
                  style: StyleApp.normal(color: AppColors.text_secondary),
                  children: [
                    TextSpan(
                      text: employee.totalSales.formatPrice(type: 'đ'),
                      style: StyleApp.bold(
                          color: AppColors.text_brand_primary_variant1),
                    ),
                    TextSpan(
                      text: '/${employee.totalOrder ?? 0} đơn hàng',
                      style: StyleApp.medium(color: AppColors.text_secondary),
                    ),
                  ],
                ),
              ),
              sp4.height,
              RichText(
                text: TextSpan(
                  text: 'Công nợ chưa thu: ',
                  style: StyleApp.normal(color: AppColors.text_secondary),
                  children: [
                    TextSpan(
                      text: ((employee.totalSales ?? 0) -
                              (employee.totalRevenue ?? 0))
                          .formatPrice(type: 'đ'),
                      style: StyleApp.medium(color: AppColors.text_secondary),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ).expanded(),
      ],
    ).padding(8.padingVer);
  }

  OverlayInput<ProductV2Model> get _buildSearch {
    return OverlayInput<ProductV2Model>(
      controller: _textCtl,
      itemBuilder: (BuildContext context, item, int index) {
        return ProductListItem(
          model: item,
          showHead: false,
        );
      },
      onChanged: (item) async {
        widget.bloc.product = item;
        setState(() {
          _textCtl.text = item.name ?? '';
        });
      },
      hintText: 'Tìm tên, mã sản phẩm',
      itemHeight: 100,
      lazyLoad: (isMore) {
        return _productSelectionBloc.getList(_textCtl.text, isMore: isMore);
      },
      borderRadius: 999,
      header: Text(
        'Chọn sản phẩm',
        style: AppStyle.headingMd.copyWith(
          color: AppColors.text_quaternary,
        ),
      ).padding(16.pading.copyWith(top: 12, bottom: 6)),
      elevation: 1,
      prefix: const Icon(
        Icons.search,
        color: AppColors.input_iconDefault,
      ),
      focusNode: _focusNode,
    );
  }
}
