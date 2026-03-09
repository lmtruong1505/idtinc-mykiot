import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/models/employee/working_data_model.dart';
import 'package:pharmago/shared/components/button/label_button.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/dialog/dialog_confirm.dart';
import '../../../../../shared/components/dialog/dialog_message.dart';
import '../../../../../shared/components/widgets/chip_custom.dart';
import '../../../../../shared/components/widgets/fa_icon.dart';
import 'dialog_assign.dart';

class BranchAndRoleItem extends StatelessWidget {
  const BranchAndRoleItem({
    super.key,
    required this.data,
    this.onEdit,
    this.isUpdate = false,
    this.onDelete,
    this.canEdit = true,  // Nhan vien co phieu kham hoac lich hen thi khong duoc sua vai tro
  });

  final WorkingDataModel data;
  final Function(WorkingDataModel data)? onEdit;
  final bool isUpdate;
  final VoidCallback? onDelete;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              data.company?.workspaceName ?? '',
              style: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.text_secondary,
              ),
            ).expanded(),
            8.width,
            _buildBtn(context),
          ],
        ),
        6.height,
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: data.roleData
              .map(
                (e) => ChipCustom(
                  color: AppColors.ultility_gray_60,
                  title: e.title.validator,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  _buildBtn(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        LabelButton(
          label: 'Sửa',
          labelStyle: AppStyle.bodySmMedium.copyWith(
            color: AppColors.button_neutral_outlined_textDefault,
          ),
          backgroundColor: AppColors.bg_primary,
          border: BorderSide(
            color: AppColors.button_neutral_outlined_borderDefault
                .withOpacity(0.6),
            width: 1,
          ),
          onPressed: () {
            if(canEdit) {
              context.dialog(
              DialogAssign(
                company: data.company,
                roleData: data.roleData,
                isUpdate: isUpdate,
                oldWs: data.id,
              ),
            ).then((value) {
              if (value != null) {
                onEdit?.call(value as WorkingDataModel);
              }
            });
            } else {
              _showDialog(context);
            }
            // context.router.push(
            //   AddWorkToEmpRoute(
            //     company: data.company,
            //     roleData: data.roleData,
            //     isUpdate: isUpdate,
            //     oldWs: data.id,
            //   ),
            // ).then((value) {
            //   if (value != null) {
            //     onEdit?.call(value as WorkingDataModel);
            //   }
            // });
          },
          padding: 8.padingHor + 4.padingVer,
          fit: FlexFit.loose,
        ).size(height: 24, width: 42),
        12.width,
        LabelButton(
          label: 'Xoá',
          labelStyle: AppStyle.bodySmMedium.copyWith(
            color: AppColors.button_negative_alpha_textDefault,
          ),
          backgroundColor: AppColors.button_negative_alpha_backgroundDefault
              .withOpacity(0.1),
          onPressed: () => {
            if(canEdit) {
              onDelete?.call()
            }
            else{
              _showDialog(context)
            }
          },
          padding: 8.padingHor + 4.padingVer,
          fit: FlexFit.loose,
        ).size(height: 24, width: 42),
      ],
    );
  }

  void _showDialog(BuildContext context) {
    context.dialog(
      DialogConfirm(
        title: 'Cảnh báo',
        content: const Text(
          'Có lịch hẹn hoặc phiếu khám chưa hoàn thành, không thể đổi vai trò và cơ sở của nhân viên!',
          textAlign: TextAlign.center,
        ),
        closeLabel: 'Trở lại',
        isWarning: true,
        icon: IconDiaLog(
          color: AppColors.fg_warning.withOpacity(0.1),
          icon: FaIcon(
            iconCode: 'f071',
            color: AppColors.fg_warning,
            type: FaIconType.solid,),
        ),
      ),
    );
  }
}
