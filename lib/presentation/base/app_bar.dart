import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import '../constants/colors.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({
    super.key,
    required this.title,
    this.height = kToolbarHeight,
    this.bottom,
    this.actions,
    this.leading,
    this.elevation = 1,
    this.centerTitle = true,
  });
  final String title;
  final double elevation;
  final double height;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final bool? centerTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: whiteColor,
      title: Text(
        title,
        style: AppStyle.headingBs,
      ),
      iconTheme: const IconThemeData(color: blackColor),
      actions: actions ?? [],
      bottom: bottom,
      leading: leading,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
