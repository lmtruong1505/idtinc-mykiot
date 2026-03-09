import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../config/app_style/init_app_style.dart';
import '../../../../constants/spacing.dart';

class PathologyCreateBts extends StatelessWidget {
  PathologyCreateBts({
    super.key,
    this.onConfirm,
  });

  final Function(String, String)? onConfirm;

  static void show(
    BuildContext context, {
    String? code,
    String? name,
    Function(String, String)? onConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return PathologyCreateBts(
          onConfirm: onConfirm,
        );
      },
    );
  }

  final nameTec = TextEditingController();
  final codeTec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: const EdgeInsets.all(sp16).copyWith(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      duration: const Duration(milliseconds: 300),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: sp64,
            height: sp4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(sp24),
              color: AppColors.bg_disable,
            ),
          ),
          sp16.height,
          Text(
            'Thêm chẩn đoán',
            style: s16w700.copyWith(
              color: AppColors.text_primary,
            ),
          ),
          sp16.height,
          InputColumn(
            controller: nameTec,
            label: 'Mã chẩn đoán',
            hintText: 'Nhập mã chẩn đoán',
            isRequired: true,
            padding: const EdgeInsets.all(sp0),
          ),
          sp16.height,
          InputColumn(
            controller: codeTec,
            label: 'Chẩn đoán',
            hintText: 'Nhập tên chẩn đoán',
            isRequired: true,
            padding: const EdgeInsets.all(sp0),
          ),
          const Divider(height: sp32),
          Row(
            children: [
              Expanded(
                child: MainButton(
                  title: 'Xác nhận',
                  radius: sp24,
                  event: () {
                    onConfirm?.call(
                      nameTec.text,
                      codeTec.text,
                    );
                  },
                ),
              ),
            ],
          ),
          sp24.height,
        ],
      ),
    );
  }
}
