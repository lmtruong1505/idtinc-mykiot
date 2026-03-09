import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../../base/v2/expanded_section.dart';
import '../../../blocs/local/bool_bloc.dart';

class BgAction extends StatelessWidget {
  final Widget child;
  final String title;
  final bool click;
  final bool isTextClick;
  final bool isCheckBox;
  final bool valueBox;
  final double fontSize;
  final Color? colorTitle;
  final Function(bool?)? onChangeBox;
  final TextStyle? styleTitle;
  final Widget? icon;
  final String? textClickTitle;
  final TextStyle? textClickStyle;

  BgAction({
    super.key,
    required this.title,
    required this.child,
    this.click = false,
    this.isCheckBox = false,
    this.valueBox = false,
    this.fontSize = 12,
    this.isTextClick = true,
    this.colorTitle,
    this.onChangeBox,
    this.styleTitle,
    this.icon,
    this.textClickTitle,
    this.textClickStyle,
  });
  final boolBloc = BoolBloc();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoolBloc, bool>(
      bloc: boolBloc,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: ColorApp.white,
            borderRadius: Dimensions.sp8.radius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  if(icon != null) icon!.padding(4.padingLeft),
                  if (isCheckBox)
                    Checkbox(
                      value: valueBox,
                      onChanged: onChangeBox,
                      activeColor: ColorApp.main,
                    ).padding(4.padingLeft),
                  Expanded(
                    child: InkWell(
                      onTap: !click
                          ? null
                          : () {
                              boolBloc.change(!state);
                            },
                      child: Padding(
                        padding: isCheckBox ? Dimensions.sp16.padingVer : Dimensions.sp16.pading,
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: styleTitle ?? StyleApp.semibold(
                            color: colorTitle ?? ColorApp.grey79,
                            fontSize: fontSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (click)
                    InkWell(
                      onTap: !click
                          ? null
                          : () {
                              boolBloc.change(!state);
                            },
                      child: Padding(
                        padding: Dimensions.sp12.pading,
                        child: Row(
                          children: [
                            if (isTextClick)
                              Text(
                                state ? (textClickTitle ?? 'Thu gọn') : (textClickTitle ?? 'Mở rộng'),
                                style: textClickStyle ?? StyleApp.normal(
                                  color: ColorApp.blue20,
                                  fontSize: 12,
                                ),
                              ),
                            AnimatedRotation(
                              turns: !state ? 0 : -0.5,
                              duration: const Duration(milliseconds: 300),
                              child: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                key: ValueKey('icon2'),
                                size: 15,
                                color: ColorApp.grey79,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              if (state)
                const Divider(
                  height: 0,
                  color: ColorApp.greyF5,
                ),
              if (!click) child,
              if (click)
                ExpandedSection(
                  isSelected: state,
                  child: child,
                ),
            ],
          ),
        );
      },
    );
  }
}
