import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pharmago/presentation/features_v2/models/customer/file_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/utils/launch_url.dart';

import '../../../../../shared/style_app/init_style.dart';

class ItemFile extends StatelessWidget {
  final FileModel item;
  final bool isLocal;
  final bool isBorder;
  final Function()? delete;
  const ItemFile({
    super.key,
    this.delete,
    this.isLocal = false,
    this.isBorder = false,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (item.url.isEmptyOrNull) {
          return;
        } else if (!isLocal) {
          LaunchUrl.url(item.url!);
        } else if (isLocal) {
          OpenFile.open(item.url ?? '');
        }
      },
      child: Container(
        padding: Dimensions.sp16.padingHor,
        decoration: BoxDecoration(
          color: ColorApp.white,
          borderRadius: Dimensions.sp8.radius,
          border: isBorder ? Border.all(color: ColorApp.greyF2) : null,
        ),
        child: Row(
          children: [
            Text(
              item.title ?? 'Bệnh án',
              style: StyleApp.semibold(),
            ).expanded(),
            Dimensions.sp12.width,
            Center(
              child: Text(
                'Xem file',
                style: StyleApp.semibold(color: ColorApp.main),
              ),
            ).size(height: 50),
            if (delete != null) ...[
              Dimensions.sp12.width,
              InkWell(
                onTap: delete,
                child: Center(
                  child: Text(
                    'Xoá',
                    style: StyleApp.semibold(color: ColorApp.red),
                  ),
                ).size(height: 50),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
