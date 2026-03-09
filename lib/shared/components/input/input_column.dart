import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import '../../style_app/init_style.dart';
import '../button/label_button.dart';
import 'app_input.dart';

Widget InputColumn({
  TextEditingController? controller,
  required String label,
  bool isRequired = false,
  Function()? onTap,
  Widget? prefixIcon,
  Widget? suffixIcon,
  Function(String)? onChanged,
  Function(String)? onConfirm,
  Function()? onTapOutside,
  String? initialValue,
  TextInputType textInputType = TextInputType.text,
  EdgeInsets? padding,
  bool? readOnly,
  bool isPassword = false,
  List<TextInputFormatter>? inputFormatters,
  double? radius,
  int? minLines,
  int? maxLength,
  int? minLength,
  Color? fillColor,
  String? hintText,
  Function(String? value)? validate,
  Key? key,
}) {
  return Padding(
    padding: padding ?? Dimensions.sp16.pading,
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
                    color: AppColors.text_warning,
                  ),
                ),
            ],
          ),
        ),
        Dimensions.sp8.height,
        AppInputV2(
          key: key,
          backgroundColor: fillColor,
          minLines: minLines,
          maxLines: minLines,
          initialValue: initialValue,
          radius: radius ?? Dimensions.sp8,
          onChanged: onChanged,
          onConfirm: onConfirm,
          onTapOutside: onTapOutside,
          controller: controller,
          onTap: onTap,
          readOnly: readOnly ?? onTap != null,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText ??
              '${onTap != null ? "Chọn" : 'Nhập'} ${label.toLowerCase()}',
          textInputType: textInputType,
          hintStyle: AppStyle.bodyBsRegular.copyWith(
            color: AppColors.input_placeholderDefault,
          ),
          show: !isPassword,
          inputFormatters: inputFormatters ??
              [
                if (TextInputType.phone == textInputType ||
                    TextInputType.number == textInputType)
                  FilteringTextInputFormatter.digitsOnly,
              ],
          validate: validate ??
              (value) {
                if (isRequired && value.validator.trim().isEmptyOrNull) {
                  return 'Vui lòng nhập ${label.toLowerCase()}';
                }

                if (isRequired && value!.isNotEmpty) {
                  return value.validatorTextField(
                    type: textInputType,
                    // maxLength: maxLength,
                    minLength: minLength,
                  );
                }

                return null;
              },
        ),
      ],
    ),
  );
}

Widget InputColumn2({
  TextEditingController? controller,
  required String label,
  bool isRequired = false,
  Function()? onTap,
  Widget? prefixIcon,
  required String textSuffix,
  Widget? iconSuffix,
  Function(String)? onChanged,
  String? initialValue,
  TextInputType textInputType = TextInputType.name,
  EdgeInsets? padding,
  bool? readOnly,
  bool isPassword = false,
  List<TextInputFormatter>? inputFormatters,
  double? radius,
  int? minLines,
  Color? fillColor,
  String? hintText,
}) {
  return Padding(
    padding: padding ?? Dimensions.sp16.pading,
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
        AppInputV2(
          backgroundColor: fillColor,
          minLines: minLines,
          maxLines: minLines,
          initialValue: initialValue,
          radius: radius ?? Dimensions.sp8,
          onChanged: onChanged,
          controller: controller,
          onTap: onTap,
          readOnly: readOnly ?? onTap != null,
          prefixIcon: prefixIcon,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (iconSuffix != null) iconSuffix,
              const VerticalDivider(
                color: AppColors.input_borderDefault,
                thickness: 1,
                width: 0,
              ).size(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: LabelButton(
                  label: textSuffix,
                  labelStyle: AppStyle.bodySmMedium.copyWith(
                    color: AppColors.button_neutral_ghost_textDefault,
                  ),
                  padding: 12.padingHor,
                  radius: radius?.radiusRight ?? 8.radiusRight,
                  fixedSize: const Size(double.infinity, 46),
                ),
              ),
            ],
          ),
          hintText: hintText ??
              '${onTap != null ? "Chọn" : 'Nhập'} ${label.toLowerCase()}',
          textInputType: textInputType,
          hintStyle: AppStyle.bodyBsRegular.copyWith(
            color: AppColors.input_placeholderDefault,
          ),
          show: !isPassword,
          inputFormatters: inputFormatters ??
              [
                if (TextInputType.phone == textInputType ||
                    TextInputType.number == textInputType)
                  FilteringTextInputFormatter.digitsOnly,
              ],
          validate: (value) {
            if (isRequired && value.isEmptyOrNull) {
              return 'Vui lòng nhập ${label.toLowerCase()}';
            }
            if (value!.isNotEmpty) {
              return value.validatorTextField(type: textInputType);
            }
            return null;
          },
        ),
      ],
    ),
  );
}
