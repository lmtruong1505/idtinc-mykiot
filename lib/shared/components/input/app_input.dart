import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../style_app/init_style.dart';

// ignore: non_constant_identifier_names
Widget AppInputV2({
  String? initialValue,
  String? label,
  required String hintText,
  TextEditingController? controller,
  TextInputType textInputType = TextInputType.text,
  Widget? suffixIcon,
  Widget? prefixIcon,
  Function(String? value)? validate,
  bool show = true,
  bool isPassword = false,
  int? maxLines = 1,
  int? minLines = 1,
  FocusNode? fn,
  bool required = false,
  Function()? onTap,
  Color? borderColor,
  Color? backgroundColor,
  Function(String)? onChanged,
  Function(String)? onConfirm,
  Function()? onTapOutside,
  bool readOnly = false,
  TextAlign textAlign = TextAlign.start,
  TextStyle? labelStyle,
  List<TextInputFormatter>? inputFormatters,
  double radius = 12,
  EdgeInsets? contentPadding,
  TextStyle? hintStyle,
  bool? isDense,
  BoxConstraints? suffixIconConstraints,
  BoxConstraints? prefixIconConstraints,
  BorderRadius? borderRadius,
  Key? key,
}) {
  return TextFormField(
    key: key,
    initialValue: initialValue,
    readOnly: readOnly,
    onTap: () {
      if (onTap != null) onTap();
    },
    onChanged: (String? value) {
      if (value != null && onChanged != null) {
        onChanged(value);
      }
    },
    onFieldSubmitted: (value) {
      if (onConfirm != null) {
        onConfirm(value);
      }
    },
    onTapOutside: (event) =>
        onTapOutside?.call() ?? FocusManager.instance.primaryFocus?.unfocus(),
    keyboardType: textInputType,
    controller: controller,
    obscureText: !show,
    focusNode: fn,
    textAlign: textAlign,
    validator: (value) {
      return validate?.call(value);
    },
    minLines: minLines,
    maxLines: show ? maxLines : 1,
    inputFormatters: inputFormatters,
    decoration: InputDecoration(
      isDense: isDense,
      fillColor: backgroundColor,
      filled: backgroundColor != null,
      label: label == null
          ? null
          : RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text: label,
                style: labelStyle ?? StyleApp.medium(),
                children: [
                  if (required)
                    TextSpan(
                      text: ' *',
                      style: StyleApp.medium(color: ColorApp.red),
                    ),
                ],
              ),
            ),
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(
            vertical: Dimensions.sp12,
            horizontal: Dimensions.sp16,
          ),
      border: OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: borderColor ?? AppColors.input_borderDefault,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: borderColor ?? AppColors.input_borderDefault,
          width: 1,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: borderColor ?? AppColors.input_borderDefault,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(radius),
        borderSide: const BorderSide(
          color: AppColors.input_borderFocus,
          width: 1,
        ),
      ),
      hintText: hintText,
      hintStyle: hintStyle ?? StyleApp.normal(color: ColorApp.grey),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      suffixIconConstraints: suffixIconConstraints,
      prefixIconConstraints: prefixIconConstraints,
    ),
  );
}

Widget AppInputV3({
  String? initialValue,
  String? label,
  required String hintText,
  TextEditingController? controller,
  TextInputType textInputType = TextInputType.text,
  Widget? suffixIcon,
  Widget? prefixIcon,
  Function(String? value)? validate,
  bool show = true,
  bool isPassword = false,
  int? maxLines = 1,
  int? minLines = 1,
  FocusNode? fn,
  bool required = false,
  Function()? onTap,
  Color? borderColor,
  Color? backgroundColor,
  Function(String)? onChanged,
  Function(String)? onConfirm,
  Function()? onTapOutside,
  bool readOnly = false,
  TextAlign textAlign = TextAlign.start,
  TextStyle? labelStyle,
  List<TextInputFormatter>? inputFormatters,
  double radius = 12,
  EdgeInsets? contentPadding,
  TextStyle? hintStyle,
  String? extraText,
  VoidCallback? extraOnTap,
}) {
  return Row(
    children: [
      TextFormField(
        initialValue: initialValue,
        readOnly: readOnly,
        onTap: () {
          if (onTap != null) onTap();
        },
        onChanged: (String? value) {
          if (value != null && onChanged != null) {
            onChanged(value);
          }
        },
        onFieldSubmitted: (value) {
          if (onConfirm != null) {
            onConfirm(value);
          }
        },
        onTapOutside: (event) =>
            onTapOutside?.call() ??
            FocusManager.instance.primaryFocus?.unfocus(),
        keyboardType: textInputType,
        controller: controller,
        obscureText: !show,
        focusNode: fn,
        textAlign: textAlign,
        validator: (value) {
          return validate?.call(value);
        },
        minLines: minLines,
        maxLines: show ? maxLines : 1,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          fillColor: backgroundColor,
          filled: backgroundColor != null,
          label: label == null
              ? null
              : RichText(
                  text: TextSpan(
                    text: label,
                    style: labelStyle ?? StyleApp.medium(),
                    children: [
                      if (required)
                        TextSpan(
                          text: ' *',
                          style: StyleApp.medium(color: ColorApp.red),
                        ),
                    ],
                  ),
                ),
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(
                vertical: Dimensions.sp12,
                horizontal: Dimensions.sp16,
              ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius).copyWith(
              topRight: Radius.zero,
              bottomRight: Radius.zero,
            ),
            borderSide: BorderSide(
              color: borderColor ?? AppColors.input_borderDefault,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius).copyWith(
              topRight: Radius.zero,
              bottomRight: Radius.zero,
            ),
            borderSide: BorderSide(
              color: borderColor ?? AppColors.input_borderDefault,
              width: 1,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius).copyWith(
              topRight: Radius.zero,
              bottomRight: Radius.zero,
            ),
            borderSide: BorderSide(
              color: borderColor ?? AppColors.input_borderDefault,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius).copyWith(
              topRight: Radius.zero,
              bottomRight: Radius.zero,
            ),
            borderSide: const BorderSide(
              color: AppColors.input_borderFocus,
              width: 1,
            ),
          ),
          hintText: hintText,
          hintStyle: hintStyle ?? StyleApp.normal(color: ColorApp.grey),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
        ),
      ).expanded(),
      InkWell(
        onTap: extraOnTap,
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius).copyWith(
              topLeft: Radius.zero,
              bottomLeft: Radius.zero,
            ),
            color: AppColors.bg_secondary,
            border: Border.all(
              color: borderColor ?? AppColors.input_borderDefault,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          padding: 12.padingHor,
          child: Text(
            textAlign: TextAlign.center,
            extraText ?? 'Tạo mới',
            style: AppStyle.bodySmMedium.copyWith(
              color: AppColors.button_neutral_ghost_textDefault,
            ),
          ),
        ),
      ),
    ],
  );
}
