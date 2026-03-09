import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';

import '../../shared/components/widgets/fa_icon.dart';
import '../config/app_style/init_app_style.dart';

class CommonDropdown<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>>? items;
  final Function(T?)? onChanged;
  final String hintText;
  final T? value;
  final Color? color;
  final Color? borderColor;
  final double? fontSize;
  final double iconSize;
  final String? label;
  final bool required;
  final bool showIconRemove;
  final FocusNode? focusNode;
  final List<BoxShadow>? boxShadow;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? radius;
  final double? height;
  final double? maxHeight;
  // String? Function(dynamic)? validator;
  const CommonDropdown({
    super.key,
    required this.items,
    this.onChanged,
    required this.hintText,
    this.value,
    this.color,
    this.borderColor,
    this.fontSize,
    this.iconSize = 18,
    this.label,
    this.required = false,
    this.showIconRemove = true,
    this.focusNode,
    this.boxShadow,
    this.prefixIcon,
    this.suffixIcon,
    this.radius,
    this.height,
    this.maxHeight,
    // this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          RichText(
            text: TextSpan(
              text: label,
              style: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.input_label,
              ),
              children: [
                if (required)
                  TextSpan(text: ' *', style: p5.copyWith(color: red_1)),
              ],
            ),
          ),
        if (label != null) const SizedBox(height: sp8),
        Container(
          decoration: BoxDecoration(
            color: color ?? whiteColor,
            borderRadius: BorderRadius.circular(radius ?? sp12),
            boxShadow: boxShadow ??
                [
                  BoxShadow(
                    color: blackColor.withOpacity(0.05), // Màu của shadow
                    // spreadRadius: sp4, // Bán kính lan truyền của shadow
                    blurRadius: sp2, // Độ mờ của shadow
                    offset: const Offset(0, 2), // Độ dịch chuyển của shadow
                  ),
                ],
          ),
          child: DropdownButtonFormField2(
            value: value,
            focusNode: focusNode,
            decoration: InputDecoration(
              isDense: false,
              focusColor: blue_1,
              contentPadding: const EdgeInsets.all(sp0),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor ?? borderColor_2),
                borderRadius: BorderRadius.circular(radius ?? sp12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.brand),
                borderRadius: BorderRadius.circular(radius ?? sp12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.brand),
                borderRadius: BorderRadius.circular(radius ?? sp12),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor ?? borderColor_2),
                borderRadius: BorderRadius.circular(radius ?? sp12),
              ),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
            ),
            isExpanded: true,
            hint: Text(
              hintText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.input_placeholderDefault,
              ),
            ),
            validator: (value) {
              if (required && value == null) {
                return 'Vui lòng chọn ${label?.toLowerCase() ?? ''}';
              }
              return null;
            },
            items: items,
            onChanged: onChanged,
            onSaved: (value) {},
            buttonStyleData: ButtonStyleData(
              height: height ?? sp48,
              padding: const EdgeInsets.only(left: sp0, right: sp12),
            ),
            iconStyleData: IconStyleData(
              icon: Row(
                children: [
                  if (value != null && showIconRemove)
                    IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: blackColor,
                        size: 15,
                      ),
                      onPressed: () {
                        onChanged?.call(null);
                      },
                    ),
                  Visibility(
                    visible: suffixIcon == null,
                    child: FaIcon(
                      iconCode: 'f0d7',
                      type: FaIconType.solid,
                    ),
                  ),
                ],
              ),
              iconSize: iconSize,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: maxHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sp8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
