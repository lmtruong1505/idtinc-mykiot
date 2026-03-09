import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmago/gen/flutter_assets.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';
import 'package:pharmago/presentation/features/company/screen_v2/create_workspace_screen.dart';
import 'package:pharmago/presentation/features_v2/blocs/profile_bloc/profile_edit_bloc.dart';
import 'package:pharmago/shared/components/bg/bg_detail.dart';
import 'package:pharmago/shared/components/widgets/divider_custom.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/button/icon_btn.dart';
import '../../../../../../shared/components/widgets/bts_phone_action.dart';
import '../../../../../../shared/components/widgets/empty_view.dart';
import '../../../../../../shared/components/widgets/label_container.dart';
import '../../../../../../shared/components/widgets/search_filter.dart';
import '../../../../../base/loading.dart';
import '../../../../../base/v2/text_row.dart';
import '../../../../../di/di.dart';
import '../../../../../router/router.gr.dart';
import '../../../../blocs/enum/bloc_status.dart';
import '../../../../blocs/order_v2/order_manager_bloc.dart';
import '../../../../blocs/product/product_manager_bloc.dart';
import '../../../../blocs/state/cubit_state.dart';
import '../../../../models/customer/v2/customer_model.dart';
import '../../../order/components/item_order.dart';
import '../../../product/components/product_list_item.dart';

class TabInforCustomerV2 extends StatefulWidget {
  final CustomerV2Model customer;
  const TabInforCustomerV2({super.key, required this.customer});

  @override
  State<TabInforCustomerV2> createState() => _TabInforCustomerV2State();
}

class _TabInforCustomerV2State extends State<TabInforCustomerV2> {
  final myBloc = getIt<OrderManagerBloc>();
  final bloc = ProductManagerBloc();
  String _tab = 'ORDER';
  final scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    myBloc.changeFilter(customer: widget.customer.id);

    bloc.changeFilter(customer: widget.customer.id);
    scroll.onMore(
      () => bloc.getList(isMore: true),
    );
  }

  @override
  void dispose() {
    scroll.dispose();
    bloc.close();
    myBloc.clearFilter();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BgDetail(
      child: SingleChildScrollView(
        controller: scroll,
        padding: 16.pading,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInfo(context),
                if (widget.customer.isActive == true) ...[
                  12.height,
                  _builldZaloOa(),
                ],
                24.height,
                DividerCustom(),
                24.height,
                LabelContainer(
                  title: 'Thông tin cơ bản',
                ),
                12.height,
                TextRow2(
                  title: 'Ngày sinh',
                  content: widget.customer.birthday,
                ),
                12.height,
                TextRow2(
                  title: 'Giới tính',
                  content: gender?.getName,
                ),
                BuildAddress(
                  addressEntity: widget.customer.address ??
                      const AddressEntity(
                        title: 'Chưa có thông tin',
                      ),
                ),
              ],
            ).container(
              boxShadow: AppShadows.elevator0,
              radius: 16,
              padding: 12.pading,
            ),
            16.height,
            _extraView,
          ],
        ),
      ),
    );
  }

  Gender? get gender {
    if (widget.customer.gender == Gender.female.code) {
      return Gender.female;
    }
    if (widget.customer.gender == Gender.male.code) {
      return Gender.male;
    }
    return null;
  }

  Widget _builldZaloOa() {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          padding: 4.pading,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.ultility_blue.withOpacity(0.05),
            ),
          ),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.ultility_blue.withOpacity(0.1),
                width: 2,
              ),
            ),
            child: SvgPicture.asset(
              Assets.svgZaloOa,
            ),
          ),
        ),
        2.width,
        Text(
          'Đã quan tâm Zalo OA',
          style: AppStyle.bodyMdSemiBold.copyWith(
            color: AppColors.ultility_blue,
            fontSize: 12,
          ),
        ).expanded(),
        12.width,
        FaIcon(
          iconCode: 'f058',
          color: AppColors.fg_positive,
          type: FaIconType.solid,
        ),
      ],
    ).container(
      bgColor: AppColors.bg_secondary,
      padding: 8.pading,
      radius: 8,
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '#${widget.customer.code ?? ''}',
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_quaternary,
              ),
            ),
            Text(
              widget.customer.fullName ?? '',
              style: AppStyle.headingMd.copyWith(height: 1.5),
            ),
            InkWell(
              onTap: () {
                Clipboard.setData(
                  ClipboardData(text: widget.customer.phone ?? ''),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã copy: ${widget.customer.phone ?? ''}'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Row(
                spacing: sp8,
                children: [
                  Text(
                    widget.customer.phone ?? '',
                    style: AppStyle.bodyBsMedium.copyWith(
                      color: AppColors.blue60,
                    ),
                  ),
                  const Icon(
                    Icons.copy_rounded,
                    color: AppColors.blue60,
                    size: sp16,
                  ),
                ],
              ),
            ),
          ],
        ).expanded(),
        if (!widget.customer.phone.isEmptyOrNull) ...[
          12.width,
          IconBtn(
            onTap: () {
              BtsPhoneAction.show(
                context,
                phoneNumber: widget.customer.phone ?? '',
                fullname: widget.customer.fullName ?? '',
              );
            },
            size: const Size(32, 32),
            icon: const Icon(
              CupertinoIcons.phone,
              size: 16,
              color: AppColors.button_neutral_alpha_iconDefault,
            ),
          ),
        ],
      ],
    );
  }

  Widget get _extraView {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor_2),
      ),
      child: Column(
        children: [
          CupertinoSlidingSegmentedControl(
            children: {
              'ORDER': const Text('Lịch sử ĐH').padding(
                const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              ),
              'PRODUCT': const Text('SP đã mua').padding(
                const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              ),
            },
            groupValue: _tab,
            onValueChanged: (value) {
              setState(() {
                _tab = value ?? _tab;
              });
            },
          ),
          _tab == 'ORDER' ? _orderView : _productView,
        ],
      ),
    );
  }

  Widget get _orderView {
    return BlocBuilder<OrderManagerBloc, CubitState>(
      bloc: myBloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: widthDevice(context),
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: bg_4,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tổng chi tiêu trong tháng / Tổng đơn hàng',
                    style: p7.copyWith(color: greyTextColor),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${myBloc.revenueInMonth.formatCurrency} đ',
                          style: h4.copyWith(color: mainColor),
                        ),
                        TextSpan(
                          text: '/${myBloc.revenue.formatCurrency} đ',
                          style: p6.copyWith(color: greyTextColor),
                        ),
                      ],
                    ),
                  ),
                  sp4.height,
                  Text(
                    'Công nợ khách hàng',
                    style: p7.copyWith(color: greyTextColor),
                  ),
                  Text(
                    '${widget.customer.debt.formatCurrency} đ',
                    style: s18w700.copyWith(
                      color: (widget.customer.debt ?? 0) > 0
                          ? AppColors.red60
                          : AppColors.green60,
                    ),
                  ),
                ],
              ),
            ),
            16.height,
            SearchFilterCustom(
              hintText: 'Tìm mã đơn hàng',
              onConfirm: (value) => {
                myBloc.changeSearch(value),
              },
            ),
            16.height,
            Text(
              'Tất cả đơn hàng (${myBloc.revenue.formatCurrency} đ)',
              style: p5.copyWith(color: greyTextColor),
            ),
            const Divider(
              height: sp32,
            ),
            _buildTable(),
          ],
        );
      },
    );
  }

  Container _buildTable() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: 12.radius,
        border: Border.all(color: AppColors.border_tertiary),
      ),
      child: ClipRRect(
        borderRadius: 12.radius,
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader().container(
              bgColor: AppColors.bg_secondary_subtle,
              radius: 0,
              padding: 12.padingHor + 6.padingVer,
            ),
            const Divider(
              color: AppColors.border_tertiary,
              height: 0,
              thickness: 1,
            ),
            const Divider(
              color: AppColors.border_tertiary,
              height: 0,
              thickness: 1,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: myBloc.list.length,
              padding: 0.pading,
              itemBuilder: (context, index) {
                return ItemOrderPageV2(
                  order: myBloc.list[index],
                  isBg: index % 2 == 0,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          'Đơn hàng',
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_tertiary,
          ),
        ).expanded(),
        Text(
          'Đã thu',
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_tertiary,
          ),
          textAlign: TextAlign.end,
        ).expanded(),
      ],
    );
  }

  Widget get _productView {
    return BlocBuilder<ProductManagerBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.height,
            SearchFilterCustom(
              hintText: 'Tìm tên sản phẩm',
              onConfirm: (value) => {
                bloc.search = value,
              },
            ),
            16.height,
            Text(
              'Tất cả sản phẩm',
              style: p5.copyWith(color: greyTextColor),
            ),
            const Divider(height: sp24),
            _buildList(),
          ],
        );
      },
    );
  }

  Widget _buildList() {
    if (bloc.state.status == BlocStatus.loading && bloc.page == 1) {
      return const BaseLoading();
    }
    if (bloc.list.isEmpty) {
      return EmptyComfirm(
        labelBtn: 'Thêm sản phẩm',
        text: 'Chưa có sản phẩm',
        // onPressed: () {
        //   // bloc.search =
        // },
        svgAsset: 'assets/icons/ic_cube.svg',
        suffixIcon: const Icon(
          Icons.add,
          color: AppColors.button_brand_solid_iconDefault,
          size: 20,
        ),
      );
    }
    return Column(
      children: [
        ListView.separated(
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              context.router
                  .push(
                ProductDetailV2Route(
                  id: bloc.list[index].id ?? -1,
                  onRefresh: () {
                    bloc.getList();
                  },
                ),
              )
                  .then((value) {
                if (value == true) {
                  bloc.getList();
                }
              });
            },
            child: ProductListItem(
              model: bloc.list[index],
            ),
          ),
          separatorBuilder: (context, index) => DividerCustom(),
          itemCount: bloc.list.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        ),
        SizedBox(
          height: 50,
          child: bloc.state.status == BlocStatus.loading
              ? const BaseLoading(
                  height: 50,
                )
              : null,
        ),
      ],
    );
  }
}
