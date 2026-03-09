import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ImageUtils {
  static Future<bool> saveImage(String? url, BuildContext context) async {
    try {
      PermissionStatus? status;
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt <= 32) {
          status = await Permission.storage.request();
        } else {
          status = await Permission.photos.request();
        }
      } else {
        status = await Permission.photos.request();
      }

      if (!status.isGranted) {
        DialogUtils.showWarningDialog(
          context,
          content:
              'Quyền bị truy cập ảnh bị từ chối! .Mở lại vui lòng cấp quyền để lưu ảnh',
          titleConfirm: 'Mở AppSetting',
          accept: () => openAppSettings(),
          close: () => Navigator.pop(context),
        );
        // Toast.showToast(
        //     'Quyền bị truy cập ảnh bị từ chối! .Mở lại vui lòng cấp quyền để lưu ảnh',
        //     context);

        return false;
      }

      // 2. Tải ảnh từ URL bằng Dio
      final Dio dio = Dio();
      DialogUtils.showLoadingDialog(context, 'Đang tải xuống');
      final response = await dio.get(
        url ?? '',
        options: Options(responseType: ResponseType.bytes),
      );

      // 3. Chuyển dữ liệu ảnh thành Uint8List
      final Uint8List imageData = Uint8List.fromList(response.data);

      // 4. Lưu ảnh vào thư viện ảnh
      // await ImageGallerySaver.saveImage(imageData);
      Navigator.pop(context);
      DialogUtils.showSuccessDialog(
        context,
        content: 'Ảnh đã được lưu',
        accept: () => Navigator.pop(context),
        close: () => Navigator.pop(context),
      );

      return true;
    } catch (e) {
      Navigator.pop(context);
      DialogUtils.showSuccessDialog(
        context,
        content: 'Lỗi khi lưu ảnh: $e',
        accept: () => Navigator.pop(context),
        close: () => Navigator.pop(context),
      );
      return false;
    }
  }
}
