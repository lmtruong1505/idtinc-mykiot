import 'package:flutter/material.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/order/cubit/order_list_cubit/order_list_cubit.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../base/infinite_list.dart';
import '../../../base/loading.dart';
import '../../../di/di.dart';
import '../../order/domain/entities/order_preview_entity.dart';
import '../../order/screens/order_list_page.dart';
class OrderInfoView extends StatefulWidget {
  const OrderInfoView({super.key, required this.id});

  final int id;

  @override
  State<OrderInfoView> createState() => _OrderInfoViewState();
}

class _OrderInfoViewState extends State<OrderInfoView> {
  final myBloc = getIt.get<OrderListCubit>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 16.pading,
      child: SingleChildScrollView(
        controller: myBloc.scrollController,
        child: Column(
          children: [
            _buildListOrder(context),
          ],
        ),
      ),
    );
  }

  Widget _buildListOrder(BuildContext context) {
    return InfiniteList<OrderPreviewEntity>(
      shrinkWrap: true,
      getData: (page) async {
        return myBloc.getList(page, id: widget.id);
      },
      itemBuilder: (context, item, index) {
        return gapHeight(sp0);
        // ItemOrder(
        //   order: item,
        // );
      },
      scrollController: myBloc.scrollController,
      infiniteListController: myBloc.infiniteListController,
      noItemFoundWidget: emptyOrder(context, myBloc, idBranch: widget.id),
      circularProgressIndicator: const BaseLoading(),
    );
  }
}
