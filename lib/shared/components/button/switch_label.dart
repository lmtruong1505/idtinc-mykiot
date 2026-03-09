import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../presentation/config/app_style/init_app_style.dart';

class SwitchLabel extends StatefulWidget {
  final String label;
  final bool value;
  final TextStyle? style;

  final Function(bool val)? onChanged;

  const SwitchLabel({
    super.key,
    required this.label,
    this.value = false,
    this.onChanged,
    this.style,
  });

  @override
  State<SwitchLabel> createState() => _SwitchLabelState();
}

class _SwitchLabelState extends State<SwitchLabel> {
  bool value = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.label,
          overflow: TextOverflow.ellipsis,
          style: widget.style ?? AppStyle.bodyBsMedium,
        ).expanded(),
        CupertinoSwitch(
          value: value,
          activeColor: AppColors.ultility_blue,
          onChanged: (val) {
            value = val;
            setState(() {});
            widget.onChanged?.call(value);
          },
        ).size(height: 24),
      ],
    ).container(
      radius: 8,
      padding: 12.pading,
      boxShadow: AppShadows.elevator0,
      border: Border.all(color: AppColors.input_borderDefault),
    );
  }
}
