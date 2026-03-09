// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/generated/assets.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../shared/components/widgets/fa_icon.dart';
import '../config/app_style/init_app_style.dart';

class BaseCacheImage extends StatelessWidget {
  const BaseCacheImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit,
    this.borderRadius = BorderRadius.zero,
    this.errorWidget,
    this.loadPharmagoLogo = false,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final BorderRadius borderRadius;
  final bool? loadPharmagoLogo;
  final Widget? errorWidget;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: 0.pading,
      child: (url.isEmptyOrNull && loadPharmagoLogo == true)
          ? Image.asset(
              Assets.assetsLogo1,
              width: width,
              height: height,
            )
          : Image.network(
              url,
              width: width,
              height: height,
              fit: fit ?? BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: errorWidget ??
                      Container(
                        padding: const EdgeInsets.all(sp12),
                        decoration: BoxDecoration(
                          color: AppColors.bg_secondary,
                          borderRadius: borderRadius,
                          border: Border.all(color: AppColors.border_tertiary),
                        ),
                        child: FaIcon(
                          iconCode: 'f03e',
                          color: AppColors.fg_disable,
                        ),
                      ),
                );
              },
            ),
      // CachedNetworkImage(
      //     width: width,
      //     height: height,
      //     imageUrl: url,
      //     fit: fit ?? BoxFit.contain,
      //     imageBuilder: (context, imageProvider) => Container(
      //       decoration: BoxDecoration(
      //         image: DecorationImage(
      //           image: imageProvider,
      //           fit: BoxFit.cover,
      //           // colorFilter: const ColorFilter.mode(
      //           //     Colors.transparent, BlendMode.colorBurn),
      //         ),
      //         border: Border.all(
      //           width: 1,
      //           color: AppColors.bg_secondary,
      //         ),
      //       ),
      //     ),
      //     placeholder: (context, url) => Center(
      //       child: LoadingAnimationWidget.hexagonDots(
      //         color: AppColors.brand,
      //         size: 32,
      //       ),
      //     ),
      //     errorWidget: (context, url, error) =>
      //         errorWidget ??
      //         Container(
      //           decoration: BoxDecoration(
      //             color: AppColors.bg_secondary,
      //             borderRadius: borderRadius,
      //             border: Border.all(color: AppColors.border_tertiary),
      //           ),
      //           child: Center(
      //             child: FaIcon(
      //               iconCode: 'f03e',
      //               color: AppColors.fg_disable,
      //             ),
      //           ),
      //         ),
      //   ),
    );
  }
}

// class BaseCacheImageV2 extends StatelessWidget {
//   const BaseCacheImageV2({
//     super.key,
//     required this.url,
//     this.width,
//     this.height,
//     this.fit,
//     this.borderRadius = BorderRadius.zero,
//     this.errorWidget,
//   });

//   final String url;
//   final double? width;
//   final double? height;
//   final BoxFit? fit;
//   final BorderRadius borderRadius;
//   final Widget? errorWidget;
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: borderRadius,
//       child: CachedNetworkImage(
//         width: width,
//         height: height,
//         imageUrl: url,
//         fit: fit ?? BoxFit.cover,
//         imageBuilder: (context, imageProvider) => Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: imageProvider,
//               fit: BoxFit.cover,
//             ),
//             border: Border.all(width: 0),
//           ),
//         ),
//         placeholder: (context, url) => Center(
//           child: LoadingAnimationWidget.hexagonDots(
//             color: AppColors.brand,
//             size: 32,
//           ),
//         ),
//         errorWidget: (context, url, error) =>
//             errorWidget ??
//             Container(
//               decoration: BoxDecoration(
//                 color: AppColors.bg_secondary,
//                 borderRadius: borderRadius,
//                 border: Border.all(color: AppColors.border_tertiary),
//               ),
//               child: Center(
//                 child: FaIcon(
//                   iconCode: 'f03e',
//                   color: AppColors.fg_disable,
//                 ),
//               ),
//             ),
//       ),
//     );
//   }
// }
