import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/input/app_input.dart';
import '../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../blocs/product/config_sell_bloc.dart';

class TablePriceItem extends StatelessWidget {
  const TablePriceItem({super.key, required this.bloc});

  final ConfigSellBloc bloc;

  @override
  Widget build(BuildContext context) {
    print('TablePriceItem');
    return BlocBuilder<ConfigSellBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        if (bloc.list.isEmpty) {
          return Container();
        }
        return Container(
          decoration: BoxDecoration(
            borderRadius: 12.radius,
            border: Border.all(color: AppColors.border_tertiary),
          ),
          child: ClipRRect(
            borderRadius: 12.radius,
            clipBehavior: Clip.hardEdge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader().container(
                  bgColor: AppColors.bg_secondary_subtle,
                  radius: 0,
                  padding: 0.pading,
                ),
                const Divider(
                  color: AppColors.border_tertiary,
                  height: 0,
                  thickness: 1,
                ),
                ...List.generate(
                  bloc.list.length,
                  (index) => _buildTag(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          'Cấp',
          overflow: TextOverflow.ellipsis,
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_tertiary,
          ),
        ).expanded(flex: 2),
        Text(
          'Giá quy đổi',
          overflow: TextOverflow.ellipsis,
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_tertiary,
          ),
        ).expanded(flex: 5),
      ],
    ).padding(12.pading);
  }

  _buildTag(int index) {
    print('===> ${bloc.list[index].sellPrice.formatCurrency}');
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cấp ${bloc.list[index].level}',
              style: AppStyle.bodyBsMedium.copyWith(
                height: 1.2,
              ),
            ),
            Text(
              bloc.list[index].name ?? '',
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_tertiary,
                height: 1.5,
              ),
            ),
          ],
        ).expanded(flex: 2),
        AppInputV2(
          hintText: '',
          inputFormatters: [
            CurrencyTextInputFormatter.currency(locale: 'vi', symbol: ''),
          ],
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              16.width,
              FaIcon(
                iconCode: 'e169',
                color: AppColors.input_iconDefault,
              ),
            ],
          ),
          controller: TextEditingController(text: bloc.list[index].sellPrice.formatCurrency),
          textInputType: TextInputType.number,
          readOnly: bloc.list[index].sellUnit ?? false,
          onChanged: bloc.list[index].sellUnit == true ? null : (p0) {
              bloc.list[index].sellPrice = p0.removeAllDot().toDouble;
          },
          backgroundColor: bloc.list[index].sellUnit ?? false
              ? AppColors.bg_secondary_subtle
              : null,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '/${bloc.list[index].name}',
                style: AppStyle.bodyBsRegular.copyWith(
                  color: AppColors.text_secondary,
                ),
              ),
              12.width,
            ],
          ),
        ).expanded(flex: 5),
      ],
    ).padding(12.pading);
  }
}
