import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmago/gen/flutter_assets.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

class BgDetail extends StatelessWidget {
  final Widget child;
  const BgDetail({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height,
      width: context.width,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -5,
            child: Opacity(
              opacity: 0.1,
              child: RotatedBox(
                quarterTurns: 90,
                child: SvgPicture.asset(
                  Assets.svgBgDetail,
                  width: context.width,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(
            height: context.height,
            width: context.width,
            child: child,
          ),
        ],
      ),
    );
  }
}
