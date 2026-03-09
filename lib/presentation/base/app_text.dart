import 'package:flutter/widgets.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/style_app/color_app.dart';

class AppText extends StatelessWidget {
  const AppText(
    this.title, {
    super.key,
    this.style,
    this.maxLines,
    this.textAlign,
  });
  final String title;
  final TextStyle? style;
  final int? maxLines;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: style ?? s10w400.copyWith(color: ColorApp.grey79),
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
    );
  }
}
