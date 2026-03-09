import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/order/v2/widget/bts_edit_service.dart';
import 'package:pharmago/presentation/features/order/v2/widget/service_ord/service_order_item.dart';
import 'package:pharmago/presentation/features/product/domain/entities/service_entity.dart';

import '../../../../../base/empty_container.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/size_device.dart';
import '../../cubit/order_create_v2_cubit.dart';
import '../../cubit/order_create_v2_state.dart';

class ChooseServiceForOrder extends StatefulWidget {
  const ChooseServiceForOrder({super.key, required this.orderBloc});

  final OrderCreateV2Bloc orderBloc;

  @override
  State<ChooseServiceForOrder> createState() => _ChooseServiceForOrderState();
}

class _ChooseServiceForOrderState extends State<ChooseServiceForOrder> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<OrderCreateV2Bloc, OrderCreateV2State>(
          bloc: widget.orderBloc,
          builder: (context, state) {
            if(state.serviceSelected.isEmpty){
              return const EmptyContainer();
            }
            return Column(
              children: List.generate(state.serviceSelected.length, (index) {
                final item = state.serviceSelected[index];
                return InkWell(
                  onTap: () {
                    _showSessionEditAmount(item);
                  },
                  child: ServiceOrderItem(
                    item: item,
                    isSelected: true,
                    onRemove: () {
                      widget.orderBloc.removeService(item.id!);
                    },
                    onUpdate: (item) {
                      widget.orderBloc.updateService(item);
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
  void _showSessionEditAmount(ServiceEntity item) async {
    final of = heightDevice(context).toInt();
    await showModalBottomSheet(
      backgroundColor: whiteColor.withOpacity(0),
      isDismissible: false,
      isScrollControlled: true,
      barrierColor: whiteColor.withOpacity(0),
      context: context,
      builder: (context) {
        return BtsEditService(
          service: item,
          onConfirm: (item) {
            widget.orderBloc.updateService(item);
          },
          offset: of ~/ 3 + 100,
        );
      },
    );
  }
}
