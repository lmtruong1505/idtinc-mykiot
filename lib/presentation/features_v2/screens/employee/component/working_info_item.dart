import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features/company/domain/enum/enum_data.dart';
import 'package:pharmago/presentation/features_v2/models/employee/working_data_model.dart';
import 'package:pharmago/shared/components/widgets/app_switch.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/widgets/chip_custom.dart';
import '../../../../base/row_item.dart';
import '../../../../config/app_style/init_app_style.dart';

class WorkingInfoItem extends StatefulWidget {
  const WorkingInfoItem({
    super.key,
    required this.model,
    this.terminate,
    this.onChanged,
  });

  final WorkingDataModel model;
  final Function()? terminate;
  final Function(bool)? onChanged;

  @override
  State<WorkingInfoItem> createState() => _WorkingInfoItemState();
}

class _WorkingInfoItemState extends State<WorkingInfoItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        4.height,
        RowItem2(
          title: 'Trạng thái',
          content: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                getStatus(widget.model.status).title,
                style: AppStyle.bodyMdMedium,
              ),
              if (getStatus(widget.model.status) == EmployeeStatus.pending)
                8.width,
              if (getStatus(widget.model.status) == EmployeeStatus.pending)
                ChipCustom(
                  color: AppColors.button_negative_alpha_textDefault,
                  title: 'Hủy',
                  titleStyle: AppStyle.bodySmMedium,
                  padding: 8.padingHor + 4.padingVer,
                  isBorder: false,
                  onTap: widget.terminate,
                ),
            ],
          ),
        ),
        8.height,
        RowItem(
          title: 'Ngày nhận việc',
          content: widget.model.createdAt?.fomatDate2() ?? 'Không có thông tin',
        ),
      ],
    );
  }

  _buildHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.model.company?.workspaceName ?? 'Không có thông tin',
              style: AppStyle.bodyMdMedium.copyWith(
                color: AppColors.text_tertiary,
              ),
            ),
            6.height,
            Wrap(
              direction: Axis.horizontal,
              runSpacing: 6,
              spacing: 6,
              children: List.generate(widget.model.roleData.length, (index) {
                final role = widget.model.roleData[index];
                return ChipCustom(
                  color: AppColors.ultility_gray_60,
                  title: role.title.validator,
                );
              }),
            ),
          ],
        ).expanded(),
        if (getStatus(widget.model.status) != EmployeeStatus.pending &&
            getStatus(widget.model.status) != EmployeeStatus.terminate)
          AppSwitch(
            value: getStatus(widget.model.status) == EmployeeStatus.active,
            onChanged: (value) {
              widget.onChanged?.call(value);
            },
          ),
      ],
    );
  }

  EmployeeStatus getStatus(String? code) {
    return EmployeeStatus.fromCode(code);
  }
}
