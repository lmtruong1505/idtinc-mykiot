import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/two_button_box.dart';
import 'package:pharmago/presentation/constants/asset_path.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';

@RoutePage()
class OrderCreateSuccessPage extends StatefulWidget {
  const OrderCreateSuccessPage({
    super.key,
    this.id,
  });

  final int? id;

  @override
  State<OrderCreateSuccessPage> createState() => _OrderCreateSuccessPageState();
}

class _OrderCreateSuccessPageState extends State<OrderCreateSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(sp16),
        padding: const EdgeInsets.all(sp16),
        height: heightDevice(context),
        width: widthDevice(context),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(sp12),
        ),
        child: Column(
          children: [Image.asset('${AssetsPath.image}/logo.png')],
        ),
      ),
      bottomNavigationBar: TwoButtonBox(
        mainTitle: 'Về trang chủ',
        extraTitle: 'In lại bill',
        mainOnTap: () {},
        extraOnTap: () {},
      ),
    );
  }
}
