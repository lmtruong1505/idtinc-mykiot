import 'package:auto_route/auto_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/company/screen_v2/components/menu_action_dialog.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/icon_btn.dart';
import 'package:pharmago/shared/components/widgets/chip_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../features_v2/blocs/role_v2/role_per_ws_bloc.dart';
import '../../../../../shared/utils/get.dart';
import '../../../cubit/action_company_bloc.dart';
import '../../../cubit/company_choose_bloc.dart';
import '../../../cubit/work_space/work_space_cubit.dart';
import '../../../domain/entities/company_entity.dart';
import '../menu_popup.dart';

class ItemWorkspace extends StatefulWidget {
  final CompanyEntity company;
  const ItemWorkspace({
    super.key,
    required this.company,
  });

  @override
  State<ItemWorkspace> createState() => _ItemWorkspaceState();
}

class _ItemWorkspaceState extends State<ItemWorkspace> {
  _menu(StatusMenuWorkspace value) {
    if (value == StatusMenuWorkspace.detail) {
      context.pushRoute(DetailWpV2Route(id: widget.company.id ?? -1));
    } else if (value == StatusMenuWorkspace.edit) {
      context.pushRoute(
        CreateWorkspaceRoute(
          company: widget.company,
        ),
      );
    } else {
      menuActionDialog(
        context,
        value: value,
        title: widget.company.name ?? '',
        confirm: () {
          context.pop();
          if (value == StatusMenuWorkspace.remove) {
            actionBloc.remove(widget.company.id ?? -1);
            return;
          }
          if (value == StatusMenuWorkspace.active) {
            actionBloc.setActive(widget.company.id ?? -1, true);
            return;
          }
          if (value == StatusMenuWorkspace.unActive) {
            actionBloc.setActive(widget.company.id ?? -1, false);
            return;
          }
        },
      );
    }
  }

  final actionBloc = ActionCompanyBloc();
  @override
  Widget build(BuildContext context) {
    return BlocListener<ActionCompanyBloc, CubitState>(
      bloc: actionBloc,
      listener: (context, state) {
        CheckStateBloc.check(
          context,
          state,
          isShowMsg: true,
          success: () {
            getIt<WorkSpaceCubit>().getListCompanies();
          },
        );
      },
      child: InkWell(
        onTap: () async {
          if (widget.company.status) {
            getIt<CompanyChooseBloc>().company = widget.company;
            getIt<RolePermissionWsBloc>().getRolePer(widget.company.id ?? -1);
          } else {
            // TODO: Register Topic FCM
            await FirebaseMessaging.instance.subscribeToTopic(
              'COMPANY_$getCompanyCode',
            );
            context.pushRoute(DetailWpV2Route(id: widget.company.id ?? -1));
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ChipBadgeCustom(
                      title: widget.company.status
                          ? 'Đang hoạt động'
                          : 'Vô hiệu hoá',
                      color: !widget.company.status
                          ? AppColors.ultility_negative_60
                          : AppColors.ultility_positive_60,
                    ),
                    4.height,
                    Text(
                      widget.company.name ?? 'Chưa có thông tin',
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.headingXl.copyWith(
                        color: AppColors.text_secondary,
                      ),
                    ),
                  ],
                ).expanded(),
                MenuPopupWorkSpace(
                  onTap: _menu,
                  isActive: widget.company.status,
                  isDetail: false,
                  isEdit: widget.company.status,
                  child: RotatedBox(
                    quarterTurns: 45,
                    child: IconBtn(
                      size: const Size(32, 32),
                      padding: 0.pading,
                      icon: const Icon(
                        Icons.pending_outlined,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            4.height,
            Text(
              '${widget.company.typeName ?? ""} ∙ ${widget.company.totalCompany ?? 0} cơ sở',
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_tertiary,
              ),
            ),

            14.height,
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildItem(
                  title: 'Doanh số',
                  content: widget.company.totalSales.formatPrice(type: ' đ'),
                  percent: getPercentWorkSpace(
                    widget.company.totalSales.validator,
                    widget.company.totalSalesBefore.validator,
                  ),
                  isUp: widget.company.totalSales.validator >=
                      widget.company.totalSalesBefore.validator,
                ),
                buildItem(
                  title: 'Số lượng đơn hàng',
                  content: widget.company.totalOrder.formatPrice(),
                  subTitle: ' đơn',
                  percent: getPercentWorkSpace(
                    widget.company.totalOrder.validator,
                    widget.company.totalOrderBefore.validator,
                  ),
                  isUp: widget.company.totalOrder.validator >=
                      widget.company.totalOrderBefore.validator,
                ),
                buildItem(
                  title: 'Số lượng khách hàng',
                  content: widget.company.totalCustomer.formatPrice(),
                  subTitle: ' khách',
                  percent: getPercentWorkSpace(
                    widget.company.totalCustomer.validator,
                    widget.company.totalCustomerBefore.validator,
                  ),
                  isUp: widget.company.totalSales.validator >=
                      widget.company.totalCustomerBefore.validator,
                ),
              ],
            ).container(
              padding: 12.padingLeft,
              radius: 0,
              border: const Border(
                left: BorderSide(
                  color: AppColors.border_tertiary,
                ),
              ),
            ),
            // Text(
            //   'Doanh số',
            //   style: AppStyle.bodyBsRegular.copyWith(
            //     color: AppColors.text_secondary,
            //   ),
            // ),
            // 4.height,
            // NumberTrending(
            //   number:
            //       widget.company.totalSales.validator.formatPrice(type: ' đ'),
            //   percent: getPercentWorkSpace(
            //     widget.company.totalSales.validator,
            //     widget.company.totalSalesBefore.validator,
            //   ),
            //   isUp: widget.company.totalSales.validator >=
            //       widget.company.totalSalesBefore.validator,
            // ),
            // 8.height,
            // Text(
            //   'Số lượng đơn hàng',
            //   style: AppStyle.bodyBsRegular.copyWith(
            //     color: AppColors.text_secondary,
            //   ),
            // ),
            // 4.height,
            // NumberTrending(
            //   number: widget.company.totalOrder.validator.formatPrice(),
            //   subNumber: ' đơn',
            //   percent: getPercentWorkSpace(
            //     widget.company.totalOrder.validator,
            //     widget.company.totalOrderBefore.validator,
            //   ),
            //   isUp: widget.company.totalOrder.validator >=
            //       widget.company.totalOrderBefore.validator,
            // ),
            // 8.height,
            // Text(
            //   'Số lượng khách hàng',
            //   style: AppStyle.bodyBsRegular.copyWith(
            //     color: AppColors.text_secondary,
            //   ),
            // ),
            // 4.height,
            // NumberTrending(
            //   number: widget.company.totalCustomer.formatPrice(),
            //   subNumber: ' khách',
            //   percent: getPercentWorkSpace(
            //     widget.company.totalCustomer.validator,
            //     widget.company.totalCustomerBefore.validator,
            //   ),
            //   isUp: widget.company.totalSales.validator >=
            //       widget.company.totalCustomerBefore.validator,
            // ),
          ],
        ).container(padding: 12.pading),
      ),
    );
  }

  Widget buildItem({
    num percent = 0,
    bool isUp = false,
    String content = '',
    required String title,
    String? subTitle,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: AppStyle.bodyBsRegular.copyWith(
            color: AppColors.text_secondary,
          ),
        ),
        12.width,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            percentView(percent: percent, isUp: isUp),
            8.width,
            Text(
              content,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.headingXl.copyWith(
                color: isUp ? AppColors.text_positive : AppColors.text_negative,
              ),
            ).flexible(),
            if (subTitle != null)
              Text(
                subTitle,
                style: AppStyle.bodyBsRegular.copyWith(
                  color: AppColors.text_tertiary,
                  height: 1.6,
                ),
              ),
          ],
        ).flexible(),
      ],
    ).padding(8.padingVer);
  }

  Widget percentView({num percent = 0, bool isUp = false}) {
    return Container(
      padding: 5.padingHor + 3.padingVer,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: 6.radius,
        border: Border.all(color: AppColors.border_tertiary),
      ),
      child: Row(
        children: [
          Icon(
            isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded,
            color: isUp ? AppColors.text_positive : AppColors.text_negative,
            size: 15,
          ),
          2.width,
          Text(
            percent.formatPercent(type: '%'),
            textAlign: TextAlign.center,
            style: AppStyle.bodyXsRegular.copyWith(
              color: isUp ? AppColors.text_positive : AppColors.text_negative,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

double getPercentWorkSpace(num value1, num value2) {
  double percent = 0;
  if (value1 == 0 && value2 == 0) {
    percent = 0;
  } else if (value1 == 0 || value2 == 0) {
    percent = 1;
  } else if (value1 < value2) {
    percent = value2 / value1;
  } else {
    percent = value1 / value2;
  }
  return percent * 100;
}
