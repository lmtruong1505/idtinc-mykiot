import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/order/list_order_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import '../../../../../constants/spacing.dart';
import '../../../../../features/customer/data/models/customer_model.dart';
import '../item_order.dart';

class TabOrderCustomer extends StatefulWidget {
  final CustomerModel customer;
  const TabOrderCustomer({
    super.key,
    required this.customer,
  });

  @override
  State<TabOrderCustomer> createState() => _TabOrderCustomerState();
}

class _TabOrderCustomerState extends State<TabOrderCustomer>
    with AutomaticKeepAliveClientMixin {
  final bloc = ListOrderBloc();
  final scroll = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getList(
      customerId: widget.customer.id,
    );
    scroll.onMore(
      () {
        bloc.getList(customerId: widget.customer.id, isMore: true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ListOrderBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            await bloc.getList(
              customerId: widget.customer.id,
            );
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
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
