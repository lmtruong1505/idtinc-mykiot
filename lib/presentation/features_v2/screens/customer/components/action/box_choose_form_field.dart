import 'package:flutter/material.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../../../shared/style_app/init_style.dart';

// ignore: must_be_immutable
class BoxChooseFormField extends StatelessWidget {
  String? value;
  Function()? onTap;
  bool isRequired;
  IconData icon;
  Function()? validator;
  String label;
  BoxChooseFormField({
    super.key,
    this.value,
    this.onTap,
    this.isRequired = false,
    required this.icon,
    required this.label,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: (value) => validator?.call(),
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding:  Dimensions.sp16.pading,
                margin: Dimensions.sp16.padingTop + Dimensions.sp16.padingHor,
                decoration: BoxDecoration(
                  color: ColorApp.tealF2,
                  borderRadius: Dimensions.sp16.radius,
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: ColorApp.white,
                        borderRadius: Dimensions.sp16.radius,
                      ),
                      width: 75,
                      height: 75,
                      alignment: Alignment.center,
                      child: Icon(
                        icon,
                        color: ColorApp.main,
                      ),
                    ),
                    Dimensions.sp16.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Text(
                                label,
                                style: StyleApp.semibold(
                                  color: ColorApp.grey79,
                                  fontSize: 12,
                                ),
                              ),
                              const Spacer(),
                              if (isRequired)
                                Text(
                                  '* Bắt buộc',
                                  style: StyleApp.normal(
                                    color: ColorApp.red,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                          Dimensions.sp4.height,
                          if (value != null)
                            Text(
                              value ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: StyleApp.normal(),
                            ),
                          Dimensions.sp4.height,
                          Text(
                            '${value == null ? 'Chọn' : "Thay đổi"} ${label.toLowerCase()}',
                            style: StyleApp.medium(
                              color: ColorApp.blue20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Dimensions.sp16.width,
                  ],
                ),
              ),
            ),
            if (field.hasError && isRequired)
              Padding(
                padding: 6.padingTop + Dimensions.sp16.padingHor + Dimensions.sp12.padingHor,
                child: Text(
                  field.errorText ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        );
      },
    );
  }
}
