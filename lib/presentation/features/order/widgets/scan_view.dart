import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../constants/size_device.dart';
import '../../../constants/typography.dart';

enum TypeScanView {
  qr,
  barcode,
  barcodeShipment,
}

class ScanView extends StatefulWidget {
  const ScanView({
    super.key,
    this.onScaned,
    this.type = TypeScanView.qr,
  });

  final Function(String code)? onScaned;
  final TypeScanView type;

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  bool debounce = false;

  Timer? timer;

  String barcodePrevious = '';

  // Future<void> _getVariantByScanBarcod(String barcode) async {
  //   if (debounce) {
  //     return;
  //   }
  //   debounce = true;
  //   await widget.orderCreateCubit.getVariantByScanBarcode(context, barcode);
  //   debounce = false;
  // }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widthDevice(context),
      height: heightDevice(context),
      child: _buildQrView(context),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.white,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 3,
        cutOutWidth: 250,
        cutOutHeight: widget.type == TypeScanView.qr ? 250 : 120,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    // log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(sp12),
          ),
          backgroundColor: yellow_1,
          content: Text(
            'Vui lòng cấp quyền cho ứng dụng truy cập Camera!',
            style: p5.copyWith(color: whiteColor),
          ),
        ),
      );
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // _getVariantByScanBarcod(scanData.code ?? '');

      if (scanData.code == barcodePrevious) {
        Timer(const Duration(seconds: 3), () {
          barcodePrevious = '';
        });
        return;
      }
      barcodePrevious = scanData.code ?? '';
      timer ??= Timer(const Duration(milliseconds: 100), () async {
        widget.onScaned?.call(
          scanData.code ?? '',
        );
        timer = null;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
