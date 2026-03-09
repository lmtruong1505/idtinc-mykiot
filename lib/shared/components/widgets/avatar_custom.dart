import 'package:flutter/cupertino.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../presentation/base/cache_image.dart';
import '../../../presentation/config/app_style/init_app_style.dart';

class AvatarCustom extends StatelessWidget {
  final double size;
  final String url;
  final Widget? errorView;
  const AvatarCustom({
    super.key,
    this.size = 40,
    required this.url,
    this.errorView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: AppShadows.elevator1 + AppShadows.elevator0,
        color: AppColors.white,
      ),
      child: BaseCacheImage(
        url: 'url',
        height: size,
        width: size,
        borderRadius: size.radius,
        errorWidget: Icon(
          CupertinoIcons.person_solid,
          size: size * 0.7,
        ),
      ),
    );
  }
}
