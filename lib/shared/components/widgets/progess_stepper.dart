import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

class ProgessStepper extends StatelessWidget {
  final List<String> steps;
  final int current;
  const ProgessStepper({
    super.key,
    required this.steps,
    this.current = 0,
  });

  @override
  Widget build(BuildContext context) {
    // return EasyStepper(
    //   activeStep: current,
    //   activeStepTextColor: AppColors.border_brandSolid,
    //   finishedStepTextColor: AppColors.border_disabled,
    //   stepRadius: 20,
    //   padding: EdgeInsets.zero, showStepBorder: false, fitWidth: true,
    //   showLoadingAnimation: false,
    //   lineStyle: LineStyle(
    //     lineType: LineType.normal,
    //     lineThickness: 2,
    //     lineLength: context.width / steps.length,
    //   ),
    //   steps: List.generate(
    //     steps.length,
    //     (index) => EasyStep(
    //       customStep: _buildIcon(index: index),
    //       customTitle: Text(
    //         steps[index],
    //         textAlign: TextAlign.center,
    //         style: AppStyle.headingBs.copyWith(
    //           color: index == current
    //               ? AppColors.text_brand_primary_variant1
    //               : AppColors.text_quaternary,
    //         ),
    //       ),
    //     ),
    //   ),
    //   //onStepReached: (index) => setState(() => activeStep = index),
    // );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        steps.length,
        (index) => _buildStep(
          index: index,
          isLast: index == steps.length - 1,
          isFirst: index == 0,
          isCenter: index > 0 && index < steps.length - 1,
          title: steps[index],
        ),
      ),
    );
  }

  Widget _buildIcon({
    required int index,
  }) {
    final bool isActive = index <= current;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index < current
            ? AppColors.bg_brandSolid_variant1
            : AppColors.bg_primary,
        border: Border.all(
          color: isActive
              ? AppColors.bg_brandSolid_variant1
              : AppColors.border_secondary,
          width: 1.5,
        ),
      ),
      padding: 2.pading,
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive
              ? AppColors.bg_brandSolid_variant1
              : AppColors.bg_primary,
        ),
        alignment: Alignment.center,
        child: index < current
            ? Icon(
                Icons.check_rounded,
                size: 23,
                color:
                    isActive ? AppColors.text_white : AppColors.text_quaternary,
              )
            : Text(
                '${index + 1}',
                style: AppStyle.headingLg.copyWith(
                  color: isActive
                      ? AppColors.text_white
                      : AppColors.text_quaternary,
                  height: 1.2,
                ),
              ),
      ),
    );
  }

  Widget _buildStep({
    required int index,
    bool isLast = false,
    bool isFirst = false,
    bool isCenter = false,
    String? title,
  }) {
    final bool isActive = index <= current;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLast || isCenter)
              Divider(
                color: isActive
                    ? AppColors.border_brandSolid
                    : AppColors.border_tertiary,
                thickness: 2,
              ).expanded(),
            _buildIcon(index: index),
            if (isFirst || isCenter)
              Divider(
                color: isActive && index < current
                    ? AppColors.border_brandSolid
                    : AppColors.border_tertiary,
                thickness: 2,
              ).expanded(),
          ],
        ),
        if (title != null) ...[
          4.height,
          Text(
            title,
            textAlign: isCenter
                ? TextAlign.center
                : isLast
                    ? TextAlign.right
                    : TextAlign.left,
            style: AppStyle.headingBs.copyWith(
              color: index == current
                  ? AppColors.text_brand_primary_variant1
                  : AppColors.text_quaternary,
            ),
          ).padding(
            isCenter
                ? 4.padingHor
                : isFirst
                    ? 4.padingLeft
                    : 4.padingRight,
          ),
        ],
      ],
    ).expanded();
  }
}
