import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../presentation/config/app_style/init_app_style.dart';
import 'app_input.dart';

class InputQuantity extends StatelessWidget {
  final TextEditingController controller;
  final Function(int value) onChanged;
  final Function(String)? onConfirm;
  final Function()? onTapOutside;
  final Function(bool value) action;
  final bool enabled;
  final int max;
  const InputQuantity({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.action,
    this.enabled = false,
    this.max = 1000000000,
    this.onConfirm,
    this.onTapOutside,
  });

  @override
  Widget build(BuildContext context) {
    return AppInputV2(
      hintText: '-',
      textAlign: TextAlign.center,
      radius: 6,
      controller: controller,
      textInputType: TextInputType.number,
      contentPadding: EdgeInsets.zero,
      inputFormatters: [
        // CurrencyTextInputFormatter.currency(locale: 'vi', symbol: ''),
        LengthLimitingTextInputFormatter(8),
      ],
      onChanged: (value) {
        final num = int.tryParse(value.removeAllDot()) ?? 1;
        if (num > max) {
          controller.text = max.toString();
        }
        onChanged(num > max ? max : num);
      },
      onTapOutside: onTapOutside,
      onConfirm: onConfirm,
      prefixIcon: _iconAction(
        icon: Icons.remove,
        onTap: () {
          action(false);
          context.unFocus();
        },
      ),
      suffixIcon: _iconAction(
        icon: Icons.add,
        isLeft: true,
        onTap: () {
          action(true);
          context.unFocus();
        },
      ),
      prefixIconConstraints: const BoxConstraints(maxWidth: 32, maxHeight: 32),
      suffixIconConstraints: const BoxConstraints(maxWidth: 32, maxHeight: 32),
      borderColor:
          enabled ? AppColors.ultility_negative_60 : AppColors.border_secondary,
    ).size(height: 32);
  }

  InkWell _iconAction({
    required Function() onTap,
    required IconData icon,
    bool isLeft = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          border: Border(
            right: isLeft
                ? BorderSide.none
                : const BorderSide(
                    color: AppColors.border_secondary,
                    width: 1,
                  ),
            left: !isLeft
                ? BorderSide.none
                : const BorderSide(
                    color: AppColors.border_secondary,
                    width: 1,
                  ),
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 12,
          ),
        ),
      ),
    );
  }
}
