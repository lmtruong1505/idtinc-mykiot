import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

extension ExtWidget on Widget {
  ClipRRect radius(BorderRadius value) {
    return ClipRRect(
      borderRadius: value,
      child: this,
    );
  }

  Padding padding(EdgeInsets value) {
    return Padding(
      padding: value,
      child: this,
    );
  }

  Expanded expanded({int flex = 1}) {
    return Expanded(
      flex: flex,
      child: this,
    );
  }

  Flexible flexible({int flex = 1}) {
    return Flexible(
      flex: flex,
      child: this,
    );
  }

  SizedBox size({
    double? height,
    double? width,
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: this,
    );
  }

  Widget container({
    double? height,
    double? width,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? bgColor,
    double? radius = 8,
    Border? border,
    List<BoxShadow>? boxShadow,
  }) {
    return Container(
      height: height,
      width: width,
      padding: padding ?? 16.pading,
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor ?? ColorApp.white,
        borderRadius: radius.radius,
        border: border,
        boxShadow: boxShadow,
      ),
      child: this,
    );
  }

  InkWell unDev(BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ColorApp.main,
            content: const Text('Chức năng đang phát triển'),
            duration: 1.seconds,
          ),
        );
      },
      child: this,
    );
  }
}
