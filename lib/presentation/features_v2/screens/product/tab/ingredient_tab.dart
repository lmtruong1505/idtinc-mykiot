import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/screens/product/components/bts_config_ingredient.dart';
import 'package:pharmago/presentation/features_v2/screens/product/components/item_create_ingredient.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/input/input_column.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../blocs/product/config_ingredient_bloc.dart';
import '../../../models/product/ingredient_v2_model.dart';

class IngredientTab extends StatefulWidget {
  const IngredientTab({super.key, required this.bloc});

  final ConfigIngredientBloc bloc;

  @override
  State<IngredientTab> createState() => _IngredientTabState();
}

class _IngredientTabState extends State<IngredientTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: 24.padingTop + 16.padingHor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Khối lượng cơ bản',
            style: AppStyle.headingLg,
          ),
          16.height,
          InputColumn(
            label: 'Khối lượng tịnh',
            hintText: 'VD: 12ml, 68g',
            padding: 0.pading,
            // suffixIcon: Row(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     16.width,
            //     Text(
            //       '/Hộp',
            //       style: AppStyle.bodyBsRegular.copyWith(
            //         color: AppColors.text_secondary,
            //       ),
            //     ),
            //     8.width,
            //   ],
            // ),
            // textInputType: TextInputType.number,
            onChanged: (p0) {
              // widget.bloc.basePrice = p0.removeAllDot().toInt;
            },
          ),
          16.height,
          Text(
            'Thành phần',
            style: AppStyle.headingLg,
          ),
          16.height,
          BlocBuilder<ConfigIngredientBloc, CubitState>(
            bloc: widget.bloc,
            builder: (context, state) {
              return ItemCreateIngredient(
                list: widget.bloc.list,
                onAdd: configIngredient,
                onRemove: (index) {
                  widget.bloc.remove(index);
                },
                onUpdate: (index) {
                  configIngredient(index: index);
                },
              );
            },
          ),
          16.height,
          // InputColumn(
          //   label: 'Tá dược',
          //   hintText: 'Nhập thành phần tá dược',
          //   padding: 0.pading,
          //   onChanged: (p0) {
          //     // widget.bloc.basePrice = p0.removeAllDot().toInt;
          //   },
          //   minLines: 3,
          // ),
          // 16.height,
        ],
      ),
    );
  }

  configIngredient({int? index}) {
    context
        .bottomSheet(
      BtsConfigIngredient(
        ingredient: index != null ? widget.bloc.list[index] : null,
      ),
    ).then((value) {
      if (value != null && value is IngredientV2Model) {
        if (index == null) {
          widget.bloc.addTypes(value);
        } else {
          widget.bloc.update(index, value);
        }
      }
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
