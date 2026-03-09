import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../presentation/config/app_style/init_app_style.dart';

typedef RangeInputValidator = String? Function(String? value1, String? value2);

class RangeInput extends StatefulWidget {
  final double radius;
  final Color? borderColor;
  final String? hintStart;
  final String? hintEnd;
  final EdgeInsets? contentPadding;
  final Function(String start, String end) onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final TextInputType textInputType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool isRequired;
  final String? value1;
  final String? value2;
  final RangeInputValidator? validator;
  final Function()? onTap;
  final TextEditingController? controller1;
  final TextEditingController? controller2;
  const RangeInput({
    Key? key,
    this.radius = 8,
    this.borderColor,
    this.hintStart,
    this.hintEnd,
    this.contentPadding,
    required this.onChanged,
    this.inputFormatters,
    this.readOnly = false,
    this.textInputType = TextInputType.number,
    this.suffixIcon,
    this.prefixIcon,
    this.isRequired = false,
    this.value1,
    this.value2,
    this.validator,
    this.onTap,
    this.controller1,
    this.controller2,
  }) : super(key: key);

  @override
  State<RangeInput> createState() => _RangeInputState();
}

class _RangeInputState extends State<RangeInput> {
  final FocusNode focusNode1 = FocusNode();

  final FocusNode focusNode2 = FocusNode();

  late TextEditingController controller1;

  late TextEditingController controller2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller1 = widget.controller1 ?? TextEditingController();
    controller2 = widget.controller2 ?? TextEditingController();

    controller1.text = widget.value1 ?? '';
    controller2.text = widget.value2 ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      builder: (field) {
        return AnimatedBuilder(
          animation: Listenable.merge(<Listenable>[
            focusNode1,
            focusNode2,
          ]),
          builder: (BuildContext context, Widget? child) {
            return GestureDetector(
              onTap: widget.onTap ??
                  () {
                    if (controller1.text.isEmpty && controller2.text.isEmpty) {
                      focusNode1.requestFocus();
                    } else if (controller1.text.isEmpty) {
                      focusNode1.requestFocus();
                    } else if (controller2.text.isEmpty) {
                      focusNode2.requestFocus();
                    }
                  },
              child: InputDecorator(
                decoration: theme.copyWith(errorText: field.errorText),
                isFocused: focusNode1.hasFocus || focusNode2.hasFocus,
                child: Row(
                  children: [
                    if (widget.prefixIcon != null)
                      widget.prefixIcon!.padding(8.padingRight),
                    Expanded(
                      child: input(
                        focus: focusNode1,
                        controller: controller1,
                        hintText: widget.hintStart,
                      ),
                    ),
                    if (widget.suffixIcon != null)
                      widget.suffixIcon!.padding(8.padingLeft),
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text('đến'),
                    ),
                    if (widget.prefixIcon != null)
                      widget.prefixIcon!.padding(8.padingRight),
                    Expanded(
                      child: input(
                        focus: focusNode2,
                        controller: controller2,
                        hintText: widget.hintEnd,
                      ),
                    ),
                    if (widget.suffixIcon != null)
                      widget.suffixIcon!.padding(8.padingLeft),
                  ],
                ),
              ),
            );
          },
        );
      },
      validator: (value) {
        if (widget.validator != null) {
          return widget.validator!(controller1.text, controller2.text);
        }
        if (widget.isRequired == false) {
          return null;
        }
        if (controller1.text.isEmpty || controller2.text.isEmpty) {
          return 'Không bỏ trống';
        }
        return null;
      },
    );
  }

  InputDecoration get theme {
    return InputDecoration(
      contentPadding:
          widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 16),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.input_borderFocus),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.input_borderFocus),
      ),
      // errorBorder: border.copyWith(
      //   borderSide: const BorderSide(color: AppColors.red60),
      // ),
    );
  }

  OutlineInputBorder get border => OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.radius),
        borderSide: BorderSide(
          color: widget.borderColor ?? AppColors.input_borderDefault,
        ),
      );

  TextField input({
    FocusNode? focus,
    TextEditingController? controller,
    String? hintText,
  }) {
    return TextField(
      focusNode: focus,
      controller: controller,
      onTap: widget.onTap,
      onChanged: (value) {
        widget.onChanged(controller1.text, controller2.text);
      },
      textInputAction: TextInputAction.done,
      inputFormatters: widget.inputFormatters,
      style: AppStyle.bodyBsMedium,
      maxLines: 1,
      readOnly: widget.readOnly,
      keyboardType: widget.textInputType,
      decoration: InputDecoration.collapsed(
        hintText: hintText ?? 'Ngày',
        border: InputBorder.none,
        hintStyle: AppStyle.bodyBsRegular.copyWith(
          color: AppColors.input_placeholderDefault,
        ),
      ),
    );
  }
}
