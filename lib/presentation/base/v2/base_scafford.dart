import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../constants/asset_path.dart';
import '../../constants/colors.dart';
class BaseScaffold extends StatelessWidget {
  const BaseScaffold({
    super.key,
    this.title,
    this.body,
    this.appBar,
    this.bottomNavigationBar, this.backgroundColor, this.resizeToAvoidBottomInset, this.padding,
  });

  final String? title;
  final Widget? body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: context.height,
        width: context.width,
        padding: padding ?? 0.pading,
        decoration: const BoxDecoration(
          color: whiteColor,
          image: DecorationImage(
            image: AssetImage(
              '${AssetsPath.image}/background_v2.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: body,
      ),
    );
  }
}
