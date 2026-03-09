import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/check_box.dart';
import 'package:pharmago/presentation/features_v2/screens/role_v2/components/emp_item.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../config/app_style/init_app_style.dart';
import '../../../../features/branch/data/entities/branch_emp_entity.dart';

class AssignEmpItem extends StatelessWidget {
  const AssignEmpItem({super.key, required this.emp, required this.isSelected, this.onToggle});

  final BranchEmpEntity emp;
  final  bool isSelected;
   final Function(bool)? onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bg_primary,
      ),
      padding: 10.padingHor + 4.padingVer,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          if(emp.employee != null)
            EmpItem(emp: emp.employee!).expanded(),
        ],
      ),
    );
  }
}
