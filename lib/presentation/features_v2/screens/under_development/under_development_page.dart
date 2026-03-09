import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../constants/asset_path.dart';

@RoutePage()
class UnderDevelopmentPage extends StatefulWidget {
  const UnderDevelopmentPage({super.key, required this.title});

  final String title;

  @override
  State<UnderDevelopmentPage> createState() => _UnderDevelopmentPageState();
}

class _UnderDevelopmentPageState extends State<UnderDevelopmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTitleCenter(
        title: widget.title,
        leadingText: 'Trở về',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              '${AssetsPath.image}/under_dev.png',
              width: 200,
              height: 200,
            ),
            Text(
              'Chức năng đang phát triển',
              style: AppStyle.headingLg,
            ),
            64.height,
          ],
        ),
      ),
    );
  }
}
