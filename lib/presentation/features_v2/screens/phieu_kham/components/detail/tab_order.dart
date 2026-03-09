import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';
import 'package:pharmago/presentation/features_v2/models/calendar/event_model.dart';
import 'package:pharmago/presentation/features_v2/screens/customer/components/item_order.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import '../../../../../features/order/cubit/order_create_cubit/order_create_state.dart';
import '../../../../blocs/order/list_order_bloc.dart';
import '../../../../blocs/state/init_state.dart';

class TabOrderPhieuKham extends StatefulWidget {
  final TypeOrderEnum type;
  final EventModel item;
  const TabOrderPhieuKham({
    super.key,
    required this.type,
    required this.item,
  });
  @override
  State<TabOrderPhieuKham> createState() => _TabOrderPhieuKhamState();
}

class _TabOrderPhieuKhamState extends State<TabOrderPhieuKham>
    with AutomaticKeepAliveClientMixin {
  final bloc = ListOrderBloc();
  final scroll = ScrollController();
  @override
  void initState() {
    super.initState();
    bloc.type = widget.type;
    bloc.medicalBill = widget.item.uuid;
    bloc.getList();
    scroll.onMore(
      () => bloc.getList(
        isMore: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BlocBuilder<ListOrderBloc, CubitState>(
          bloc: bloc,
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                await bloc.getList();
              },
              child: LoadListPage(
                state: state,
                listEmpty: bloc.orders.isEmpty,
                child: ListView.separated(
                  padding: sp16.pading,
                  controller: scroll,
                  itemBuilder: (context, index) => ItemOrder(
                    order: bloc.orders[index],
                    isCustomer: true,
                  ),
                  separatorBuilder: (context, index) => sp16.height,
                  itemCount: bloc.orders.length,
                ).expanded(),
              ),
            );
          },
        ).expanded(),
        MainButtonV2(
          onTap: () {
            if (widget.type == TypeOrderEnum.sell) {
              context.pushRoute(
                OrderCreateProdRoute(
                  typeCreate: OrderType.product,
                  mbUuid: widget.item.uuid,
                ),
              );
            } else if (widget.type == TypeOrderEnum.service) {
              context.pushRoute(
                OrderCreateServiceRoute(
                  typeCreate: OrderType.service,
                  mbUuid: widget.item.uuid,
                ),
              );
            } else if (widget.type == TypeOrderEnum.prescription) {
              context.pushRoute(
                CreatePrescriptionRoute(
                  item: widget.item,
                ),
              );
            }
          },
          title: widget.type.title,
        ).container(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
