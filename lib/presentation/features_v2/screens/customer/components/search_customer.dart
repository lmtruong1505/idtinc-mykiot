import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/text_field.dart';

import '../../../../../shared/style_app/init_style.dart';


Widget SearchCustomer({
  required String hint,
  Function(String)? onChanged,
}) {
  return AppInput(
    hintText: hint,
    borderColor: ColorApp.greyE2,
    backgroundColor: ColorApp.white,
    radius: Dimensions.sp8,
    prefixIcon: const Icon(
      Icons.search,
      color: ColorApp.black,
    ),
    onChanged: onChanged,
  );
}
