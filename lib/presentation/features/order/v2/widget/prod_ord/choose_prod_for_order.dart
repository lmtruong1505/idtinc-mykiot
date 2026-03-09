import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/features/order/v2/cubit/order_create_v2_state.dart';
import 'package:pharmago/presentation/features/order/v2/widget/prod_ord/variant_order_item.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/size_device.dart';
import '../../../../product/domain/entities/variant_entity.dart';
import '../../cubit/order_create_v2_cubit.dart';
import '../bts_edit_amout.dart';

class ChooseProdForOrder extends StatefulWidget {
   const ChooseProdForOrder({
    super.key, required this.orderBloc,

  });

   final OrderCreateV2Bloc orderBloc;

  @override
  State<ChooseProdForOrder> createState() => _ChooseProdForOrderState();
}

class _ChooseProdForOrderState extends State<ChooseProdForOrder>
    with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<OrderCreateV2Bloc, OrderCreateV2State>(
          bloc: widget.orderBloc,
          builder: (context, state) {
            if(state.variantSelected.isEmpty){
              return const EmptyContainer();
            }
            return Column(
              children: List.generate(state.variantSelected.length, (index) {
                final item = state.variantSelected[index];
                print('=======> 2 ${item.units?.first.sellPrice}');
                return InkWell(
                  onTap: () {
                    _showSessionEditAmount(item);
                  },
                  child: VariantOrderItem(
                    item: item,
                    isSelected: true,
                    onRemove: () {
                      widget.orderBloc.removeVariant(item.id!);
                    },
                    onUpdate: (item) {
                      widget.orderBloc.updateVariant(item);
                    },
                  ),
                );
              }),
            );
          },
        )
      ],
    );
  }
  void _showSessionEditAmount(VariantEntity item) async {
    final of = heightDevice(context).toInt();
    await showModalBottomSheet(
      backgroundColor: whiteColor.withOpacity(0),
      isDismissible: false,
      isScrollControlled: true,
      barrierColor: whiteColor.withOpacity(0),
      context: context,
      builder: (context) {
        return BtsEditAmount(
          variant: item,
          onConfirm: (item) {
            widget.orderBloc.updateVariant(item);
          },
          offset: of ~/ 3 + 100,
        );
      },
    );
  }
}
