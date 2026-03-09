import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/customer/data/models/customer_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/calendar/list_event_bloc.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../blocs/state/init_state.dart';
import '../../../calendar/components/item_event.dart';

class TabCalendarCustomer extends StatefulWidget {
  final CustomerModel customer;
  const TabCalendarCustomer({
    super.key,
    required this.customer,
  });

  @override
  State<TabCalendarCustomer> createState() => _TabCalendarCustomerState();
}

class _TabCalendarCustomerState extends State<TabCalendarCustomer>
    with AutomaticKeepAliveClientMixin {
  final bloc = ListEventBloc();
  final scroll = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getList(
      customer: widget.customer.id ?? 0,
    );
    scroll.onMore(
      () => bloc.getList(
        customer: widget.customer.id ?? 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ListEventBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            await bloc.getList(
              customer: widget.customer.id ?? 0,
            );
          },
          child: LoadListPage(
            state: state,
            listEmpty: bloc.list.isEmpty,
            child: ListView.separated(
              padding: sp16.pading,
              controller: scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) => ItemEvent(
                event: bloc.list[index],
              ),
              separatorBuilder: (context, index) => sp16.height,
              itemCount: bloc.list.length,
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
