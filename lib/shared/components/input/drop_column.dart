import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../presentation/config/app_style/init_app_style.dart';
import '../../style_app/init_style.dart';
import '../widgets/fa_icon.dart';
import 'custom_drop_down.dart';

Widget DropDownColumn<T>({
  required String label,
  bool isRequired = false,
  List<DropdownMenuItem<T>>? items,
  Function(T?)? onChanged,
  T? value,
  EdgeInsets? padding,
  Widget? prefixIcon,
  Widget? suffixIcon,
  String? hintText,
}) {
  return Padding(
    padding: padding ?? (Dimensions.sp16.padingTop + Dimensions.sp16.padingHor),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppStyle.bodyBsMedium.copyWith(
              color: AppColors.input_label,
            ),
            children: [
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_brand_primary_variant2,
                  ),
                ),
            ],
          ),
        ),
        Dimensions.sp8.height,
        CustomDropDown<T>(
          value: value,
          onChanged: onChanged,
          items: items,
          hintText: hintText ?? 'Chọn ${label.toLowerCase()}',
          hintAlign: TextAlign.center,
          showIconRemove: false,
          color: ColorApp.white,
          radius: 8,
          borderColor: AppColors.input_borderDefault,
          required: isRequired,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          icon: FaIcon(
            iconCode: 'f0d7',
            type: FaIconType.solid,
          ),
          validate: (p0) {
            if (p0 == null && isRequired) {
              return 'Vui lòng chọn ${label.toLowerCase()}';
            }
            return null;
          },
        ),
      ],
    ),
  );
}
