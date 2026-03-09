import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmago/gen/flutter_assets.dart';
import 'package:pharmago/presentation/check_version/check_vesion.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';
import 'package:pharmago/shared/utils/launch_url.dart';

class UpdateAppDialog extends StatelessWidget {
  final ModelVersion version;
  const UpdateAppDialog({
    super.key,
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: 16.radius,
          color: ColorApp.white,
        ),
        padding: 16.pading,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x21000000),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(Assets.imgsUpdateApp),
                ),
              ],
            ),
            16.height,
            Text(
              'Cập nhật ứng dụng?',
              style: StyleApp.semibold(fontSize: 20),
            ),
            2.height,
            Text(
              'Phiên bản mới đã hoàn thiện.\n'
              'Phiên bản mới ${version.version ?? "1.0.0"}.\n'
              'Phiên bản hiện tại của bạn ${version.localVersion ?? "1.0.0"}',
              style: StyleApp.normal(fontSize: 16, color: ColorApp.grey51),
            ),
            24.height,
            Text(
              'Ghi chú cập nhật:',
              style: StyleApp.semibold(fontSize: 16, color: ColorApp.grey51),
            ),
            if (version.notes.validator.isNotEmpty)
              ...List.generate(
                version.notes!.length,
                (index) => Text(
                  '${index + 1}. ${version.notes![index]}',
                  style: StyleApp.normal(fontSize: 16, color: ColorApp.grey51),
                ),
              )
            else
              Text(
                'Nâng cấp hiệu năng và sữa lỗi ứng dụng',
                style: StyleApp.normal(fontSize: 16, color: ColorApp.grey51),
              ),
            16.height,
            MainButtonV2(
              onTap: () {
                if (version.url.isEmptyOrNull == false) {
                  LaunchUrl.url(version.url ?? '');
                }
              },
              radius: 40,
              backgroundColor: ColorApp.black,
              title: 'Cập nhật',
            ),
          ],
        ),
      ),
    );
  }
}
