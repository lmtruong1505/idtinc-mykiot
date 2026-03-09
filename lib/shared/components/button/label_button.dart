import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';

class LabelButton extends StatelessWidget {
  final String label;
  final Function()? onPressed;
  final bool isBorder;
  final BorderSide? border;
  final BorderRadius? radius;
  final Color? backgroundColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final EdgeInsets? padding;
  final double spaceIcon;
  final TextStyle? labelStyle;
  final TextAlign? labelAlign;
  final FlexFit fit;
  final Alignment? alignment;
  final Size? fixedSize;
  const LabelButton({
    super.key,
    required this.label,
    this.onPressed,
    this.border,
    this.backgroundColor = AppColors.brand,
    this.radius,
    this.isBorder = true,
    this.suffixIcon,
    this.prefixIcon,
    this.padding,
    this.labelStyle,
    this.labelAlign,
    this.spaceIcon = 8,
    this.fit = FlexFit.loose,
    this.alignment,
    this.fixedSize,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        alignment: alignment,
        shape: RoundedRectangleBorder(
          borderRadius: radius ?? BorderRadius.circular(20),
          side: isBorder && border != null ? border! : BorderSide.none,
        ),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        fixedSize: fixedSize,
        disabledBackgroundColor:
            backgroundColor != null ? Colors.grey.shade200 : null,
        foregroundColor: backgroundColor?.withOpacity(0.1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefixIcon != null)
            Padding(
              padding: EdgeInsets.only(right: spaceIcon),
              child: prefixIcon,
            ),
          Flexible(
            fit: fit,
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: labelStyle?.copyWith(height: 1) ??
                  s14w500.copyWith(color: AppColors.white, height: 1),
              textAlign: labelAlign,
            ),
          ),
          if (suffixIcon != null)
            Padding(
              padding: EdgeInsets.only(left: spaceIcon),
              child: suffixIcon,
            ),
        ],
      ),
    );
  }
}

class ColumnLabelButton extends StatelessWidget {
  final String title;
  final String label;
  final bool? isRequire;
  final Function()? onPressed;
  final bool isBorder;
  final BorderSide? border;
  final BorderRadius? radius;
  final Color? backgroundColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final EdgeInsets? padding;
  final double spaceIcon;
  final TextStyle? labelStyle;
  final TextAlign? labelAlign;
  final FlexFit fit;
  final Alignment? alignment;
  final Size? fixedSize;
  const ColumnLabelButton({
    super.key,
    required this.title,
    required this.label,
    this.isRequire,
    this.onPressed,
    this.border,
    this.backgroundColor = AppColors.brand,
    this.radius,
    this.isBorder = true,
    this.suffixIcon,
    this.prefixIcon,
    this.padding,
    this.labelStyle,
    this.labelAlign,
    this.spaceIcon = 8,
    this.fit = FlexFit.loose,
    this.alignment,
    this.fixedSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: AppStyle.bodyBsMedium.copyWith(
              color: AppColors.input_label,
            ),
            children: [
              if (isRequire ?? false)
                TextSpan(
                  text: ' *',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_brand_primary_variant2,
                  ),
                ),
            ],
          ),
        ),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor,
            alignment: alignment,
            shape: RoundedRectangleBorder(
              borderRadius: radius ?? BorderRadius.circular(20),
              side: isBorder && border != null ? border! : BorderSide.none,
            ),
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            fixedSize: fixedSize,
            disabledBackgroundColor:
                backgroundColor != null ? Colors.grey.shade200 : null,
            foregroundColor: backgroundColor?.withOpacity(0.1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (prefixIcon != null)
                Padding(
                  padding: EdgeInsets.only(right: spaceIcon),
                  child: prefixIcon,
                ),
              Flexible(
                fit: fit,
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: labelStyle ?? AppStyle.medium(color: AppColors.white),
                  textAlign: labelAlign,
                ),
              ),
              if (suffixIcon != null)
                Padding(
                  padding: EdgeInsets.only(left: spaceIcon),
                  child: suffixIcon,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
