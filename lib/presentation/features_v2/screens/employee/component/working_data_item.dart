import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features/company/domain/enum/enum_data.dart';
import 'package:pharmago/presentation/features_v2/models/employee/working_data_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/widgets/chip_custom.dart';
import '../../../../config/app_style/init_app_style.dart';

class WorkingDataItem extends StatelessWidget {
  const WorkingDataItem({super.key, required this.model});

  final WorkingDataModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        12.height,
        _buildRoleData(),
      ],
    );
  }

  _buildHeader() {
    return Row(
      children: [
        Text(
          model.company?.workspaceName ?? 'Không có thông tin',
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_secondary,
          ),
        ).expanded(),
        ChipBadgeCustomEmp(
          status: EmployeeStatus.fromCode(model.status),
        ),
      ],
    );
  }

  _buildRoleData() {
    return Wrap(
      direction: Axis.horizontal,
      runAlignment: WrapAlignment.start,
      spacing: 6,
      runSpacing: 6,
      children: List.generate(model.roleData.length, (index) {
        final role = model.roleData[index];
        return ChipCustom(color: AppColors.ultility_gray_60, title: role.title.validator);
      }),
    );
  }
}
