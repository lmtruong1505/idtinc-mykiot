import 'package:flutter/material.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/shared/ext/ext_num.dart';


class SwitchRow extends StatelessWidget {
  const SwitchRow({
    required this.title,
    required this.value,
    this.onChanged,
    this.borderRadius,
    this.color,
    super.key,
  });

  final String title;
  final bool value;
  final Function(bool value)? onChanged;
  final double? borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? bg_6,
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
      ),
      padding: 8.padingHor,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: whiteColor,
            activeTrackColor: mainColor,
            inactiveTrackColor: borderColor_2,
            trackOutlineWidth: WidgetStateProperty.all(0),
          ),
        ],
      ),
    );
  }
}
