import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

void handleQrCode({
  required BuildContext context,
  required Function(String value) onCode,
}) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const SimpleBarcodeScannerPage(),
    ),
  ).then((value) {
    if (value != null && value is String) {
      onCode(value);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không tìm thấy mã vạch'),
        ),
      );
    }
  });
}
