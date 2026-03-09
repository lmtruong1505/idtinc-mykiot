import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/features_v2/models/variant_kafa/variant_kafa_model.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
class InputQuantity extends StatelessWidget {
   const InputQuantity({super.key, this.changeAmount, required this.amountTec, required this.item, required this.focusNode});

  final TextEditingController amountTec;
  final Function(VariantKafaModel, int)? changeAmount;
  final VariantKafaModel item;
  final FocusNode focusNode;


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppInputSupport(
          controller: amountTec,
          textInputType: TextInputType.number,
          hintText: 'Số lượng',
          textAlign: TextAlign.center,
          onChanged: (value) => changeAmount?.call(
            item,
            int.tryParse(value) ?? 0,
          ),
          onTapOutside: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          fn: focusNode,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          backgroundColor: bg_4,
          borderColor: bg_4,
          radius: 9999,
          maxLines: 1,
          padding: 8.pading,
          isDense: true,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: InkWell(
            onTap: () {
              if (item.amount == 0) {
                return;
              }
              changeAmount?.call(
                item,
                item.amount - 1,
              );
            },
            child: const SizedBox(
              height: 32,
              width: 32,
              child: Center(
                child: Icon(
                  Icons.remove,
                  size: sp16,
                  color: ColorApp.black,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: () {
              changeAmount?.call(
                item,
                item.amount + 1,
              );
            },
            child: const SizedBox(
              height: 32,
              width: 32,
              child: Center(
                child: Icon(
                  Icons.add,
                  size: sp16,
                  color: ColorApp.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
