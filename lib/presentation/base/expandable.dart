import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';

class Expandable extends StatefulWidget {
  final String header;
  final Widget? headerWidget;
  final Widget child;
  const Expandable({
    super.key,
    required this.header,
    required this.child,
    this.headerWidget,
  });
  @override
  State<Expandable> createState() => _ExpandableState();
}

class _ExpandableState extends State<Expandable> {
  late ExpandableController controller =
      ExpandableController(initialExpanded: true)
        ..addListener(() => setState(() {}));
  @override
  Widget build(BuildContext context) => ExpandablePanel(
        controller: controller,
        theme: const ExpandableThemeData(hasIcon: false),
        header: Container(
          padding: const EdgeInsets.all(sp16),
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
              widget.headerWidget ?? Text(widget.header, style: p3),
              AnimatedRotation(
                turns: !controller.expanded ? 0 : 0.5,
                duration: const Duration(milliseconds: 300),
                child: IcSvg.asset('/ic_arrow_down.svg'),
              ),
            ],
          ),
        ),
        collapsed: const SizedBox(),
        expanded: Container(
          padding: const EdgeInsets.fromLTRB(sp16, sp0, sp16, sp24),
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
              const Divider(height: 2, color: borderColor_2),
              gapHeight(sp12),
              widget.child,
            ],
          ),
        ),
      );
}
