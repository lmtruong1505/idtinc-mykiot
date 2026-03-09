import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmago/gen/flutter_assets.dart';

import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/shared/components/button/icon_btn.dart';
import 'package:pharmago/shared/components/dialog/dialog_confirm.dart';
import 'package:pharmago/shared/components/dialog/dialog_message.dart';
import 'package:pharmago/shared/components/widgets/chip_custom.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../../config/app_style/init_app_style.dart';
import '../../../../../features_v2/blocs/role_v2/role_per_ws_bloc.dart';
import '../../../cubit/action_company_bloc.dart';
import '../../../cubit/company_choose_bloc.dart';
import '../../../cubit/work_space/work_space_cubit.dart';
import '../../../domain/entities/company_entity.dart';

class ItemStaffWorkSpace extends StatefulWidget {
  final CompanyEntity company;

  const ItemStaffWorkSpace({
    super.key,
    required this.company,
  });

  @override
  State<ItemStaffWorkSpace> createState() => _ItemStaffWorkSpaceState();
}

class _ItemStaffWorkSpaceState extends State<ItemStaffWorkSpace> {
  final bloc = ActionCompanyBloc();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActionCompanyBloc, CubitState>(
      bloc: bloc,
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
        onTap: () {
          if (widget.company.statusUserWorkPending) {
            confirmInWork(true);
          } else {
            getIt<CompanyChooseBloc>().company = widget.company;
            getIt<RolePermissionWsBloc>().getRolePer(widget.company.id ?? -1);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ChipBadgeCustom(
                  color: widget.company.parentId == null
                      ? AppColors.ultility_brand_60
                      : AppColors.ultility_gray_60,
                  title: widget.company.parentId == null
                      ? 'Trụ sở chính'
                      : 'Cơ sở',
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_outward_sharp,
                  size: 15,
                ),
              ],
            ),
            4.height,
            Text(
              widget.company.name ?? '',
              style: AppStyle.headingXl.copyWith(
                color: AppColors.text_secondary,
              ),
            ),
            4.height,
            Text(
              widget.company.typeName ?? '',
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_tertiary,
              ),
            ),
            8.height,
            Text(
              widget.company.address?.formatAddress ?? 'Chưa có thông tin',
              style: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.text_tertiary,
              ),
            ),
            16.height,
            if (widget.company.statusUserWorkPending)
              Row(
                children: [
                  16.width,
                  Text(
                    'Xác nhận thành viên',
                    style: AppStyle.bodyBsMedium.copyWith(
                      color: AppColors.text_secondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ).expanded(),
                  IconBtn(
                    onTap: () => confirmInWork(false),
                    size: const Size(24, 24),
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.close,
                      size: 17,
                    ),
                  ),
                  12.width,
                  IconBtn(
                    onTap: () => confirmInWork(true),
                    backgroundColor: AppColors.greenAlpha10,
                    padding: EdgeInsets.zero,
                    size: const Size(24, 24),
                    icon: const Icon(
                      Icons.check,
                      size: 17,
                      color: AppColors.brand,
                    ),
                  ),
                ],
              ).container(
                bgColor: AppColors.bg_secondary,
                radius: 8,
                padding: 8.pading,
              ),
          ],
        ).container(
          boxShadow: widget.company.statusUserWorkPending
              ? AppShadows.elevator1
              : null,
          radius: 16,
        ),
      ),
    );
  }

  confirmInWork(bool isActive) {
    //bloc.setInWork(widget.company.id ?? -1, true)
    context.dialog(
      DialogConfirm(
        title: 'Xác nhận ${isActive ? 'thành viên' : "từ chối"}',
        content: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: isActive
                ? 'Bạn có đồng ý xác nhận là thành viên của '
                : 'Bạn có chắc chắn xác nhận từ chối là thành viên của ',
            style: AppStyle.bodyBsRegular.copyWith(
              color: AppColors.text_secondary,
            ),
            children: [
              TextSpan(
                text: widget.company.name ?? '',
                style: AppStyle.bodyBsSemiBold.copyWith(
                  color: AppColors.text_secondary,
                ),
              ),
              TextSpan(
                text: ' không?',
                style: AppStyle.bodyBsRegular.copyWith(
                  color: AppColors.text_secondary,
                ),
              ),
            ],
          ),
        ),
        //confirmLabel: value.title,
        actionConfirmBorder: !isActive,
        colorConfirmBtn: !isActive
            ? AppColors.button_negative_outlined_textDefault
            : AppColors.button_brand_solid_backgroundDefault,
        icon: icon(isActive),
        confirm: () {
          context.pop();
          bloc.setInWork(widget.company.id ?? -1, isActive);
        },
      ),
    );
  }

  IconDiaLog icon(bool isActive) {
    switch (isActive) {
      case false:
        return IconDiaLog(
          color: AppColors.fg_negative.withOpacity(0.1),
          icon: SvgPicture.asset(
            Assets.svgClose,
          ),
        );

      default:
        return IconDiaLog(
          color: AppColors.fg_positive.withOpacity(0.1),
          icon: SvgPicture.asset(
            Assets.svgSuccess,
          ),
        );
    }
  }
}
