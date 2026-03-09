import 'package:flutter/material.dart';

class AppGridView extends StatelessWidget {
  const AppGridView({
    super.key,
    this.itemCount,
    this.pading,
    this.mainAxisExtent,
    this.physics,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    required this.crossAxisCount,
    required this.itemBuilder,
    this.controller,
  });

  final int? itemCount;
  final EdgeInsetsGeometry? pading;
  final double? mainAxisExtent;
  final ScrollPhysics? physics;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final int crossAxisCount;
  final Widget? Function(BuildContext, int) itemBuilder;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller,
      padding: pading,
      physics: physics,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisExtent: mainAxisExtent,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      ),
      itemBuilder: itemBuilder,
      itemCount: itemCount,
    );
  }
}
