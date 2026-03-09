import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/features_v2/models/customer/message_zalo_model.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

class BtsImagePreview extends StatelessWidget {
  final Attachments image;
  const BtsImagePreview({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: 24.radiusTop,
        color: Colors.black,
      ),
      padding: 16.pading,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: 5.radius,
                ),
                width: 70,
                height: 5,
              ),
            ],
          ),
          Center(
            child: image.isFile == true
                ? Image.file(File(image.url ?? ''))
                : BaseCacheImage(
                    url: image.url ?? '',
                    fit: BoxFit.contain,
                  ),
          ).expanded(),
        ],
      ),
    );
  }
}
