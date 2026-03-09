import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features_v2/models/employee/pre_emp_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../base/check_box.dart';
import '../../../../config/app_style/init_app_style.dart';
import 'emp_item_2.dart';

class RmEmpItem extends StatelessWidget {
  const RmEmpItem({
    super.key,
    required this.emp,
    required this.isSelected,
    this.onToggle,
  });

  final PreEmpModel emp;
  final bool isSelected;
  final Function(bool)? onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bg_primary,
        border: Border(
          top: BorderSide(
            color: AppColors.border_tertiary,
            width: 1,
          ),
        ),
      ),
      padding: 12.pading,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BaseCheckbox2(
            value: isSelected,
            onChanged: (value) {

              if(value != null) {
                onToggle?.call(value);
              }
            },
          ),
          16.width,
          EmpItem2(emp: emp).expanded(),
        ],
      ),
    );
  }
}
