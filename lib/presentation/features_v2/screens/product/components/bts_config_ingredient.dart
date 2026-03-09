import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features_v2/models/product/ingredient_v2_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/input/input_column.dart';
import '../../../../../shared/components/bg/bg_bts.dart';

class BtsConfigIngredient extends StatefulWidget {
  const BtsConfigIngredient({super.key, this.ingredient});

  final IngredientV2Model? ingredient;

  @override
  State<BtsConfigIngredient> createState() => _BtsConfigIngredientState();
}

class _BtsConfigIngredientState extends State<BtsConfigIngredient> {

  late IngredientV2Model ingredient;
  final key = GlobalKey<FormState>();
  @override
  void initState() {
    ingredient = widget.ingredient ?? IngredientV2Model();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: BgBts(
        label: 'Thêm thành phần',
        cancelText: 'Huỷ',
        onCancel: () {
          context.pop();
        },
        confirmText: 'Xác nhận',
        onConfirm: () {
          if (!key.currentState!.validate()) {
            return;
          }
          context.pop(result: ingredient);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputColumn(
              label: 'Tên thành phần',
              hintText: 'VD: Irbesartan',
              padding: 0.pading,
              initialValue: ingredient.name,
              onChanged: (p0) {
                ingredient.name = p0;
              },
              isRequired: true,
            ),
            16.height,
            InputColumn(
              label: 'Hàm lượng',
              hintText: 'VD: 300mg',
              padding: 0.pading,
              initialValue: ingredient.weight?.toString(),
              onChanged: (p0) {
                ingredient.weight = p0;
              },
            ),
          ],
        ),
      ),
    );
  }
}
