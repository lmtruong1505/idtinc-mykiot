import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../config/app_style/init_app_style.dart';

class ExpandableV2 extends StatefulWidget {
  final String header;
  final Widget? headerWidget;
  final Widget child;

  const ExpandableV2({
    super.key,
    required this.header,
    required this.child,
    this.headerWidget,
  });

  @override
  State<ExpandableV2> createState() => _ExpandableV2State();
}

class _ExpandableV2State extends State<ExpandableV2> {
  late ExpandableController controller =
      ExpandableController(initialExpanded: true)
        ..addListener(() => setState(() {}));

  @override
  Widget build(BuildContext context) => ExpandablePanel(
        controller: controller,
        theme: const ExpandableThemeData(hasIcon: false),
        header: Container(
          padding: 16.padingTop,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(sp8),
              bottom: Radius.circular(controller.expanded ? sp0 : sp8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.headerWidget ??
                  Text(
                    widget.header,
                    style: AppStyle.bodyMdMedium.copyWith(
                      color: AppColors.text_quaternary,
                    ),
                  ),
              AnimatedRotation(
                turns: !controller.expanded ? 0 : 0.5,
                duration: const Duration(milliseconds: 300),
                child: const Icon(
                  Icons.keyboard_arrow_up_outlined,
                  color: AppColors.text_quaternary,
                ),
              ),
            ],
          ),
        ),
        collapsed: const SizedBox(),
        expanded: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(sp12),
            ),
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.1),
                offset: const Offset(1, 1),
                blurRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: [
              widget.child,
            ],
          ),
        ),
      );
}
