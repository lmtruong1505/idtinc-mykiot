import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features/order/widgets/scan_view.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../config/app_style/init_app_style.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key, required this.onScan});

  final Function(TypeScanView, String) onScan;

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  TypeScanView type = TypeScanView.barcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ScanView(
            type: type,
            onScaned: (code) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: 1.seconds,
                  content: Text(
                    'Code: $code',
                    style: p5.copyWith(color: whiteColor),
                  ),
                  backgroundColor: blackColor,
                ),
              );
              widget.onScan(type, code);
              context.pop();
            },
          ),
          SafeArea(
            child: Container(
              padding: 24.padingVer + 16.padingHor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.white,
                    ),
                  ),
                  12.height,
                  CupertinoSlidingSegmentedControl<TypeScanView>(
                    padding: 4.pading,
                    thumbColor: borderColor_1,
                    backgroundColor: whiteColor.withOpacity(0.2),
                    groupValue: type,
                    children: {
                      TypeScanView.barcodeShipment: Text(
                        'Quét mã lô',
                        style: p5.copyWith(
                          color: type == TypeScanView.barcodeShipment
                              ? blackColor
                              : whiteColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      TypeScanView.barcode: Text(
                        'Mã sản phẩm',
                        style: p5.copyWith(
                          color: type == TypeScanView.barcode
                              ? blackColor
                              : whiteColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      TypeScanView.qr: Container(
                        width: widthDevice(context) / 2,
                        padding: const EdgeInsets.all(sp12),
                        child: Text(
                          'Quét mã QR',
                          style: p5.copyWith(
                            color: type == TypeScanView.qr
                                ? blackColor
                                : whiteColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    },
                    onValueChanged: (value) =>
                        setState(() => type = value ?? TypeScanView.qr),
                  ),
                  gapHeight(sp24),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      type == TypeScanView.qr
                          ? 'QR Đơn thuốc/Đơn hàng'
                          : type == TypeScanView.barcode
                              ? 'Quét mã sản phẩm'
                              : 'Quét mã lô',
                      textAlign: TextAlign.center,
                      style: h5.copyWith(color: whiteColor),
                    ),
                  ),
                  // LabelButton(label: 'Quét', onPressed: () {
                  //   widget.onScan(type, 'DT171024-0037');
                  //   context.pop();
                  // }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
