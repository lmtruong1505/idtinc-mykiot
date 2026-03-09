import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/spacing.dart';
import 'button.dart';

class TwoButtonBox extends StatelessWidget {
  final String? extraTitle;
  final String? mainTitle;
  final VoidCallback? extraOnTap;
  final VoidCallback? mainOnTap;
  final bool isDisable;
  final BorderRadiusGeometry? borderRadius;

  const TwoButtonBox({
    super.key,
    this.extraTitle = '',
    this.mainTitle = '',
    this.extraOnTap,
    this.mainOnTap,
    this.borderRadius,
    this.isDisable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: whiteColor,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            spreadRadius: 1,
            blurRadius: 15,
            offset: Offset(0, 0.3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 1,
            child: ExtraButton(
              title: extraTitle ?? 'Từ chối',
              event: () {
                extraOnTap?.call();
              },
              borderColor: borderColor_2,
              largeButton: true,
              icon: null,
            ),
          ),
          const SizedBox(width: sp16),
          Expanded(
            flex: 1,
            child: MainButton(
              title: mainTitle ?? 'Phê duyệt',
              event: () {
                isDisable ? mainOnTap?.call() : null;
              },
              largeButton: true,
              icon: null,
            ),
          ),
        ],
      ),
    );
  }
}

// class LeftButton extends StatelessWidget {
//   final String? title;
//   final VoidCallback? onTap;
//   final bool largeButton;
//   final Color? borderColor;
//   final Widget? icon;
//   final Color? bgColor;
//   final EdgeInsetsGeometry? padding;

//   const LeftButton({
//     Key? key,
//     this.title,
//     this.onTap,
//     required this.largeButton,
//     this.borderColor,
//     this.icon,
//     this.bgColor,
//     this.padding,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return OutlinedButton(
//       style: OutlinedButton.styleFrom(
//           backgroundColor: bgColor ?? whiteColor,
//           padding: padding ??
//               const EdgeInsets.symmetric(horizontal: sp16, vertical: sp12),
//           shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(sp8)),
//           side: BorderSide(
//               color: borderColor ?? borderColor_2, width: 1)),
//       onPressed: () {
//         onTap?.call();
//       },
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           icon ?? const SizedBox.shrink(),
//           if (icon != null && title != null) const SizedBox(width: sp8),
//           if (title != null)
//             AutoSizeText(
//               '$title',
//               style:
//               (largeButton ? h6 : p5).copyWith(
//                 color: blackColor,
//               ),
//             )
//         ],
//       ),
//     );
//   }
// }

// class RightButton extends StatelessWidget {
//   final String? title;
//   final VoidCallback? onTap;
//   final bool largeButton;
//   final Widget? icon;
//   final EdgeInsetsGeometry? padding;
//   final bool isDisable;

//   const RightButton({
//     Key? key,
//     this.title,
//     this.onTap,
//     required this.largeButton,
//     this.icon,
//     this.padding,
//     this.isDisable = true,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//           elevation: 0,
//           backgroundColor: isDisable ? mainColor : accentColor_3,
//           padding: padding ??
//               const EdgeInsets.symmetric(horizontal: sp16, vertical: sp12),
//           shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
//       onPressed: () {
//         onTap?.call();
//       },
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           icon ?? const SizedBox.shrink(),
//           if (icon != null && title != null) const SizedBox(width: sp8),
//           if (title != null)
//             AutoSizeText(
//               '$title',
//               style: largeButton ? h6 : p5,
//             )
//         ],
//       ),
//     );
//   }
// }
